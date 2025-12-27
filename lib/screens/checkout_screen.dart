import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../services/cart_service.dart';
import '../services/auth_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _timeController;
  late final TextEditingController _phoneController;
  
  String _notificationPreference = 'none'; // 'none', 'sms', 'email'
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final cart = context.read<CartService>();
    final auth = context.read<AuthService>();
    
    _nameController = TextEditingController(text: cart.temporaryReferenceName);
    _timeController = TextEditingController(text: cart.temporaryPickupTime);
    _phoneController = TextEditingController();
    
    if (auth.currentUser != null) {
      _notificationPreference = 'email';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _selectTime(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
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
        'notificationPreference': _notificationPreference,
        'notificationPhone': _notificationPreference == 'sms' ? _phoneController.text : null,
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
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Informations de retrait'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom pour la commande',
                  hintText: 'Ex: Paul',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un nom' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                readOnly: true, 
                onTap: () => _selectTime(context),
                decoration: const InputDecoration(
                  labelText: 'Heure de retrait souhaitée',
                  hintText: 'Cliquez pour choisir l\'heure',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez choisir une heure' : null,
              ),
              
              const SizedBox(height: 32),
              _buildSectionTitle('Notification de préparation'),
              // ✅ TEXTE RENDU PLUS SOMBRE ET VISIBLE ICI
              const Text(
                'Voulez-vous être notifié lorsque votre commande sera prête ?', 
                style: TextStyle(
                  color: Color(0xFF2C3E50), // Bleu-Gris très sombre
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              
              RadioListTile<String>(
                title: const Text('Par Email'),
                subtitle: const Text('Utilise l\'adresse de votre compte'),
                value: 'email',
                groupValue: _notificationPreference,
                onChanged: (val) => setState(() => _notificationPreference = val!),
              ),
              RadioListTile<String>(
                title: const Text('Par SMS'),
                value: 'sms',
                groupValue: _notificationPreference,
                onChanged: (val) => setState(() => _notificationPreference = val!),
              ),
              
              if (_notificationPreference == 'sms')
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Numéro de téléphone',
                      hintText: 'Ex: 06 12 34 56 78',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_android),
                    ),
                    validator: (value) => (_notificationPreference == 'sms' && (value == null || value.isEmpty)) ? 'Numéro requis pour le SMS' : null,
                  ),
                ),
                
              RadioListTile<String>(
                title: const Text('Ne pas m\'avertir'),
                value: 'none',
                groupValue: _notificationPreference,
                onChanged: (val) => setState(() => _notificationPreference = val!),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
