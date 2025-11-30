import 'package:supabase_flutter/supabase_flutter.dart';

class StockService {
  final supabase = Supabase.instance.client;

  // GET semua stok (ambil dari tabel products)
  Future<List<Map<String, dynamic>>> getAllStocks() async {
    final response = await supabase
        .from('products')
        .select('product_id, name, stock, image')
        .order('name');

    return response.map((e) => {
          "product_id": e['product_id'],
          "name": e['name'],
          "stock": e['stock'] ?? 0,
          "image": e['image'],
        }).toList();
  }

  // UPDATE stock + catat history
  Future<void> updateStock({
    required int productId,
    required int newStock,
    required int beforeStock,
    required String actionType,
    required String userId,
  }) async {
    // Update stok di tabel products
    await supabase
        .from('products')
        .update({"stock": newStock})
        .eq('product_id', productId);

    // Catat history
    await supabase.from('stock_histories').insert({
      'product_id': productId,
      'user_id': userId,
      'action_type': actionType,
      'change': newStock - beforeStock,
      'before_stock': beforeStock,
      'after_stock': newStock,
    });
  }

  // GET history berdasarkan product_id
  Future<List<Map<String, dynamic>>> getStockHistory(int productId) async {
    final response = await supabase
        .from('stock_histories')
        .select('change, before_stock, after_stock, created_at, users(name)')
        .eq('product_id', productId)
        .order('created_at', ascending: false);

    return response.map((e) => {
          "change": e['change'],
          "before_stock": e['before_stock'],
          "after_stock": e['after_stock'],
          "created_at": e['created_at'],
          "user": e['users']?['name'] ?? "Unknown",
        }).toList();
  }
}
