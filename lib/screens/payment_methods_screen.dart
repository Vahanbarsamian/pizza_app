import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/app_database.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  bool _isDeleting = false;
  Map<String, String>? _cardDetails;
  bool _isLoadingCard = false;

  @override
  void initState() {
    super.initState();
    _loadCardDetails();
  }

  Future<void> _loadCardDetails() async {
    final authService = context.read<AuthService>();
    final paymentService = context.read<PaymentService>();
    final db = context.read<AppDatabase>();

    final user = await (db.select(db.users)..where((u) => u.id.equals(authService.currentUser!.id))).getSingleOrNull();
    
    if (user?.stripeCustomerId != null) {
      setState(() => _isLoadingCard = true);
      final details = await paymentService.getSavedCardDetails(user!.stripeCustomerId!);
      if (mounted) {
        setState(() {
          _cardDetails = details;
          _isLoadingCard = false;
        });
      }
    }
  }

  Future<void> _removeCard() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la carte ?'),
        content: const Text('Voulez-vous vraiment supprimer votre moyen de paiement enregistré ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isDeleting = true);
      try {
        final db = context.read<AppDatabase>();
        final authService = context.read<AuthService>();
        
        await (db.update(db.users)..where((u) => u.id.equals(authService.currentUser!.id)))
            .write(const UsersCompanion(stripeCustomerId: Value(null)));
            
        if (mounted) {
          setState(() => _cardDetails = null);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Moyen de paiement supprimé')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Erreur : $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isDeleting = false);
      }
    }
  }

  void _showSecurityInfo() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.green,
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Sécurité des moyens de paiements',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const Text(
          'Vos informations bancaires sont sécurisées par Stripe. L\'application ne stocke aucun numéro de carte.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moyen de Paiement'),
        actions: [
          // ✅ AJOUT: Icône Information avec fond vert
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Sécurité',
            onPressed: _showSecurityInfo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'VOTRE CARTE ENREGISTRÉE',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _isLoadingCard 
              ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
              : Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            _cardDetails != null ? Icons.credit_card : Icons.credit_card_off,
                            size: 40,
                            color: _cardDetails != null ? Colors.green : Colors.grey,
                          ),
                          title: Text(
                            _cardDetails != null 
                              ? '${_cardDetails!['brand']} •••• ${_cardDetails!['last4']}' 
                              : 'Aucune carte enregistrée',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            _cardDetails != null 
                              ? 'Cette carte sera proposée par défaut pour vos règlements.' 
                              : 'Vous pourrez en enregistrer une lors de votre prochain achat.',
                          ),
                        ),
                        if (_cardDetails != null) ...[
                          const Divider(height: 32),
                          _isDeleting
                              ? const CircularProgressIndicator()
                              : TextButton.icon(
                                  onPressed: _removeCard,
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  label: const Text('Supprimer cette carte', style: TextStyle(color: Colors.red)),
                                ),
                        ],
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
