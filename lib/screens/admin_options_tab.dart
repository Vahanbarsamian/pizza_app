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
  bool _isGlobal = false;

  Ingredient? _selectedIngredient;
  bool _isLoading = false;

  void _clearForm() {
    setState(() {
      _selectedIngredient = null;
      _nameController.clear();
      _priceController.clear();
      _categoryController.clear();
      _isGlobal = false;
    });
  }

  void _selectIngredient(Ingredient ingredient) {
    setState(() {
      _selectedIngredient = ingredient;
      _nameController.text = ingredient.name;
      _priceController.text = ingredient.price.toString();
      _categoryController.text = ingredient.category ?? '';
      _isGlobal = ingredient.isGlobal;
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
        isGlobal: _isGlobal,
      );
      await syncService.syncAll();

      _clearForm();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Ingrédient enregistré !'), backgroundColor: Colors.green,));
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
    // ... (inchangé)
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // ✅ CORRIGÉ: En-tête de carte stylisé
                _CardHeader(
                  title: _selectedIngredient == null ? 'Nouvel Ingrédient' : 'Modifier l\'Ingrédient',
                  icon: _selectedIngredient == null ? Icons.add_circle : Icons.edit,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nom de l\'ingrédient', border: OutlineInputBorder())),
                      const SizedBox(height: 12),
                      TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Prix (€)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                      const SizedBox(height: 12),
                      TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Catégorie (ex: Base, Fromage, Viande)', border: OutlineInputBorder())),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('Supplément Global'),
                        subtitle: const Text('Appliquer à toutes les pizzas par défaut'),
                        value: _isGlobal,
                        onChanged: (value) => setState(() => _isGlobal = value),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _saveIngredient,
                        icon: _isLoading ? const SizedBox(width:16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
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
              ],
            ),
          ),
          const Divider(height: 32),
          // ✅ CORRIGÉ: En-tête de liste stylisé
          _ListHeader(title: 'Bibliothèque d\'Ingrédients', icon: Icons.storage),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<Ingredient>>(
              stream: db.watchAllIngredients(),
              builder: (context, snapshot) {
                final ingredients = snapshot.data ?? [];
                if (ingredients.isEmpty) return const Text('Aucun ingrédient dans la bibliothèque.');
                return ListView.builder(
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredients[index];
                    final isSelected = _selectedIngredient?.id == ingredient.id;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      color: isSelected ? Colors.blue.shade50 : null,
                      child: ListTile(
                        leading: ingredient.isGlobal ? const Icon(Icons.public, color: Colors.blue) : null,
                        title: Text(ingredient.name),
                        subtitle: Text(ingredient.category ?? 'Sans catégorie'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${ingredient.price.toStringAsFixed(2)} €'),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteIngredient(ingredient.id),
                            ),
                          ],
                        ),
                        onTap: () => _selectIngredient(ingredient),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- Widgets d'en-tête réutilisables ---

class _CardHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _CardHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _ListHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade700, size: 22),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
