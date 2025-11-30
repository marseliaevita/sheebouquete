import 'package:flutter/material.dart';
import 'package:pos_app/widgets/card_checkout.dart';
import 'package:pos_app/screens/cashier/order_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Dummy cart data
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "Fresh Bouquet",
      "price": 200000,
      "qty": 2,
      "image": "assets/images/fresh.jpg",
    },
  ];

  // ===================== POPUP DELETE =====================
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 350,
            height: 196,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8E6C9),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A2E2E),
                  ),
                ),

                const SizedBox(height: 10),

                const Center(
                  child: Text(
                    "You are sure to delete\nthe product?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF6A2E2E)),
                  ),
                ),

                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB57D7B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(width: 8),

                    ElevatedButton(
                      onPressed: () {
                        setState(() => cartItems.removeAt(index));
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7A1A2F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Ok",
                        style: TextStyle(color: Colors.white),
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

  // ===================== SUBTOTAL =====================
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
    int tax = (subtotal * 0.10).toInt();

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
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

            const SizedBox(height: 25),

            // ================= TEXT ITEM =================
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

            const SizedBox(height: 10),

            // ================= LIST CARD =================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];

                  return CardCheckout(
                    name: item["name"],
                    image: item["image"],
                    price: item["price"],
                    qty: item["qty"],

                    onDelete: () => _showDeleteDialog(index),

                    onAddQty: () {
                      setState(() {
                        cartItems[index]["qty"]++;
                      });
                    },

                    onRemoveQty: () {
                      setState(() {
                        if (cartItems[index]["qty"] > 1) {
                          cartItems[index]["qty"]--;
                        }
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 5),

            // ================= SUMMARY CARD (dari widget) =================
            SummaryCard(subtotal: subtotal, discount: discount, tax: tax),

            const SizedBox(height: 20),

            // ================= CHECKOUT =================
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderScreen(
                          cartItems: cartItems, // sekarang aman
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Checkout",
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
