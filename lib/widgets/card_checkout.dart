import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CardCheckout extends StatelessWidget {
  final String name;
  final String image;
  final int price;
  final int qty;
  final VoidCallback onDelete;
  final VoidCallback onAddQty;
  final VoidCallback onRemoveQty;

  const CardCheckout({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.qty,
    required this.onDelete,
    required this.onAddQty,
    required this.onRemoveQty,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(name),

      // DELETE SLIDE
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 120 / 365,
        children: [
          Builder(
            builder: (context) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                height: 116,
                width: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1C5B0).withOpacity(0.88),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(15),
                  child: const Center(
                    child: Icon(
                      Icons.delete,
                      size: 35,
                      color: Color(0xFF630E2B),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // CARD
      child: Container(
        height: 116,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black.withOpacity(0.30), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.startsWith("http")
                  ? Image.network(
                      image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
            ),

            const SizedBox(width: 14),

            // NAME + PRICE
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF630E2B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Rp $price",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // QTY + TOTAL
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // QTY BUTTONS
                  Row(
                    children: [
                      _qtyButton(Icons.remove, onRemoveQty),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "$qty",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF630E2B),
                          ),
                        ),
                      ),
                      _qtyButton(Icons.add, onAddQty),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // TOTAL PRICE
                  Text(
                    "Rp ${price * qty}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // QTY BUTTON
  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 18, color: Colors.black87),
        ),
      ),
    );
  }
}

// SUMARY CARD
class SummaryCard extends StatelessWidget {
  final int subtotal;
  final int discount;
  final int tax;

  const SummaryCard({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.tax,
  });

  @override
  Widget build(BuildContext context) {
    int total = subtotal - discount + tax;

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x85B05B3B)),
      ),
      child: Column(
        children: [
          _summaryRow("Subtotal", subtotal),
          const SizedBox(height: 15),
          _summaryRow("Diskon", discount),
          const SizedBox(height: 15),
          _summaryRow("Tax (10%)", tax),
          const SizedBox(height: 25),
          _summaryRow("Total", total, bold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, int value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF630E2B),
          ),
        ),
        Text(
          "Rp $value",
          style: TextStyle(
            fontSize: 16,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF630E2B),
          ),
        ),
      ],
    );
  }
}
