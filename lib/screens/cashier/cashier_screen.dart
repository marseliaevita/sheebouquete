import 'package:flutter/material.dart';
import 'package:pos_app/models/product_model.dart';
import 'package:pos_app/services/cashier_service.dart';
import 'package:pos_app/services/customer_service.dart';
import 'package:pos_app/screens/customer/customer_popup.dart';
import 'checkout_screen.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  List<Product> products = [];
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  
  List<Map<String, dynamic>> allCustomers = [];
  List<Map<String, dynamic>> filteredCustomers = [];
  Map<String, dynamic>? selectedCustomer;
  final TextEditingController customerController = TextEditingController();
  final FocusNode _customerFocusNode = FocusNode();
  OverlayEntry? _overlayEntry; 

  final customerService = CustomerService();
  final cashierService = CashierService();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _loadAllCustomers();

    customerController.addListener(_onCustomerSearch);
  }

  Future<void> _loadAllCustomers() async {
    try {
      final data = await customerService.getAllCustomers();
      setState(() {
        allCustomers = data;
        filteredCustomers = data;
      });
    } catch (e) {
      debugPrint("Gagal load customer: $e");
    }
  }

  void _onCustomerSearch() {
    final query = customerController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredCustomers = allCustomers;
      } else {
        filteredCustomers = allCustomers
            .where((c) => (c['name'] ?? '').toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _showCustomerDropdown() {
    _removeCustomerDropdown();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeCustomerDropdown,
              child: Container(color: Colors.transparent),
            ),
          ),
          
          Positioned(
            left: 18,
            right: 18,
            top: offset.dy + 120,
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 380),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD7D7), width: 2),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: customerController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Cari nama customer...",
                          prefixIcon: const Icon(Icons.search, size: 20),
                          filled: true,
                          fillColor: const Color(0xFFFFF0F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const Divider(height: 1),
                    // List
                    Expanded(
                      child: filteredCustomers.isEmpty
                          ? const Center(child: Text("Tidak ada customer ditemukan"))
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: filteredCustomers.length,
                              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFFFD7D7)),
                              itemBuilder: (ctx, i) {
                                final c = filteredCustomers[i];
                                final isSelected = selectedCustomer?['customer_id'] == c['customer_id'];
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: const Color(0xFFFFD7D7),
                                    child: Text(
                                      c['name'].toString().isNotEmpty ? c['name'][0].toUpperCase() : "?",
                                      style: const TextStyle(color: Color(0xFF8A0B38), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Text(c['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                                  subtitle: Text(c['phone'] ?? 'No phone'),
                                  trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                                  onTap: () {
                                    setState(() {
                                      selectedCustomer = c;
                                      customerController.text = c['name'];
                                    });
                                    _removeCustomerDropdown();
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeCustomerDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _AddCustomer() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddCustomerPopup(
        onAdded: () {
          _loadAllCustomers();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Customer berhasil ditambahkan!"), backgroundColor: Colors.green),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _removeCustomerDropdown();
    customerController.dispose();
    _customerFocusNode.dispose();
    super.dispose();
  }

  // PRODUK 
  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    try {
      final data = await cashierService.getProducts();
      products = data.map((e) => Product.fromMap(e)).toList();
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
    setState(() => isLoading = false);
  }

  void addToCart(Product p) {
    final index = cartItems.indexWhere((item) => item["product_id"] == p.productId);
    if (index != -1) {
      setState(() => cartItems[index]["qty"]++);
    } else {
      setState(() {
        cartItems.add({
          "product_id": p.productId,
          "name": p.name,
          "price": p.price,
          "qty": 1,
          "image": p.image,
        });
      });
    }
  }

  bool isInCart(Product p) => cartItems.any((item) => item["product_id"] == p.productId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE1C5B0),
        shape: const CircleBorder(),
        child: const Icon(Icons.shopping_cart, color: Color(0xFF630E2B), size: 28),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutScreen(cartItems: cartItems, customer: selectedCustomer),
            ),
          );
          if (result == "done") setState(() => cartItems.clear());
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CUSTOMER 
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _showCustomerDropdown,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0x80F5B1D1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: selectedCustomer != null ? const Color(0xFFE11D48) : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedCustomer != null ? selectedCustomer!['name'] : 'Enter Customer Name',
                                style: TextStyle(
                                  color: const Color(0xFF8A0B38),
                                  fontWeight: selectedCustomer != null ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF8A0B38),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _AddCustomer,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      height: 45,
                      decoration: BoxDecoration(color: const Color(0xFFE1C5B0), borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.person_add, color: Color(0xFF8A143B), size: 18),
                          SizedBox(width: 8),
                          Text("Add New\nCustomer",
                              style: TextStyle(color: Color(0xFF8A143B), fontSize: 12, fontWeight: FontWeight.w600, height: 1.2)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Search 
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 45,
                decoration: BoxDecoration(color: const Color(0xFFF8E9EE), borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Color(0xFF630E2B)),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(border: InputBorder.none, hintText: 'Search Product'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Product
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 225,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 18,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) => _buildProductCard(products[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product p) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF7E5E8), borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => addToCart(p),
                  child: Icon(
                    isInCart(p) ? Icons.check_circle : Icons.shopping_cart_outlined,
                    size: 18,
                    color: isInCart(p) ? Colors.green : const Color(0xFF630E2B),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: p.image.isNotEmpty
                ? Image.network(p.image, width: 115, height: 115, fit: BoxFit.cover)
                : Container(width: 115, height: 115, color: Colors.grey[300]),
          ),
          const SizedBox(height: 8),
          Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF630E2B))),
          Text("Rp. ${p.price}", style: const TextStyle(fontSize: 14, color: Color(0xFF630E2B))),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("Stok ${p.stock}", style: const TextStyle(fontSize: 12, color: Color(0xFF630E2B))),
          ),
        ],
      ),
    );
  }
}