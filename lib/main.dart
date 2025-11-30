import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'database/app_database.dart';
import 'screens/home_screen.dart';
import 'services/admin_service.dart';
import 'services/sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");

    // ✅ Ligne de débogage TEMPORAIRE
    debugPrint("--- VÉRIFICATION DES CLÉS SUPABASE ---");
    debugPrint("URL LUE : ${dotenv.env['SUPABASE_URL']}");
    debugPrint("CLÉ LUE : ${dotenv.env['SUPABASE_ANON_KEY']}");
    debugPrint("---------------------------------------");

    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    runApp(
      MultiProvider(
        providers: [
          Provider<AppDatabase>(
            create: (_) => AppDatabase(),
            dispose: (_, db) => db.close(),
          ),
          ProxyProvider<AppDatabase, AdminService>(
            update: (_, db, __) => AdminService(db: db),
          ),
          ProxyProvider<AppDatabase, SyncService>(
            update: (_, db, __) => SyncService(db: db),
          ),
        ],
        child: const PizzaApp(),
      ),
    );
  } catch (e) {
    debugPrint('🚨 ERREUR: $e');
    runApp(ErrorApp(error: e.toString()));
  }
}

class PizzaApp extends StatelessWidget {
  const PizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🍕 PizzaApp',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
      ),
      home: const HomeScreen(),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(error, textAlign: TextAlign.center),
              ),
              ElevatedButton(
                onPressed: () {
                  main();
                },
                child: const Text('🔄 Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
