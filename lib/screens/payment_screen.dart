import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/payment_service.dart';
import '../database/app_database.dart';
import '../services/order_service.dart';
import '../services/sync_service.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final int orderId; // Changé en int pour correspondre à la DB

  const PaymentScreen({super.key, required this.total, required this.orderId});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  bool _saveCard = false;

  // --- LOGIQUE PAIEMENT IMMÉDIAT ---
  Future<void> _handleOnlinePayment(PaymentService paymentService) async {
    setState(() => _isProcessing = true);
    try {
      // 1. Préparer le formulaire Stripe
      await paymentService.initPaymentSheet(
        amount: widget.total,
        saveCard: _saveCard,
      );

      // 2. Afficher le formulaire et attendre confirmation
      final success = await paymentService.presentAndConfirm();

      if (success && mounted) {
        await _finalizeOrder(context, 'paid');
      }
    } catch (e) {
      _showError('Erreur d\'initialisation : $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // --- LOGIQUE GARANTIE (SUR PLACE) ---
  Future<void> _handlePlaceGuarantee(PaymentService paymentService) async {
    setState(() => _isProcessing = true);
    try {
      // 1. Préparer une empreinte de carte (sans débit)
      await paymentService.initSetupIntent();

      // 2. Afficher le formulaire
      final success = await paymentService.presentAndConfirm();

      if (success && mounted) {
        await _finalizeOrder(context, 'guaranteed');
      }
    } catch (e) {
      _showError('Erreur garantie : $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _finalizeOrder(BuildContext context, String paymentStatus) async {
    final orderService = context.read<OrderService>();
    final syncService = context.read<SyncService>();

    // Mettre à jour le statut dans Supabase
    await orderService.updatePaymentStatus(widget.orderId, paymentStatus);
    await syncService.syncAll();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(paymentStatus == 'paid' ? '✅ Paiement réussi !' : '✅ Empreinte carte validée !'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    final paymentService = context.read<PaymentService>();
    final db = context.watch<AppDatabase>();

    return Scaffold(
      appBar: AppBar(title: Text('Règlement ${widget.total.toStringAsFixed(2)} € TTC')),
      body: StreamBuilder<CompanyInfoData?>(
        stream: db.watchCompanyInfo(),
        builder: (context, snapshot) {
          final isRealPaymentEnabled = snapshot.data?.isPaymentEnabled ?? false;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.shield_outlined, size: 64, color: Colors.blueGrey),
                const SizedBox(height: 16),
                const Text(
                  'Sélectionnez votre mode de règlement',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                // SECTION PAIEMENT CARTE
                if (isRealPaymentEnabled) ...[
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : () => _handleOnlinePayment(paymentService),
                    icon: const Icon(Icons.credit_card),
                    label: const Text('Payer maintenant par Carte'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('Enregistrer cette carte pour mes prochains achats', style: TextStyle(fontSize: 13)),
                    value: _saveCard,
                    onChanged: (val) => setState(() => _saveCard = val ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const Divider(height: 48),
                ],

                // SECTION SUR PLACE (AVEC OU SANS GARANTIE)
                ElevatedButton.icon(
                  onPressed: _isProcessing 
                    ? null 
                    : () => isRealPaymentEnabled ? _handlePlaceGuarantee(paymentService) : _finalizeOrder(context, 'pending'),
                  icon: const Icon(Icons.store),
                  label: Text(isRealPaymentEnabled ? 'Payer sur place (Garantie carte)' : 'Payer sur place'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
                
                if (isRealPaymentEnabled)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Une empreinte de carte sera demandée pour garantir votre commande.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ),

                const Spacer(),
                if (_isProcessing) const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}
