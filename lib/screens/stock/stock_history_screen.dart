import 'package:flutter/material.dart';
import 'package:pos_app/widgets/card_stock.dart';

class StockHistoryScreen extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int stock;
  final List<Map<String, dynamic>> historyData;

  const StockHistoryScreen({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.stock,
    required this.historyData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- HEADER ----------------
              Container(
                height: 100,
                padding: const EdgeInsets.only(top: 60, left: 18, right: 18),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 25,
                            color: Color(0xFF761B2D),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'History Stock',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF761B2D),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // ---------- PRODUCT CARD ----------
              CardStock(
                imageUrl: imageUrl,
                name: name,
                stock: stock,
                onEdit: null,
                onHistory: null,
                showReadyCard: false, 
                showActions: false,  
              ),

              const SizedBox(height: 10),

              // ---------- LIST HISTORY ----------
              ...historyData.map((item) {
                return _buildHistoryCard(item["date"], item["items"]);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- CARD HISTORY PER TANGGAL ----------
  Widget _buildHistoryCard(String date, List<Map<String, dynamic>> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE7F1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),

          const SizedBox(height: 10),

          ...items.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(e["name"])),
                  Text("${e["qty"]}x"),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
