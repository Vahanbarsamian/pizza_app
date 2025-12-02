import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';

class AdminEditProductScreen extends StatefulWidget {
  final Product? product;

  const AdminEditProductScreen({super.key, this.product});

  @override
  State<AdminEditProductScreen> createState() => _AdminEditProductScreenState();
}

class _AdminEditProductScreenState extends State<AdminEditProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxSupplementsController = TextEditingController();

  late bool _isEditing;
  List<int> _selectedIngredientIds = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;
    if (_isEditing) {
      final product = widget.product!;
      _nameController.text = product.name;
      _priceController.text = product.basePrice.toString();
      _descriptionController.text = product.description ?? '';
      _maxSupplementsController.text = product.maxSupplements?.toString() ?? '0';

      final db = Provider.of<AppDatabase>(context, listen: false);
      db.watchIngredientsForProduct(product.id).first.then((links) {
        if (mounted) {
          setState(() {
            _selectedIngredientIds = links.map((l) => l.id).toList();
          });
        }
      });
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      final adminService = Provider.of<AdminService>(context, listen: false);
      final syncService = Provider.of<SyncService>(context, listen: false);

      // Enregistre le produit et récupère l'objet Product complet avec l'ID.
      final savedProduct = await adminService.saveProduct(
        id: _isEditing ? widget.product!.id : null,
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        description: _descriptionController.text,
        maxSupplements: int.tryParse(_maxSupplementsController.text),
      );

      await adminService.updateProductIngredientLinks(
        savedProduct.id,
        _selectedIngredientIds,
      );

      await syncService.syncAll();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Produit enregistré !')));
        Navigator.of(context).pop();
      }
    } catch (e, stacktrace) {
      debugPrint('Erreur lors de la sauvegarde: $e\n$stacktrace');
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier la Pizza' : 'Nouvelle Pizza'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Informations de la Pizza', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder())),
                        const SizedBox(height: 12),
                        TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Prix (€)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                        const SizedBox(height: 12),
                        TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 3),
                        const SizedBox(height: 12),
                        TextField(controller: _maxSupplementsController, decoration: const InputDecoration(labelText: 'Nombre max. de suppléments', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 32),
                Text('Ingrédients supplémentaires autorisés', style: Theme.of(context).textTheme.titleLarge),
                StreamBuilder<List<Ingredient>>(
                  stream: db.watchAllIngredients(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    final allIngredients = snapshot.data ?? [];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allIngredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = allIngredients[index];
                        return CheckboxListTile(
                          title: Text(ingredient.name),
                          subtitle: Text('${ingredient.price.toStringAsFixed(2)} €'),
                          value: _selectedIngredientIds.contains(ingredient.id),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                _selectedIngredientIds.add(ingredient.id);
                              } else {
                                _selectedIngredientIds.remove(ingredient.id);
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _save,
        label: const Text('Enregistrer'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
