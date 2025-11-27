import 'package:flutter/material.dart';
import 'database/app_database.dart';
import 'database/migrations.dart';  // ✅ AJOUTER CET IMPORT
import 'screens/home_screen.dart';

late final AppDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = await $FloorAppDatabase
      .databaseBuilder('pizza_app.db')
      .addMigrations([migration1to2])  // ✅ Maintenant migration1to2 existe
      .build();

  runApp(const PizzaApp());
}

class PizzaApp extends StatelessWidget {
  const PizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PizzaApp',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomeScreen(),
    );
  }
}

