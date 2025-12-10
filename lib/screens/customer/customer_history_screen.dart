import 'package:flutter/material.dart';
import 'package:pos_app/widgets/card_customer.dart';

class CustomerHistoryScreen extends StatelessWidget {
  final Map<String, dynamic> customer;

  const CustomerHistoryScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    // ===================== DUMMY DATA HISTORY ======================
    final List<Map<String, dynamic>> dummyHistory = [
      {
        "date": "15 October 2025",
        "items": [
          {
            "image": "assets/images/boxflow.jpg",
            "name": "Box Flowers",
            "price": 580000,
            "qty": 1
          },
          {
            "image": "assets/images/satin.jpg",
            "name": "Satin Coquette",
            "price": 250000,
            "qty": 1
          }
        ]
      }
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // HEADER
              Container(
                height: 70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: Color(0xFF761B2D),
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

              // CUSTOMER CARD 
              CardCustomerHistory(
                name: customer['name'] ?? "-",
                phone: customer['phone'] ?? "-",
              ),

              const SizedBox(height: 20),

              // HISTORY LIST 
              Expanded(
                child: ListView.builder(
                  itemCount: dummyHistory.length,
                  itemBuilder: (context, index) {
                    final history = dummyHistory[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // DATE
                          Text(
                            history['date'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ITEMS
                          Column(
                            children: List.generate(
                              history['items'].length,
                              (i) {
                                final item = history['items'][i];
                                return CardHistoryItem(
                                  image: item['image'],
                                  name: item['name'],
                                  price: item['price'],
                                  qty: item['qty'],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
