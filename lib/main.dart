import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
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

