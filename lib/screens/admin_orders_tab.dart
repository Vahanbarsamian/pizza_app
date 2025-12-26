import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../services/sync_service.dart';
import '../services/preferences_service.dart';
import '../services/admin_service.dart';
import '../services/notification_service.dart';
import 'order_detail_screen.dart';

enum ClosureMessageType { vacation, temporary, full, custom }

class AdminOrdersTab extends StatefulWidget {
  const AdminOrdersTab({super.key});

  @override
  State<AdminOrdersTab> createState() => _AdminOrdersTabState();
}

class _AdminOrdersTabState extends State<AdminOrdersTab> with SingleTickerProviderStateMixin {
  RealtimeChannel? _ordersChannel;
  late TabController _tabController;
  late TextEditingController _customClosureMessageController;

  DateTime? _filterStartDate, _filterEndDate, _archiveStartDate, _archiveEndDate;
  bool _areOrdersOpen = true;
  DateTime? _vacationStartDate, _vacationEndDate, _tempClosureStartDate, _tempClosureEndDate;
  ClosureMessageType? _selectedClosureMessage;
  bool _isSavingSettings = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _customClosureMessageController = TextEditingController();
    _loadInitialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _listenToNewOrders();
    });
  }

  Future<void> _loadInitialData() async {
    final db = context.read<AppDatabase>();
    final info = await db.getCompanyInfo();
    if (info != null && mounted) {
      setState(() {
        _areOrdersOpen = info.ordersEnabled;
        _vacationStartDate = info.closureStartDate;
        _vacationEndDate = info.closureEndDate;
        if (info.closureMessageType != null) {
          try {
            _selectedClosureMessage = ClosureMessageType.values.byName(info.closureMessageType!);
          } catch (e) { _selectedClosureMessage = null; }
        }
        _customClosureMessageController.text = info.closureCustomMessage ?? '';
      });
    }
  }

  void _listenToNewOrders() {
    final syncService = context.read<SyncService>();
    final prefs = context.read<PreferencesService>();
    _ordersChannel = Supabase.instance.client.channel('public:orders');
    _ordersChannel?.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'orders',
      callback: (payload) {
        if (mounted) {
          if (prefs.visualNotification) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🔔 Nouvelle commande reçue !'), backgroundColor: Colors.blue));
          }
          if (prefs.soundNotification) {
            NotificationService.playNotification();
          }
          syncService.syncAll();
        }
      },
    ).subscribe();
  }

  Future<void> _archiveWork() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmer l\'archivage"),
        content: const Text('Voulez-vous vraiment archiver toutes les commandes terminées aujourd\'hui ?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Archiver', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirmed && mounted) {
      final adminService = context.read<AdminService>();
      final syncService = context.read<SyncService>();
      try {
        await adminService.archiveTodaysWork();
        await syncService.syncAll();
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Archivage terminé.'), backgroundColor: Colors.green));
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customClosureMessageController.dispose();
    if (_ordersChannel != null) Supabase.instance.client.removeChannel(_ordersChannel!);
    super.dispose();
  }

  Future<void> _saveSettings() async {
    setState(() => _isSavingSettings = true);
    final adminService = context.read<AdminService>();
    final syncService = context.read<SyncService>();

    DateTime? startDate, endDate;
    if (_selectedClosureMessage == ClosureMessageType.vacation) {
      startDate = _vacationStartDate;
      endDate = _vacationEndDate;
    } else if (_selectedClosureMessage == ClosureMessageType.temporary) {
      startDate = _tempClosureStartDate;
      endDate = _tempClosureEndDate;
    }

    try {
      await adminService.saveStoreStatus(
        ordersEnabled: _areOrdersOpen,
        messageType: _selectedClosureMessage,
        startDate: startDate,
        endDate: endDate,
        customMessage: _customClosureMessageController.text,
      );
      await syncService.syncAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Réglages sauvegardés !'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isSavingSettings = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text('Admin / Commandes'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.orange,
              tabs: const [
                Tab(icon: Icon(Icons.list_alt), text: 'Commandes'),
                Tab(icon: Icon(Icons.inventory_2_outlined), text: 'Archives'),
                Tab(icon: Icon(Icons.settings), text: 'Réglages'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OrdersList(startDate: _filterStartDate, endDate: _filterEndDate),
                ArchivesTab(
                  archiveStartDate: _archiveStartDate, 
                  archiveEndDate: _archiveEndDate, 
                  onArchiveDateChanged: (start, end) => setState(() => { _archiveStartDate = start, _archiveEndDate = end }), 
                  onArchivePressed: _archiveWork
                ),
                SettingsTab(
                  isSaving: _isSavingSettings,
                  initialFilterStartDate: _filterStartDate, initialFilterEndDate: _filterEndDate,
                  areOrdersOpen: _areOrdersOpen, vacationStartDate: _vacationStartDate, vacationEndDate: _vacationEndDate,
                  tempClosureStartDate: _tempClosureStartDate, tempClosureEndDate: _tempClosureEndDate,
                  selectedClosureMessage: _selectedClosureMessage, customClosureMessageController: _customClosureMessageController,
                  onFilterDateChanged: (start, end) => setState(() => { _filterStartDate = start, _filterEndDate = end }),
                  onOrdersOpenChanged: (value) => setState(() => { _areOrdersOpen = value, if (value) _selectedClosureMessage = null }),
                  onVacationDateChanged: (start, end) => setState(() => { _vacationStartDate = start, _vacationEndDate = end }),
                  onTempClosureDateChanged: (start, end) => setState(() => { _tempClosureStartDate = start, _tempClosureEndDate = end }),
                  onClosureMessageChanged: (type) => setState(() => _selectedClosureMessage = type),
                  onSave: _saveSettings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  const OrdersList({super.key, this.startDate, this.endDate});

  TimeOfDay _parsePickupTime(String timeStr) {
    try {
      final cleanedTime = timeStr.replaceAll('h', ':').replaceAll('H', ':');
      final parts = cleanedTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return const TimeOfDay(hour: 23, minute: 59);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final adminService = Provider.of<AdminService>(context, listen: false);
    final syncService = Provider.of<SyncService>(context, listen: false);

    return StreamBuilder<List<OrderWithStatus>>(
      stream: db.watchAllOrdersWithStatus(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var allOrders = snapshot.data ?? [];
        allOrders = allOrders.where((o) => o.order.isArchived != true).toList();

        if (startDate != null) {
          final startOfDay = DateTime(startDate!.year, startDate!.month, startDate!.day);
          allOrders = allOrders.where((o) => o.order.createdAt.isAfter(startOfDay)).toList();
        }
        if (endDate != null) {
          final endOfDay = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
          allOrders = allOrders.where((o) => o.order.createdAt.isBefore(endOfDay)).toList();
        }

        allOrders.sort((a, b) {
          final dateA = DateTime(a.order.createdAt.year, a.order.createdAt.month, a.order.createdAt.day);
          final dateB = DateTime(b.order.createdAt.year, b.order.createdAt.month, b.order.createdAt.day);
          int dateComparison = dateB.compareTo(dateA);
          if (dateComparison != 0) return dateComparison;
          final timeA = _parsePickupTime(a.order.pickupTime ?? '');
          final timeB = _parsePickupTime(b.order.pickupTime ?? '');
          return (timeA.hour * 60 + timeA.minute).compareTo(timeB.hour * 60 + timeB.minute);
        });

        if (allOrders.isEmpty) return const Center(child: Text('Aucune commande.'));
        
        final toDoOrders = allOrders.where((o) => o.status == 'À faire').toList();
        final readyOrders = allOrders.where((o) => o.status == 'Prête').toList();

        return ListView(
          children: [
            _buildSection(context, 'À PRÉPARER', toDoOrders, adminService, syncService),
            const Divider(height: 32),
            _buildSection(context, 'PRÊTES', readyOrders, adminService, syncService),
          ],
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, String title, List<OrderWithStatus> orders, AdminService adminService, SyncService syncService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.all(16), child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
        ...orders.map((o) => OrderCard(orderWithStatus: o, adminService: adminService, syncService: syncService)),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderWithStatus orderWithStatus;
  final AdminService adminService;
  final SyncService syncService;

  const OrderCard({super.key, required this.orderWithStatus, required this.adminService, required this.syncService});

  // ✅ NOUVEAU: Boîte de dialogue pour confirmer la suppression
  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la commande'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette commande ? Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text('Supprimer', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await adminService.deleteOrder(orderWithStatus.order.id);
        await syncService.syncAll();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('🗑️ Commande supprimée.'), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la suppression: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = orderWithStatus.order;
    final isPaid = order.paymentStatus == 'paid';
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order, status: orderWithStatus.status))),
        title: Text('Commande #${order.id} - ${order.referenceName}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Heure: ${order.pickupTime}'),
            Text(
              isPaid ? 'PAYÉE' : 'À PAYER SUR PLACE (Garanti par carte)',
              style: TextStyle(
                color: isPaid ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${order.total.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold)),
            // ✅ RÉTABLI: Icône corbeille pour supprimer une commande
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _confirmDelete(context),
              tooltip: 'Supprimer la commande',
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  final bool isSaving;
  final DateTime? initialFilterStartDate, initialFilterEndDate, vacationStartDate, vacationEndDate, tempClosureStartDate, tempClosureEndDate;
  final bool areOrdersOpen;
  final ClosureMessageType? selectedClosureMessage;
  final TextEditingController customClosureMessageController;
  final Function(DateTime?, DateTime?) onFilterDateChanged, onVacationDateChanged, onTempClosureDateChanged;
  final Function(bool) onOrdersOpenChanged;
  final Function(ClosureMessageType?) onClosureMessageChanged;
  final VoidCallback onSave;

  const SettingsTab({
    super.key,
    required this.isSaving,
    required this.onFilterDateChanged, required this.onOrdersOpenChanged, required this.onVacationDateChanged, required this.onTempClosureDateChanged,
    this.initialFilterStartDate, this.initialFilterEndDate, required this.areOrdersOpen, this.vacationStartDate, this.vacationEndDate, this.tempClosureStartDate, this.tempClosureEndDate,
    required this.selectedClosureMessage, required this.onClosureMessageChanged, required this.onSave, required this.customClosureMessageController,
  });

  Future<void> _selectDate(BuildContext context, {required DateTime? initialDate, required Function(DateTime) onDateSelected}) async {
    final newDate = await showDatePicker(context: context, initialDate: initialDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (newDate != null) onDateSelected(newDate);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle(context, 'Filtrer les commandes visibles'),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton.icon(icon: const Icon(Icons.calendar_today_outlined), label: Text(initialFilterStartDate == null ? 'Date de début' : dateFormat.format(initialFilterStartDate!)), onPressed: () => _selectDate(context, initialDate: initialFilterStartDate, onDateSelected: (date) => onFilterDateChanged(date, initialFilterEndDate))),
          ElevatedButton.icon(icon: const Icon(Icons.calendar_today), label: Text(initialFilterEndDate == null ? 'Date de fin' : dateFormat.format(initialFilterEndDate!)), onPressed: () => _selectDate(context, initialDate: initialFilterEndDate, onDateSelected: (date) => onFilterDateChanged(initialFilterStartDate, date))),
        ]),
        const Divider(height: 32),

        _buildSectionTitle(context, 'Gestion des Commandes'),
        SwitchListTile(title: const Text('Prise de commandes'), subtitle: Text(areOrdersOpen ? 'Ouverte' : 'Fermée'), value: areOrdersOpen, onChanged: onOrdersOpenChanged),
        
        if (!areOrdersOpen)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, 'Message de fermeture'),
                RadioListTile<ClosureMessageType>(
                  title: const Text('En congés'),
                  value: ClosureMessageType.vacation,
                  groupValue: selectedClosureMessage,
                  onChanged: (value) => onClosureMessageChanged(value),
                ),
                if (selectedClosureMessage == ClosureMessageType.vacation)
                  _buildDateRangeInputs(context, startDate: vacationStartDate, endDate: vacationEndDate, onStartDateSelected: (date) => onVacationDateChanged(date, vacationEndDate), onEndDateSelected: (date) => onVacationDateChanged(vacationStartDate, date)),
                
                RadioListTile<ClosureMessageType>(
                  title: const Text('Fermeture temporaire'),
                  value: ClosureMessageType.temporary,
                  groupValue: selectedClosureMessage,
                  onChanged: (value) => onClosureMessageChanged(value),
                ),
                if (selectedClosureMessage == ClosureMessageType.temporary)
                  _buildDateRangeInputs(context, startDate: tempClosureStartDate, endDate: tempClosureEndDate, onStartDateSelected: (date) => onTempClosureDateChanged(date, tempClosureEndDate), onEndDateSelected: (date) => onTempClosureDateChanged(tempClosureStartDate, date)),

                RadioListTile<ClosureMessageType>(
                  title: const Text('Complet'),
                  value: ClosureMessageType.full,
                  groupValue: selectedClosureMessage,
                  onChanged: (value) => onClosureMessageChanged(value),
                ),

                RadioListTile<ClosureMessageType>(
                  title: const Text('Message personnalisé'),
                  value: ClosureMessageType.custom,
                  groupValue: selectedClosureMessage,
                  onChanged: (value) => onClosureMessageChanged(value),
                ),
                if (selectedClosureMessage == ClosureMessageType.custom)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      controller: customClosureMessageController,
                      decoration: const InputDecoration(labelText: 'Votre message', border: OutlineInputBorder()),
                      maxLines: 3,
                    ),
                  ),
              ],
            ),
          ),

        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            onPressed: isSaving ? null : onSave,
            child: isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 8),
                      Text(
                        'Enregistrer les modifications',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeInputs(BuildContext context, {DateTime? startDate, DateTime? endDate, required Function(DateTime) onStartDateSelected, required Function(DateTime) onEndDateSelected}) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        TextButton(child: Text(startDate == null ? 'Début' : dateFormat.format(startDate)), onPressed: () => _selectDate(context, initialDate: startDate, onDateSelected: onStartDateSelected)), 
        TextButton(child: Text(endDate == null ? 'Fin' : dateFormat.format(endDate)), onPressed: () => _selectDate(context, initialDate: endDate, onDateSelected: onEndDateSelected))
      ]),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(padding: const EdgeInsets.only(bottom: 8.0, top: 8.0), child: Text(title, style: Theme.of(context).textTheme.titleLarge));
  }
}

class ArchivesTab extends StatefulWidget {
  final DateTime? archiveStartDate;
  final DateTime? archiveEndDate;
  final Function(DateTime?, DateTime?) onArchiveDateChanged;
  final Future<void> Function() onArchivePressed;

  const ArchivesTab({
    super.key, 
    this.archiveStartDate, 
    this.archiveEndDate, 
    required this.onArchiveDateChanged, 
    required this.onArchivePressed
  });

  @override
  State<ArchivesTab> createState() => _ArchivesTabState();
}

class _ArchivesTabState extends State<ArchivesTab> {
  List<Order> _archivedOrders = [];
  bool _isLoading = false;

  Future<void> _fetchArchives() async {
    setState(() => _isLoading = true);
    final db = context.read<AppDatabase>();
    try {
      final results = await db.getArchivedOrders(widget.archiveStartDate, widget.archiveEndDate);
      setState(() {
        _archivedOrders = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _selectDate(BuildContext context, {required DateTime? initialDate, required Function(DateTime) onDateSelected}) async {
    final newDate = await showDatePicker(context: context, initialDate: initialDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (newDate != null) onDateSelected(newDate);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Column(
      children: [
        Card(margin: const EdgeInsets.all(16.0), elevation: 4, child: Padding(padding: const EdgeInsets.all(8.0), child: Column(children: [Text('Actions', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 8), TextButton.icon(icon: const Icon(Icons.archive_outlined, color: Colors.red), label: const Text('Archiver les commandes terminées du jour', style: TextStyle(color: Colors.red)), onPressed: widget.onArchivePressed)]))),
        Card(margin: const EdgeInsets.fromLTRB(16, 0, 16, 16), elevation: 4, child: Padding(padding: const EdgeInsets.all(8.0), child: Column(children: [Text('Rechercher dans les archives', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 8), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ElevatedButton.icon(icon: const Icon(Icons.calendar_today_outlined), label: Text(widget.archiveStartDate == null ? 'Début' : dateFormat.format(widget.archiveStartDate!)), onPressed: () => _selectDate(context, initialDate: widget.archiveStartDate, onDateSelected: (date) => widget.onArchiveDateChanged(date, widget.archiveEndDate))), ElevatedButton.icon(icon: const Icon(Icons.calendar_today), label: Text(widget.archiveEndDate == null ? 'Fin' : dateFormat.format(widget.archiveEndDate!)), onPressed: () => _selectDate(context, initialDate: widget.archiveEndDate, onDateSelected: (date) => widget.onArchiveDateChanged(widget.archiveStartDate, date)))]), const SizedBox(height: 8), 
        SizedBox(
          width: double.infinity, 
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _isLoading ? null : _fetchArchives, 
            child: _isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Afficher', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
        )]))),
        Expanded(child: _isLoading ? const Center(child: CircularProgressIndicator()) : _archivedOrders.isEmpty ? const Center(child: Text('Aucun résultat pour cette période.')) : ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: _archivedOrders.length, itemBuilder: (context, index) {
          final order = _archivedOrders[index];
          return Card(child: ListTile(title: Text('Commande de ${order.referenceName ?? 'N/A'}'), subtitle: Text('Archivée le ${dateFormat.format(order.createdAt)} '), trailing: Text('${order.total.toStringAsFixed(2)} €')));
        }))
      ],
    );
  }
}
