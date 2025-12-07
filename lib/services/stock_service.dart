import 'package:supabase_flutter/supabase_flutter.dart';

class StockService {
  final _supabase = Supabase.instance.client;

  /// GET PRODUCT
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select('product_id, name, stock, image')
          .order('created_at', ascending: false);


      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw 'Error database: ${e.message}';
    } catch (e) {
      throw 'Gagal mengambil data produk: $e';
    }
  }

  /// UPDATE STOCK PRODUCT
  Future<void> updateStock(int productId, int newStock) async {
    try {
      await _supabase
          .from('products')
          .update({'stock': newStock})
          .eq('product_id', productId);
    } catch (e) {
      throw 'Gagal update stok: $e';
    }
  }
}