import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // ✅ AJOUT : Pour le style défilant
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
  bool _isLoading = false;

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

  // ✅ MODIFIÉ: Sélecteur avec défilement (style roue)
  void _selectTime(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              // Barre de contrôle au-dessus du défilement
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ANNULER', style: TextStyle(color: Colors.red)),
                    ),
                    const Text('CHOISIR L\'HEURE', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        // Si le champ est vide, on met l'heure actuelle par défaut
                        if (_timeController.text.isEmpty) {
                          final now = DateTime.now();
                          _timeController.text = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
                        }
                        Navigator.pop(context);
                      },
                      child: const Text('VALIDER', style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ),
              ),
              // La roue de défilement
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      final String hour = newDateTime.hour.toString().padLeft(2, '0');
                      final String minute = newDateTime.minute.toString().padLeft(2, '0');
                      _timeController.text = '$hour:$minute';
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final cart = context.read<CartService>();
      cart.temporaryReferenceName = _nameController.text;
      cart.temporaryPickupTime = _timeController.text;

      Navigator.of(context).pop({
        'name': _nameController.text,
        'time': _timeController.text,
        'payment': 'En attente', 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infos de retrait'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.timer_outlined, size: 64, color: Colors.orange),
              ),
              const SizedBox(height: 24),
              Text(
                'Quand souhaitez-vous récupérer votre commande ?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom pour la commande',
                  hintText: 'Ex: Paul',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                autofocus: true,
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un nom' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _timeController,
                readOnly: true, 
                onTap: () => _selectTime(context),
                decoration: const InputDecoration(
                  labelText: 'Heure de retrait souhaitée',
                  hintText: 'Cliquez pour choisir l\'heure',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                  suffixIcon: Icon(Icons.keyboard_arrow_down), // Indique que ça s'ouvre vers le bas
                ),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez choisir une heure' : null,
              ),
              const SizedBox(height: 40),
              const Text(
                'Note : Le règlement s\'effectuera à l\'étape suivante.',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _isLoading ? null : _submit,
          child: _isLoading 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) 
              : const Text('Passer au règlement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
