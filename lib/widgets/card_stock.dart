import 'package:flutter/material.dart';

class CardStock extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int stock;
  final VoidCallback? onEdit;
  final VoidCallback? onHistory;
  final bool showStockStatus;
  final bool showActions;

  const CardStock({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.stock,
    this.onEdit,
    this.onHistory,
    this.showStockStatus = true,
    this.showActions = true,
  });

  // Label Stock
  Widget _buildStockBadge() {
    final bool isLow = stock <= 3;

    if (!showStockStatus) return const SizedBox.shrink();

    return Container(
      width: 49,
      height: 16,
      decoration: BoxDecoration(
        color: isLow ? const Color(0xFFFDE7E7) : const Color(0xFFD7F8D8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLow ? const Color(0xFF9B1A1A) : const Color(0xFF026C09),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        isLow ? "Low" : "Ready",
        style: TextStyle(
          fontSize: 10,
          color: isLow ? const Color(0xFF9B1A1A) : Colors.green,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO PRODUK
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageUrl,
                width: 110,
                height: 85,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // NAMA + STOCK + LABEL READY
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Product
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Stock
                  Text(
                    "Stock: $stock",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  const SizedBox(height: 6),

                  // Label Ready/Low
                _buildStockBadge(),
                ],
              ),
            ),

            // ICON BUTTONS DI KANAN
            if (showActions)
            Column(
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.edit, color: Color(0xFF7A3E3E), size: 20),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onHistory,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.history, color: Colors.red, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 15),

        // GARIS PEMBATAS
        Container(height: 2, color: Color(0xFFE5C6C6)),

        const SizedBox(height: 15),
      ],
    );
  }
}


