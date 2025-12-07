import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerService {
  final supabase = Supabase.instance.client;


  //SEARCH
Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final response = await supabase
        .from('customers')
        .select('customer_id, name, phone, address');

    return List<Map<String, dynamic>>.from(response);
  }

  
  // GET CUSTOMERS
  Future<List<Map<String, dynamic>>> getCustomers() async {
    final data = await supabase
        .from('customers')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

 
  // UPDATE CUSTOMER
  Future<void> updateCustomer({
  required int customerId,
  required String name,
  required String phone,
  required String address, 
}) async {
  await supabase.from('customers').update({
    'name': name,
    'phone': phone,
    'address': address, 
  }).eq('customer_id', customerId);
}


  //CREATE CUSTOMER
  Future<void> addCustomer({
  required String name,
  required String phone,
  required String address, 
}) async {
  await supabase.from('customers').insert({
    'name': name,
    'phone': phone,
    'address': address, 
  });
}

// DELETE CUSTOMER WITH ORDERS 
Future<void> deleteCustomerWithOrders({required int customerId}) async {
  try {

    final orderResponse = await supabase
        .from('orders')
        .select('order_id')
        .eq('customer_id', customerId);

    final List<int> orderIds = (orderResponse as List)
        .map((e) => e['order_id'] as int)
        .toList();


    if (orderIds.isNotEmpty) {

      await supabase
          .from('order_details')
          .delete()
          .inFilter('order_id', orderIds);   

      await supabase
          .from('orders')
          .delete()
          .eq('customer_id', customerId);
    }

    await supabase
        .from('customers')
        .delete()
        .eq('customer_id', customerId);
        
  } catch (e) {
    rethrow; 
  }
}
}

