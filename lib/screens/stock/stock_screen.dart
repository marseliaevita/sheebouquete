import 'package:flutter/material.dart';
import 'package:pos_app/widgets/card_stock.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  String searchQuery = "";

  List<Map<String, dynamic>> stockData = [
    {
      "name": "Satin Bouquet",
      "stock": 11,
      "image":
          "https://images.pexels.com/photos/931167/pexels-photo-931167.jpeg"
    },
    {
      "name": "Snack Bouquet",
      "stock": 2,
      "image":
          "https://images.pexels.com/photos/102129/pexels-photo-102129.jpeg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SEARCH BAR
              Container(
                width: 3,
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7E5E8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        size: 24, color: Color(0xFF924A60)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search",
                        ),
                        onChanged: (v) =>
                            setState(() => searchQuery = v.toLowerCase()),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // LIST STOCK
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink.shade100),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView(
                    children: stockData
                        .where((item) => item['name']
                            .toLowerCase()
                            .contains(searchQuery))
                        .map((item) {
                      return CardStock(
                        name: item['name'],
                        stock: item['stock'],
                        imageUrl: item['image'],
                        onEdit: () {},
                        onHistory: () {},
                      );
                    }).toList(),
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



// POPUP UPDATE
void showUpdateStockDialog(BuildContext context, String productName) {
  final TextEditingController stockController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false, // biar ga ketutup kalau klik luar
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF2D8), // warna cream background
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TITLE
              const Text(
                "Update Stock",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A2E2E),
                ),
              ),

              const SizedBox(height: 20),

              // PRODUCT NAME INPUT (READONLY)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF7A2E2E), width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7A2E2E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ITEM LABEL
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

              // STOCK INPUT
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF7A2E2E)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF7A2E2E), width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BUTTON ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CANCEL BUTTON
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9C8C8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0xFF7A2E2E),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // UPDATE BUTTON
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        String value = stockController.text;

                        Navigator.pop(context);

                        
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7A2E2E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
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
      );
    },
  );
}
