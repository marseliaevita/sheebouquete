import 'package:flutter/material.dart';
import 'package:pos_app/widgets/card_stock.dart';
import 'package:pos_app/screens/stock/stock_history_screen.dart';
import 'package:pos_app/services/stock_service.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final StockService _stockService = StockService();

  String searchQuery = "";
  List<Map<String, dynamic>> stockData = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _stockService.getProducts();

      final filtered = data.where((item) {
        final name = (item['name'] ?? '').toString().toLowerCase();
        return name.contains(searchQuery.toLowerCase());
      }).toList();

      setState(() => stockData = filtered);
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  // POPUP UPDATE STOK 
  void showUpdateStockDialog(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    final controller = TextEditingController(text: product['stock'].toString());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF2D8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Update Stock",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A2E2E),
                ),
              ),
              const SizedBox(height: 20),

              // Nama Produk
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF7A2E2E)),
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    product['name'] ?? 'Tanpa Nama',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7A2E2E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Item:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7A2E2E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // Input Stok
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF7A2E2E)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFF7A2E2E),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Cancel & Update
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9C8C8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0xFF7A2E2E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final newStock = int.tryParse(controller.text) ?? 0;
                        if (newStock < 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Stok tidak boleh negatif!"),
                            ),
                          );
                          return;
                        }

                        try {
                          
                          await _stockService.updateStock(
                            product['product_id'] as int,
                            newStock,
                          );

                          setState(() {
                            final idx = stockData.indexWhere(
                              (e) => e['product_id'] == product['product_id'],
                            );
                            if (idx != -1) stockData[idx]['stock'] = newStock;
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Stok berhasil diupdate!"),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal update stok: $e")),
                          );
                        }
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7A2E2E),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


//SREEN STOCK
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // SEARCH 
              Container(
                height: 78,
                width: 306,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7E5E8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 24,
                      color: Color(0xFF924A60),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search",
                        ),
                        onChanged: (v) {
                          searchQuery = v;
                          _loadProducts(); 
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // PRODUCT
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : stockData.isEmpty
                    ? const Center(child: Text("Tidak ada produk"))
                    : Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: const Color(0xFFFFC1CC),
                            width: 2,
                          ), // lebih tebal & pink muda
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          itemCount: stockData.length,
                          itemBuilder: (context, index) {
                            final item = stockData[index];
                            return CardStock(
                              name: item['name'] ?? 'Tanpa Nama',
                              stock: item['stock'] ?? 0,
                              imageUrl:
                                  item['image'] ??
                                  'https://via.placeholder.com/150',
                              onEdit: () =>
                                  showUpdateStockDialog(context, item),
                              onHistory: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StockHistoryScreen(
                                      imageUrl:
                                          item['image'] ??
                                          'https://via.placeholder.com/150',
                                      name: item['name'] ?? 'Produk',
                                      stock: item['stock'] ?? 0,
                                      historyData: const [
                                        {
                                          "date": "15 October 2025",
                                          "items": [
                                            {"name": "Marselia", "qty": 1},
                                            {"name": "Putri", "qty": 1},
                                            {"name": "Nopia", "qty": 1},
                                          ],
                                        },
                                        {
                                          "date": "14 October 2025",
                                          "items": [
                                            {"name": "Ashell", "qty": 10},
                                          ],
                                        },
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
