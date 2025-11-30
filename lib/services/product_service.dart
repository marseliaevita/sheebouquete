import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final supabase = Supabase.instance.client;

  // =======================
  // GET CATEGORIES
  // =======================
  Future<List<Map<String, dynamic>>> getCategories() async {
    final data = await supabase.from('categories').select();
    return data;
  }

  // =======================
  // GET PRODUCTS
  // =======================
  Future<List<Map<String, dynamic>>> getProducts() async {
    final data = await supabase
        .from('products')
        .select('product_id, name, price, stock, image, category_id, categories(name)');
    return data;
  }

  // =======================
  // UPLOAD IMAGE
  // =======================
  Future<String?> uploadImage(File file) async {
    final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage.from('product_images').upload(
      fileName,
      file,
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );

    final imageUrl = supabase.storage.from('product_images').getPublicUrl(fileName);
    return imageUrl;
  }
  

  // =======================
  // ADD PRODUCT
  // =======================
  Future<void> addProduct({
    required String name,
    required int price,
    required int stock,
    required int categoryId,
    String? imageUrl,
  }) async {
    await supabase.from('products').insert({
      'name': name,
      'price': price,
      'stock': stock,
      'category_id': categoryId,
      'image': imageUrl,
    });
  }

  // =======================
  // UPDATE PRODUCT
  // =======================
  Future<void> updateProduct({
    required int productId,
    required String name,
    required int price,
    required int stock,
    required int categoryId,
    String? imageUrl,
  }) async {
    await supabase.from('products').update({
      'name': name,
      'price': price,
      'stock': stock,
      'category_id': categoryId,
      'image': imageUrl,
    }).eq('product_id', productId);
  }

  // =======================
  // DELETE
  // =======================
  Future<void> deleteProduct(int id) async {
    await supabase.from('products').delete().eq('product_id', id);
  }
}
