class PaymentScreen extends StatefulWidget {
  final double total;
  final String orderId;

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isProcessing = false;

  Future<void> processStripePayment() async {
    setState(() => isProcessing = true);

    final data = await PaymentService.createPaymentIntent(widget.total, widget.orderId);
    await PaymentService.initPaymentSheet(data['clientSecret']);
    await PaymentService.presentPaymentSheet();

    // Confirmation automatique côté serveur
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Commande confirmée !'))
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paiement ${widget.total}€')),
      body: Column(
        children: [
          ElevatedButton.icon(
            onPressed: isProcessing ? null : processStripePayment,
            icon: Icon(Icons.payment),
            label: Text('Carte bancaire'),
          ),
          ElevatedButton.icon(
            onPressed: () => launchUrl(Uri.parse('paypal://pay?token=xxx')),
            icon: Icon(Icons.account_balance),
            label: Text('PayPal'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Paiement sur place
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('💰 À payer ${widget.total}€ à l\'accueil'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            icon: Icon(Icons.store),
            label: Text('Sur place'),
          ),
        ],
      ),
    );
  }
}