import 'package:flutter/material.dart';

class DProductScreen extends StatelessWidget {
  const DProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Product',
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

            // CONTENT 
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF761B2D), width: 2),
                  ),
                  child: Column(
                    children: List.generate(8, (index) => _buildProductItem()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // LIST PRODUCT
  Widget _buildProductItem() {
    return Container(
      width: 360,
      height: 71,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFE6A8C5).withOpacity(0.45),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nama Product
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Money Bouquet",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 3),
              Text(
                "IDR 1550K",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          // Qyt
          const Text(
            "11",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          )
        ],
      ),
    );
  }
}
