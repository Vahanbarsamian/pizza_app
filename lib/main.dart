import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'database/app_database.dart';
import 'services/auth_service.dart';
import 'services/cart_service.dart';
import 'services/sync_service.dart';
import 'services/admin_service.dart';
import 'services/order_service.dart'; // ✅ NOUVEAU
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final db = AppDatabase();
  // La synchro initiale est maintenant gérée par le `main_screen` ou un splash screen

  runApp(MyApp(database: db));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CartService()),
        ProxyProvider<AppDatabase, SyncService>(
          update: (_, db, __) => SyncService(db: db),
        ),
        ProxyProvider<AppDatabase, AdminService>(
          update: (_, db, __) => AdminService(db: db),
        ),
        // ✅ NOUVEAU: Ajout du service de commande
        ProxyProvider<AppDatabase, OrderService>(
          update: (_, db, __) => OrderService(db: db),
        ),
      ],
      child: MaterialApp(
        title: 'Pizza App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
