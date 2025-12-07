import 'package:flutter/material.dart';
import 'package:pos_app/widgets/card_order.dart';
import 'package:pos_app/screens/cashier/struck_screen.dart';

class OrderScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Map<String, dynamic>? customer;

  const OrderScreen({
    super.key,
    required this.cartItems,
    required this.customer,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late List<Map<String, dynamic>> cartItems;

  String selectedPayment = "";

  @override
  void initState() {
    super.initState();
    cartItems = List.from(widget.cartItems);
  }

  // SUBTOTAL
  int getSubtotal() {
    int total = 0;
    for (var i in cartItems) {
      total += (i["price"] as int) * (i["qty"] as int);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    int subtotal = getSubtotal();
    int discount = 0;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
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
                    'Shopping Cart',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF761B2D),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // CUSTOMER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: CardCustomer(name: widget.customer?['name'] ?? 'Guest'),
            ),

            const SizedBox(height: 8),

            // TITLE ITEM
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: const Text(
                "Item",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF761B2D),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];

                  return CardOrder(
                    name: item["name"],
                    image: item["image"],
                    price: item["price"],
                    qty: item["qty"],
                  );
                },
              ),
            ),

            const SizedBox(height: 5),

            // SUMMARY CARD
            SummaryCard(
              subtotal: subtotal,
              discount: discount,
              selectedPayment: selectedPayment,
              onCashTap: () {
                setState(() {
                  selectedPayment = "cash";
                });
              },
              onQrisTap: () {
                setState(() {
                  selectedPayment = "qris";
                });
              },
            ),

            const SizedBox(height: 20),

            //  PAYMENT BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: SizedBox(
                width: 234,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF630E2B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: selectedPayment.isEmpty
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ConfirmPaymentDialog(
                                customer: widget.customer?['name'] ?? 'Guest',
                                itemCount: cartItems.length,
                                total: subtotal - discount,
                                paymentMethod: selectedPayment == "cash"
                                    ? "Cash"
                                    : "QRIS",
                                cartItems: cartItems,
                                onCancel: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    selectedPayment = "";
                                  });
                                },
                              );
                            },
                          );
                        },

                  child: const Text(
                    "Payment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// POPUP CONFIRM
class ConfirmPaymentDialog extends StatelessWidget {
  final String customer;
  final int itemCount;
  final int total;
  final String paymentMethod;
  final VoidCallback onCancel;
  final List<Map<String, dynamic>> cartItems;

  const ConfirmPaymentDialog({
    super.key,
    required this.customer,
    required this.itemCount,
    required this.total,
    required this.paymentMethod,
    required this.cartItems,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF8E6C9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Confirmation Your Payment",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6A2E2E),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildRow("Customer", customer),
            _buildRow("Item", "$itemCount Product"),
            _buildRow("Total", "Rp. $total"),
            _buildRow("Payment Method", paymentMethod),

            const SizedBox(height: 30),

            // FIXED BUTTON SECTION
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CANCEL
                  SizedBox(
                    width: 112,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: onCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB53855),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // CONFIRM
                  SizedBox(
                    width: 112,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StructScreen(
                              customerName: customer,
                              paymentMethod: paymentMethod,
                              total: total,
                              cartItems: cartItems,
                              transactionCode: 5431,
                              date: DateTime.now(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A1A2F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
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
}

Widget _buildRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF630E2B),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Color(0xFF630E2B)),
        ),
      ],
    ),
  );
}
