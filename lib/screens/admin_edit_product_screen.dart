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
  final _discountController = TextEditingController();
  
  late bool _isEditing;
  List<int> _selectedIngredientIds = [];
  bool _isLoading = false;
  int _maxSupplementsValue = 4; // For the stepper

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;
    if (_isEditing) {
      final product = widget.product!;
      _nameController.text = product.name;
      _priceController.text = product.basePrice.toString();
      _descriptionController.text = product.description ?? '';
      _discountController.text = (product.discountPercentage * 100).toStringAsFixed(0);
      _maxSupplementsValue = product.maxSupplements ?? 4;

      final db = Provider.of<AppDatabase>(context, listen: false);
      final query = db.select(db.productIngredientLinks)..where((link) => link.productId.equals(product.id));
      query.get().then((links) {
          if (mounted) {
              setState(() {
                  _selectedIngredientIds = links.map((l) => l.ingredientId).toList();
              });
          }
      });
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      final adminService = Provider.of<AdminService>(context, listen: false);
      final syncService = Provider.of<SyncService>(context, listen: false);

      final savedProductData = await adminService.saveProduct(
        id: _isEditing ? widget.product!.id : null,
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        description: _descriptionController.text,
        discountPercentage: (double.tryParse(_discountController.text) ?? 0.0) / 100,
        maxSupplements: _maxSupplementsValue,
      );
      final savedProductId = savedProductData['id'] as int;

      await adminService.updateProductIngredientLinks(savedProductId, _selectedIngredientIds);

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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CardHeader(title: 'Informations de la Pizza', icon: Icons.info_outline),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder())),
                              const SizedBox(height: 12),
                              TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Prix (€)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                              const SizedBox(height: 12),
                              TextField(controller: _discountController, decoration: const InputDecoration(labelText: 'Réduction (%)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                              const SizedBox(height: 12),
                              TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 3),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Nombre max. de suppléments:', style: TextStyle(fontSize: 16)),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline),
                                        onPressed: () {
                                          if (_maxSupplementsValue > 0) {
                                            setState(() => _maxSupplementsValue--);
                                          }
                                        },
                                      ),
                                      Text(_maxSupplementsValue.toString(), style: Theme.of(context).textTheme.titleLarge),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline),
                                        onPressed: () {
                                          setState(() => _maxSupplementsValue++);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 16),
                _ListHeader(title: 'Ingrédients supplémentaires autorisés', icon: Icons.checklist),
                const SizedBox(height: 8),
                Expanded(
                  child: StreamBuilder<List<Ingredient>>(
                    stream: db.watchAllIngredients(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      final allIngredients = snapshot.data ?? [];
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: allIngredients.length,
                        itemBuilder: (context, index) {
                          final ingredient = allIngredients[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                            ),
                            child: CheckboxListTile(
                              title: Text(ingredient.name),
                              subtitle: Text.rich(
                                TextSpan(
                                  style: TextStyle(color: Colors.grey.shade700),
                                  children: [
                                    const TextSpan(text: '+ '),
                                    TextSpan(text: ingredient.price.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const TextSpan(text: ' € TTC', style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                              ),
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
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _save,
        label: const Text('Enregistrer'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
