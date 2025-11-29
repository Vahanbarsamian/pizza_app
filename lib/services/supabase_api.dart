import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pizza.dart';
import '../models/admin.dart';

class SupabaseApi {
  static final supabase = Supabase.instance.client;

  // 🍕 Pizzas (1 ligne !)
  static Future<List<Pizza>> getPizzas() async {
    final data = await supabase.from('pizzas').select();
    return data.map((json) => Pizza.fromJson(json)).toList();
  }

  // 👤 Login
  static Future<Admin?> login(String email, String password) async {
    final data = await supabase
        .from('admins')
        .select()
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();
    return data != null ? Admin.fromJson(data) : null;
  }
}