import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CashierService {
  final supabase = Supabase.instance.client;

  // GET PRODUCTS
Future<List<Map<String, dynamic>>> getProducts() async {
  try {
    final response = await supabase
        .from('products')
        .select('product_id, name, price, stock, image');

    final List<Map<String, dynamic>> products = (response as List).cast<Map<String, dynamic>>();

    for (var item in products) {
      String? rawPath = item['image'] as String?;

      if (rawPath != null && rawPath.isNotEmpty) {
        if (rawPath.startsWith('http')) {
          item['image'] = rawPath;
        } else {
          String finalPath = rawPath.contains('uploads/') ? rawPath : 'uploads/$rawPath';
          item['image'] = supabase.storage.from('product').getPublicUrl(finalPath);
        }
      } else {
        item['image'] = 'https://via.placeholder.com/150?text=No+Image';
      }
    }

    return products;
  } catch (e) {
    debugPrint("Error getProducts: $e");
    rethrow;
  }
}
//CUSTOMER
Future<int> addCustomer({
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await supabase
          .from('customers')
          .insert({
            'name': name,
            'phone': phone,
            'address': address,
          })
          .select('customer_id')
          .single();

      return response['customer_id'] as int;
    } catch (e) {
      debugPrint("Error addCustomer: $e");
      rethrow;
    }
  }

  /// BUAT ORDER + DETAIL 
  Future<int> createOrder({
    required int totalPrice,
    required int totalItem,
    int? customerId,
    required String userId,
    required String paymentMethod,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    try {
      final orderResponse = await supabase
          .from('orders')
          .insert({
            'total_price': totalPrice,
            'total_item': totalItem,
            'customer_id': customerId,
            'user_id': userId,
            'payment_method': paymentMethod,
          })
          .select('order_id')
          .single();

      final int orderId = orderResponse['order_id'];

      final List<Map<String, dynamic>> orderDetails = cartItems.map((item) {
        return {
          'order_id': orderId,
          'product_id': item['product_id'],
          'quantity': item['qty'],
          'price': item['price'],
        };
      }).toList();

      if (orderDetails.isNotEmpty) {
        await supabase.from('order_details').insert(orderDetails);
      }

      return orderId;
    } catch (e) {
      debugPrint("Error createOrder: $e");
      rethrow;
    }
  }
}
