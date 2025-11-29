import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:floor/floor.dart';
import 'database/app_database.dart';
import 'services/supabase_service.dart';
import 'database/migrations.dart';
import 'screens/home_screen.dart';

late final AppDatabase database;  // ✅ GLOBAL

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.initialize();  // ✅ Static OK
  await dotenv.load(fileName: ".env");

  database = await $FloorAppDatabase
      .databaseBuilder('pizza_app.db')
      .addMigrations([migration1to2])
      .build();

  // ✅ SYNC AUTO au démarrage (static !)
  await SupabaseService.syncProductsToFloor();  // ← STATIC !

  runApp(const PizzaApp());
}

class PizzaApp extends StatelessWidget {
  const PizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🍕 PizzaApp',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
