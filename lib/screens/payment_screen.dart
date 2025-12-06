import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final String orderId;

  const PaymentScreen({super.key, required this.total, required this.orderId});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isProcessing = false;

  Future<void> processStripePayment() async {
    setState(() => isProcessing = true);

    try {
      final data = await PaymentService.createPaymentIntent(widget.total, widget.orderId);
      await PaymentService.initPaymentSheet(data['clientSecret']);
      await PaymentService.presentPaymentSheet();

      // Confirmation automatique côté serveur
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Commande confirmée !'))
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de paiement: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paiement ${widget.total.toStringAsFixed(2)} € TTC')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: isProcessing ? null : processStripePayment,
              icon: const Icon(Icons.payment),
              label: const Text('Carte bancaire'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => launchUrl(Uri.parse('paypal://pay?token=xxx')), // NOTE: URL d'exemple
              icon: const Icon(Icons.account_balance_wallet),
              label: const Text('PayPal'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Paiement sur place
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('💰 À payer ${widget.total.toStringAsFixed(2)} € TTC à l'accueil'),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 3),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12)
              ),
              icon: const Icon(Icons.store),
              label: const Text('Sur place'),
            ),
          ],
        ),
      ),
    );
  }
}
