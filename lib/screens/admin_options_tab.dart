import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';

class AdminOptionsTab extends StatefulWidget {
  const AdminOptionsTab({super.key});

  @override
  State<AdminOptionsTab> createState() => _AdminOptionsTabState();
}

class _AdminOptionsTabState extends State<AdminOptionsTab> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  Ingredient? _selectedIngredient;
  bool _isLoading = false;

  void _clearForm() {
    setState(() {
      _selectedIngredient = null;
      _nameController.clear();
      _priceController.clear();
      _categoryController.clear();
    });
  }

  void _selectIngredient(Ingredient ingredient) {
    setState(() {
      _selectedIngredient = ingredient;
      _nameController.text = ingredient.name;
      _priceController.text = ingredient.price.toString();
      _categoryController.text = ingredient.category ?? '';
    });
  }

  Future<void> _saveIngredient() async {
    if (_nameController.text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final adminService = Provider.of<AdminService>(context, listen: false);
      final syncService = Provider.of<SyncService>(context, listen: false);

      await adminService.saveIngredient(
        id: _selectedIngredient?.id,
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        category: _categoryController.text,
      );
      await syncService.syncAll();

      _clearForm();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Ingrédient enregistré !')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteIngredient(int id) async {
    setState(() => _isLoading = true);
    try {
      final adminService = Provider.of<AdminService>(context, listen: false);
      final syncService = Provider.of<SyncService>(context, listen: false);
      await adminService.deleteIngredient(id);
      await syncService.syncAll();
      _clearForm();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🗑️ Ingrédient supprimé.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(_selectedIngredient == null ? 'Nouvel Ingrédient' : 'Modifier l\'Ingrédient', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nom de l\'ingrédient', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Prix (€)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Catégorie (ex: Base, Fromage, Viande)', border: OutlineInputBorder())),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveIngredient,
                  icon: const Icon(Icons.save),
                  label: Text(_isLoading ? 'Enregistrement...' : 'Enregistrer'),
                ),
                if (_selectedIngredient != null)
                  TextButton.icon(
                    onPressed: _clearForm,
                    icon: const Icon(Icons.add, color: Colors.green),
                    label: const Text('Créer un nouvel ingrédient', style: TextStyle(color: Colors.green)),
                  ),
              ],
            ),
          ),
        ),
        const Divider(height: 32),
        const Text('Bibliothèque d\'Ingrédients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        StreamBuilder<List<Ingredient>>(
          stream: db.watchAllIngredients(),
          builder: (context, snapshot) {
            final ingredients = snapshot.data ?? [];
            if (ingredients.isEmpty) return const Text('Aucun ingrédient dans la bibliothèque.');
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                return ListTile(
                  title: Text(ingredient.name),
                  subtitle: Text(ingredient.category ?? 'Sans catégorie'),
                  trailing: Text('${ingredient.price.toStringAsFixed(2)} €'),
                  onTap: () => _selectIngredient(ingredient),
                  selected: _selectedIngredient?.id == ingredient.id,
                  selectedTileColor: Colors.blue.shade50,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
