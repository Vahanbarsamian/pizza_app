import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;

import '../database/app_database.dart';
import '../services/admin_service.dart';
import '../services/sync_service.dart';

class AdminOptionsTab extends StatelessWidget {
  const AdminOptionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    return Scaffold(
      body: StreamBuilder<List<Ingredient>>(
        stream: db.watchAllIngredients(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final ingredients = snapshot.data!;
          return ListView.builder(
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              return ListTile(
                title: Text(ingredient.name),
                subtitle: Text('${ingredient.price.toStringAsFixed(2)} € TTC'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final adminService = Provider.of<AdminService>(context, listen: false);
                    await adminService.deleteIngredient(ingredient.id);
                    await Provider.of<SyncService>(context, listen: false).syncAll();
                  },
                ),
                onTap: () => _showEditIngredientDialog(context, ingredient),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showEditIngredientDialog(context, null),
      ),
    );
  }

  void _showEditIngredientDialog(BuildContext context, Ingredient? ingredient) {
    final isEditing = ingredient != null;
    final nameController = TextEditingController(text: ingredient?.name ?? '');
    final priceController = TextEditingController(text: ingredient?.price.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Modifier l\'ingrédient' : 'Nouvel ingrédient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Prix'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
            ElevatedButton(
              child: const Text('Sauvegarder'),
              onPressed: () async {
                final adminService = Provider.of<AdminService>(context, listen: false);
                final syncService = Provider.of<SyncService>(context, listen: false);

                final companion = IngredientsCompanion(
                  id: isEditing ? drift.Value(ingredient!.id) : const drift.Value.absent(),
                  name: drift.Value(nameController.text),
                  price: drift.Value(double.tryParse(priceController.text) ?? 0.0),
                  category: const drift.Value('Autre'), 
                  isGlobal: const drift.Value(false), 
                );
                
                await adminService.saveIngredient(companion);

                await syncService.syncAll();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
