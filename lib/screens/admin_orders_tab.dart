import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../services/sync_service.dart';
import '../services/preferences_service.dart';
import 'order_detail_screen.dart';

class AdminOrdersTab extends StatefulWidget {
  const AdminOrdersTab({super.key});

  @override
  State<AdminOrdersTab> createState() => _AdminOrdersTabState();
}

class _AdminOrdersTabState extends State<AdminOrdersTab> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  RealtimeChannel? _ordersChannel;
  late TabController _tabController;
  bool _showArchiveButton = true;

  DateTime? _filterStartDate, _filterEndDate, _archiveStartDate, _archiveEndDate;
  bool _areOrdersOpen = true;
  DateTime? _vacationStartDate, _vacationEndDate, _tempClosureStartDate, _tempClosureEndDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() => _showArchiveButton = _tabController.index == 0);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _listenToNewOrders();
    });
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
          print('🔔 Nouvelle commande détectée !');
          if (prefs.visualNotification) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🔔 Nouvelle commande reçue !'), backgroundColor: Colors.blue));
          }
          if (prefs.soundNotification) {
            _audioPlayer.play(AssetSource('sounds/notification.mp3'));
          }
          syncService.syncAll();
        }
      },
    ).subscribe();
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (_ordersChannel != null) Supabase.instance.client.removeChannel(_ordersChannel!);
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
        actions: [
          if (_showArchiveButton)
            TextButton.icon(
              icon: const Icon(Icons.archive_outlined),
              label: const Text('Archiver le travail du jour'),
              onPressed: () { /* TODO */ },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list_alt), text: 'Commandes'),
            Tab(icon: Icon(Icons.settings), text: 'Réglages'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrdersList(startDate: _filterStartDate, endDate: _filterEndDate),
          SettingsTab(
            initialFilterStartDate: _filterStartDate,
            initialFilterEndDate: _filterEndDate,
            areOrdersOpen: _areOrdersOpen,
            vacationStartDate: _vacationStartDate,
            vacationEndDate: _vacationEndDate,
            tempClosureStartDate: _tempClosureStartDate,
            tempClosureEndDate: _tempClosureEndDate,
            archiveStartDate: _archiveStartDate,
            archiveEndDate: _archiveEndDate,
            onFilterDateChanged: (start, end) => setState(() {
              _filterStartDate = start;
              _filterEndDate = end;
            }),
            onOrdersOpenChanged: (value) => setState(() => _areOrdersOpen = value),
            onVacationDateChanged: (start, end) => setState(() {
              _vacationStartDate = start;
              _vacationEndDate = end;
            }),
            onTempClosureDateChanged: (start, end) => setState(() {
              _tempClosureStartDate = start;
              _tempClosureEndDate = end;
            }),
            onArchiveDateChanged: (start, end) => setState(() {
              _archiveStartDate = start;
              _archiveEndDate = end;
            }),
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

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    return StreamBuilder<List<OrderWithStatus>>(
      stream: db.watchAllOrdersWithStatus(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var allOrders = snapshot.data ?? [];
        if (startDate != null) {
          final startOfDay = DateTime(startDate!.year, startDate!.month, startDate!.day);
          allOrders = allOrders.where((o) => o.order.createdAt.isAfter(startOfDay)).toList();
        }
        if (endDate != null) {
          final endOfDay = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
          allOrders = allOrders.where((o) => o.order.createdAt.isBefore(endOfDay)).toList();
        }
        if (allOrders.isEmpty) {
          return const Center(child: Text('Aucune commande à afficher pour cette période.'));
        }
        final toDoOrders = allOrders.where((o) => o.status == 'À faire').toList();
        final readyOrders = allOrders.where((o) => o.status == 'Prête').toList();
        return ListView(
          padding: const EdgeInsets.only(top: 8),
          children: [
            _buildSection(context, 'À PRÉPARER', toDoOrders),
            const Divider(height: 32, thickness: 1.5, indent: 16, endIndent: 16),
            _buildSection(context, 'PRÊTES', readyOrders),
          ],
        );
      },
    );
  }

   Widget _buildSection(BuildContext context, String title, List<OrderWithStatus> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: Row(children: [Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(width: 8), CircleAvatar(radius: 12, child: Text(orders.length.toString()))])),
        if (orders.isEmpty)
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), child: Text('Aucune commande dans cette section.'))
        else
          ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: orders.length, itemBuilder: (context, index) {
            final orderWithStatus = orders[index];
            final order = orderWithStatus.order;
            return Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), child: ListTile(title: Text('Commande de ${order.referenceName ?? 'N/A'}'), subtitle: Text('Pour ${order.pickupTime ?? 'N/A'}'), trailing: Text.rich(TextSpan(style: const TextStyle(fontSize: 16), children: [TextSpan(text: order.total.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)), const TextSpan(text: ' € TTC', style: TextStyle(fontSize: 10, color: Colors.grey))])), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order, status: orderWithStatus.status)))));
          }),
      ],
    );
  }
}

class SettingsTab extends StatelessWidget {
  final DateTime? initialFilterStartDate, initialFilterEndDate, vacationStartDate, vacationEndDate, tempClosureStartDate, tempClosureEndDate, archiveStartDate, archiveEndDate;
  final bool areOrdersOpen;
  final Function(DateTime?, DateTime?) onFilterDateChanged, onVacationDateChanged, onTempClosureDateChanged, onArchiveDateChanged;
  final Function(bool) onOrdersOpenChanged;

  const SettingsTab({
    super.key,
    required this.onFilterDateChanged, required this.onOrdersOpenChanged, required this.onVacationDateChanged, required this.onTempClosureDateChanged, required this.onArchiveDateChanged,
    this.initialFilterStartDate, this.initialFilterEndDate, required this.areOrdersOpen, this.vacationStartDate, this.vacationEndDate, this.tempClosureStartDate, this.tempClosureEndDate, this.archiveStartDate, this.archiveEndDate,
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
        const Divider(height: 32),
        _buildSectionTitle(context, 'Messages rapides'),
        _buildDateRangeCard(context, title: 'En congés', startDate: vacationStartDate, endDate: vacationEndDate, onStartDateSelected: (date) => onVacationDateChanged(date, vacationEndDate), onEndDateSelected: (date) => onVacationDateChanged(vacationStartDate, date)),
        _buildDateRangeCard(context, title: 'Fermeture temporaire', startDate: tempClosureStartDate, endDate: tempClosureEndDate, onStartDateSelected: (date) => onTempClosureDateChanged(date, tempClosureEndDate), onEndDateSelected: (date) => onTempClosureDateChanged(tempClosureStartDate, date)),
        const Card(child: ListTile(title: Text('Reservation complete'), trailing: Icon(Icons.copy_all_outlined))),
        const Divider(height: 32),
        // ✅ CORRIGÉ: Section Archive restaurée
        _buildSectionTitle(context, 'Visualiser les archives'),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton.icon(icon: const Icon(Icons.inventory_2_outlined), label: Text(archiveStartDate == null ? 'Date de début' : dateFormat.format(archiveStartDate!)), onPressed: () => _selectDate(context, initialDate: archiveStartDate, onDateSelected: (date) => onArchiveDateChanged(date, archiveEndDate))),
          ElevatedButton.icon(icon: const Icon(Icons.inventory), label: Text(archiveEndDate == null ? 'Date de fin' : dateFormat.format(archiveEndDate!)), onPressed: () => _selectDate(context, initialDate: archiveEndDate, onDateSelected: (date) => onArchiveDateChanged(archiveStartDate, date))),
        ]),
      ],
    );
  }

  Widget _buildDateRangeCard(BuildContext context, {required String title, DateTime? startDate, DateTime? endDate, required Function(DateTime) onStartDateSelected, required Function(DateTime) onEndDateSelected}) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Card(child: Padding(padding: const EdgeInsets.all(8.0), child: Column(children: [ListTile(title: Text(title), trailing: const Icon(Icons.copy_all_outlined)), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [TextButton(child: Text(startDate == null ? 'Début' : dateFormat.format(startDate)), onPressed: () => _selectDate(context, initialDate: startDate, onDateSelected: onStartDateSelected)), TextButton(child: Text(endDate == null ? 'Fin' : dateFormat.format(endDate)), onPressed: () => _selectDate(context, initialDate: endDate, onDateSelected: onEndDateSelected))])])));
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(padding: const EdgeInsets.only(bottom: 8.0, top: 8.0), child: Text(title, style: Theme.of(context).textTheme.titleLarge));
  }
}
