import 'package:flutter/material.dart';

class DTransactionScreen extends StatelessWidget {
  const DTransactionScreen({super.key});

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
                    'Transaction',
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF761B2D), width: 2),
                  ),
                  child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return _transactionTile();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TRANSACTION
  Widget _transactionTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4C9D8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 6), 
                  child: Text(
                    "Melati Tiara",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(height: 4),

                Padding(
                  padding: EdgeInsets.only(left: 6), 
                  child: Text(
                    "8 Okt 2025 08.30 AM",
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "RP. 760.000",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1D1D),
                ),
              ),
              const SizedBox(height: 5),

              // STATUS
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFB0EEA9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF026C09), width: 1),
                ),
                child: const Text(
                  'Succes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF117C09),
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
