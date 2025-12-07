import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final supabase = Supabase.instance.client;

  // GET CATEGORIES 
  Future<List<Map<String, dynamic>>> getCategories() async {
    final data = await supabase.from('categories').select();
    return List<Map<String, dynamic>>.from(data);
  }

  // GET PRODUCTS 
  Future<List<Map<String, dynamic>>> getProducts() async {
    final data = await supabase
        .from('products')
        .select('product_id, name, price, stock, image, category_id, categories(name)');
    return List<Map<String, dynamic>>.from(data);
  }

  // UPLOAD IMAGE
  Future<String?> uploadImage(XFile pickedImage) async {
    try {
      final filePath =
          "uploads/product_${DateTime.now().millisecondsSinceEpoch}.jpg";

      if (kIsWeb) {
        final bytes = await pickedImage.readAsBytes();
        await supabase.storage.from('product').uploadBinary(
              filePath,
              bytes,
              fileOptions: const FileOptions(upsert: true),
            );
      } else {
        await supabase.storage.from('product').upload(
              filePath,
              File(pickedImage.path),
              fileOptions: const FileOptions(upsert: true),
            );
      }

      final url = supabase.storage.from('product').getPublicUrl(filePath);
      return url;
    } catch (e) {
      print("Upload Error: $e");
      return null;
    }
  }

  // UPDATE PRODUCT 
  Future<void> updateProduct({
    required int productId,
    required String name,
    required int price,
    required int stock,
    String? imageUrl,
  }) async {
    await supabase.from('products').update({
      "name": name,
      "price": price,
      "stock": stock,
      "image": imageUrl,
    }).eq('product_id', productId);
  }

  // DELETE PRODUCT 
Future<void> deleteProduct(int id) async {
  try {
   
    final response = await supabase.rpc('delete_product_cascade', params: {
      'pid': id
    });

    
    print("Delete success: $response");
  } on PostgrestException catch (e) {
    print("Postgrest Error: ${e.message}");
    print("Details: ${e.details}");
    rethrow;
  } catch (e) {
    print("Unknown error: $e");
    rethrow;
  }
}
}
