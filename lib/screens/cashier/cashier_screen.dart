import 'package:flutter/material.dart';
import 'package:pos_app/screens/cashier/checkout_screen.dart';

class CashierScreen extends StatelessWidget {
  const CashierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE1C5B0),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.shopping_cart,
          color: Color(0xFF630E2B),
          size: 28,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CheckoutScreen()),
          );
        },
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0x80F5B1D1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Customer Name',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1C5B0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.person_add, color: Color(0xFF8A143B)),
                        SizedBox(width: 6),
                        Text(
                          "Add New\nCustomer",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8A143B),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8E9EE),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Color(0xFF630E2B)),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search Product',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 225,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 18,
                  ),
                  itemCount: sampleProducts.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(sampleProducts[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------
  // FIX: FUNCTION DIPINDAH KE DALAM CLASS
  // ----------------------------------
  Widget _buildProductCard(Product p) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7E5E8),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 18,
                  color: Color(0xFF630E2B),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              p.image,
              width: 115,
              height: 115,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            p.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF630E2B),
            ),
          ),

          Text(
            "Rp. ${p.price}",
            style: const TextStyle(fontSize: 14, color: Color(0xFF630E2B)),
          ),

          const Spacer(),

          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "Stok ${p.stock}",
              style: const TextStyle(fontSize: 12, color: Color(0xFF630E2B)),
            ),
          ),
        ],
      ),
    );
  }
}

// -------- MODEL + DUMMY ----------
class Product {
  final String name;
  final String price;
  final String image;
  final int stock;

  Product(this.name, this.price, this.image, this.stock);
}

List<Product> sampleProducts = [
  Product("Fresh Bouquet", "250.000", "assets/images/fresh.jpg", 5),
  Product("Custom Bouquet", "310.000", "assets/images/custom.jpg", 3),
  Product("Satin Bouquet", "320.000", "assets/images/satin.jpg", 8),
  Product("Money Bouquet", "1.500.000", "assets/images/money.jpg", 2),
  Product("Snack Bouquet", "300.000", "assets/images/snack.jpg", 6),
  Product("Box Flowers", "500.000", "assets/images/boxflow.jpg", 4),
];
