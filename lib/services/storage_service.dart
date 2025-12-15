import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadProductImage(XFile image) async {
    try {
      final file = File(image.path);
      final fileExtension = image.path.split('.').last.toLowerCase();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final filePath = 'public/$fileName';

      await _supabase.storage.from('products').upload(
            filePath,
            file,
            fileOptions: FileOptions(contentType: 'image/$fileExtension'),
          );

      final imageUrl = _supabase.storage.from('products').getPublicUrl(filePath);
      return imageUrl;
    } on StorageException catch (e) {
      print('Erreur de stockage Supabase: ${e.message}');
      rethrow;
    } catch (e) {
      // ✅ CORRIGÉ: Guillemet échappé
      print('Erreur inattendue lors de l\'upload: $e');
      rethrow;
    }
  }
}
