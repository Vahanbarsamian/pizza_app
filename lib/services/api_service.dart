import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pizza.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SupabaseApi {
  static const String baseUrl = 'https://cwbrrsjtuaruzkedblil.supabase.co/rest/v1';
  static const String apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN3YnJyc2p0dWFydXprZWRibGlsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ0MTYxMTcsImV4cCI6MjA3OTk5MjExN30._McS1szep0uQElPDAZOrJLafyL5Ri_lp3RabURK3jlE'; // ← Supabase dashboard

  // Charger toutes les pizzas
  static Future<List<Pizza>> getPizzas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pizzas?select=*'),
      headers: {'apikey': apiKey, 'Authorization': 'Bearer $apiKey'},
    );
    return (jsonDecode(response.body) as List)
        .map((data) => Pizza.fromJson(data))
        .toList();
  }

  // Login Admin
  static Future<Admin?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admins?email=eq.$email&password=eq.$password'),
      headers: {'apikey': apiKey},
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return Admin.fromJson(jsonDecode(response.body)[0]);
    }
    return null;
  }

  // Ajouter pizza
  static Future<bool> addPizza(Pizza pizza) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pizzas'),
      headers: {
        'apikey': apiKey,
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      body: jsonEncode(pizza.toJson()),
    );
    return response.statusCode == 201;
  }
}