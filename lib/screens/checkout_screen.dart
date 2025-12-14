import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _timeController;
  String _paymentMethod = 'Carte Bleue';

  @override
  void initState() {
    super.initState();
    final cart = context.read<CartService>();
    _nameController = TextEditingController(text: cart.temporaryReferenceName);
    _timeController = TextEditingController(text: cart.temporaryPickupTime);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final cart = context.read<CartService>();
      cart.temporaryReferenceName = _nameController.text;
      cart.temporaryPickupTime = _timeController.text;

      // On retourne les informations à l'écran précédent
      Navigator.of(context).pop({
        'name': _nameController.text,
        'time': _timeController.text,
        'payment': _paymentMethod,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finaliser la commande'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Veuillez compléter ces informations pour finaliser votre commande.', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom pour la commande', hintText: 'Ex: Paul', border: OutlineInputBorder()),
                autofocus: true,
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un nom' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Heure de retrait souhaitée', hintText: 'Ex: 19h30', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer une heure' : null,
              ),
              const SizedBox(height: 24),
              Text('Mode de paiement:', style: Theme.of(context).textTheme.titleMedium),
              RadioListTile<String>(
                title: const Text('Carte Bleue'),
                value: 'Carte Bleue',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
              RadioListTile<String>(
                title: const Text('Paypal'),
                value: 'Paypal',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Valider les informations'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: _submit,
        ),
      ),
    );
  }
}
