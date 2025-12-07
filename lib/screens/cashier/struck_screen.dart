import 'package:flutter/material.dart';
import 'package:pos_app/screens/main_screen.dart';

class StructScreen extends StatelessWidget {
  final String customerName;
  final String paymentMethod;
  final int total;
  final List<Map<String, dynamic>> cartItems;
  final int transactionCode;
  final DateTime date;

  const StructScreen({
    super.key,
    required this.customerName,
    required this.paymentMethod,
    required this.total,
    required this.cartItems,
    required this.transactionCode,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5C8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                //  WHITE CARD
                Container(
                  margin: const EdgeInsets.only(top: 45),
                  width: 320,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 25,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: _buildReceiptContent(context),
                ),

                //  ICON SUCCESS
                Positioned(
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFA4D68E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // RECEIPT CONTENT
  Widget _buildReceiptContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),

        const Center(
          child: Text(
            "Payment Success",
            style: TextStyle(
              color: Color(0xFF6A2E2E),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 6),

        Center(
          child: Text(
            "Rp ${_format(total)}",
            style: const TextStyle(
              color: Color(0xFF6A2E2E),
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(height: 12),
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 10),

        _infoRow("Transaction Code", transactionCode.toString()),
        _infoRow("Date", "${date.day} ${_month(date.month)} ${date.year}"),
        _infoRow("Customer", customerName),
        _infoRow("Payment Method", paymentMethod),

        const SizedBox(height: 12),
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 10),

        // ITEM LIST
        ...cartItems.map((item) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["name"],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF630E2B),
                ),
              ),
              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${item['qty']} x ${_format(item['price'])}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6A2E2E),
                    ),
                  ),
                  Text(
                    _format(item['price'] * item['qty']),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6A2E2E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),

        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 10),

        _infoRow("Subtotal", _format(total)),
        const SizedBox(height: 4),

        _infoRow("Total", _format(total), isBold: true),

        const SizedBox(height: 25),

        Row(
          children: [
            // CLOSE
            Expanded(
              child: SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MainScreen(initialMenu: "cashier"),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEBD2D7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      color: Color(0xFF630E2B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // PRINT
            Expanded(
              child: SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF781A2F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Print",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _infoRow(String left, String right, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF6A2E2E),
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          right,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF6A2E2E),
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

String _format(int value) {
  return value.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => "${m[1]}.",
  );
}

String _month(int m) {
  const bulan = [
    "",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  return bulan[m];
}
