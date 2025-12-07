import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// CUSTOMER CARD
class CardCustomer extends StatelessWidget {
  final String name;

  const CardCustomer({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF630E2B),
        ),
      ),
    );
  }
}

List<Map<String, String>> dummyCustomers = [
  {"name": "Alice Johnson"},
];

// Card
class CardOrder extends StatelessWidget {
  final String name;
  final String image;
  final int price;
  final int qty;

  const CardOrder({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: image.startsWith("http")
                ? Image.network(image, width: 70, height: 70, fit: BoxFit.cover)
                : Image.asset(image, width: 70, height: 70, fit: BoxFit.cover),
          ),

          const SizedBox(width: 14),

          // Name + Price
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

          // Qyt
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Qty card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  "$qty",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// SUMMARY
class SummaryCard extends StatefulWidget {
  final int subtotal;
  final int discount;
  final VoidCallback onCashTap;
  final VoidCallback onQrisTap;
  final String selectedPayment;

  const SummaryCard({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.onCashTap,
    required this.onQrisTap,
    required this.selectedPayment,
  });

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  final formatCurrency = NumberFormat("#,###", "id_ID");

  String selectedPayment = ""; 

  @override
  Widget build(BuildContext context) {
    int total = widget.subtotal - widget.discount;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF630E2B),
            ),
          ),
          const SizedBox(height: 16),
          _summaryRow("Subtotal", widget.subtotal),
          const SizedBox(height: 10),
          _summaryRow("Diskon", widget.discount),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.black.withOpacity(0.3)),
          const SizedBox(height: 16),
          _summaryRow("Total", total, bold: true),
          const SizedBox(height: 24),

          // Payment Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _paymentButton(
                color: selectedPayment == "cash"
                    ? const Color(0xFF7A0E2A)
                    : const Color(0xFFFFE5EC),
                icon: Icons.payments_rounded,
                iconColor: selectedPayment == "cash"
                    ? Colors.white
                    : const Color(0xFFB35C80),
                textColor: selectedPayment == "cash"
                    ? Colors.white
                    : const Color(0xFFB35C80),
                label: "Cash",
                onTap: () {
                  setState(() {
                    selectedPayment = "cash";
                  });
                  widget.onCashTap();
                },
              ),
              const SizedBox(width: 18),
              _paymentButton(
                color: selectedPayment == "qris"
                    ? const Color(0xFF7A0E2A)
                    : const Color(0xFFFFE5EC),
                icon: Icons.qr_code_2_rounded,
                iconColor: selectedPayment == "qris"
                    ? Colors.white
                    : const Color(0xFFB35C80),
                textColor: selectedPayment == "qris"
                    ? Colors.white
                    : const Color(0xFFB35C80),
                label: "Qris",
                onTap: () {
                  setState(() {
                    selectedPayment = "qris";
                  });
                  widget.onQrisTap();
                },
              ),
            ],
          ),
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
            fontSize: bold ? 17 : 15,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF630E2B),
          ),
        ),
        Text(
          "Rp ${formatCurrency.format(value)}",
          style: TextStyle(
            fontSize: bold ? 17 : 15,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF630E2B),
          ),
        ),
      ],
    );
  }

  Widget _paymentButton({
    required Color color,
    required IconData icon,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
