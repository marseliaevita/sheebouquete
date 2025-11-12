import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pos_app/services/supabase_config.dart';

class ProductService {
  final SupabaseClient client = SupabaseConfig.client;

  //Tambah produk
  Future<void> addProduct({
    required String name,
    required int price,
    required int categoryId,
    required int stock,
    String? image,
  }) async {
    await client.from('products').insert({
      'name': name,
      'price': price,
      'category_id': categoryId,
      'stock': stock,
      'image': image,
    });
  }

  //Ambil semua produk
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final response = await client.from('products').select();
    return List<Map<String, dynamic>>.from(response);
  }

  //Update produk
  Future<void> updateProduct({
    required int productId,
    String? name,
    int? price,
    int? categoryId,
    int? stock,
    String? image,
  }) async {
    final updates = {
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (categoryId != null) 'category_id': categoryId,
      if (stock != null) 'stock': stock,
      if (image != null) 'image': image,
      'update_id': DateTime.now().toIso8601String(),
    };

    await client.from('products').update(updates).eq('product_id', productId);
  }

  //Hapus produk
  Future<void> deleteProduct(int productId) async {
    await client.from('products').delete().eq('product_id', productId);
  }
}
