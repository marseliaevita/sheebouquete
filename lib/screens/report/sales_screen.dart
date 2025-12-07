import 'package:flutter/material.dart';
import 'package:pos_app/widgets/card_sales.dart';

class SalesScreen extends StatefulWidget {
  final Function(String) onSwitch;
  const SalesScreen({super.key, required this.onSwitch});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  bool isDaily = true;
  bool isSales = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOGGLE REPORT/SALES
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8A1538),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Sales",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onSwitch("report");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF8A1538)),
                      ),
                      child: const Text(
                        "Report",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF8A1538),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // FILTER BOX
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF8A1538), width: 1),
              ),
              child: const Row(
                children: [
                  Icon(Icons.filter_list, color: Color(0xFF8A1538)),
                  SizedBox(width: 10),
                  Text("Filter Reports"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // TOGGLE DAY/MOUNTH
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final buttonWidth = (width - 10) / 2;

                return GestureDetector(
                  onTapDown: (details) {
                    final tapX = details.localPosition.dx;
                    setState(() {
                      isSales = tapX < width / 2;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFF8A1538)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          alignment: isSales
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            width: buttonWidth,
                            height: 48,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8A1538), Color(0xFF8A1538)],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    color: isSales
                                        ? Colors.white
                                        : const Color(0xFF8A1538),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  child: const Text("Daily"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    color: !isSales
                                        ? Colors.white
                                        : const Color(0xFF8A1538),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  child: const Text("Mounthly"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            // REPORT 3 
            Column(
              children: [
                Row(
                  children: const [
                    SelesStatCard(
                      title: "Item Order",
                      value: "107",
                      icon: Icons.bookmark_border_outlined,
                      width: 185,
                      height: 120,
                      isLarge: false,
                    ),
                    SizedBox(width: 20),
                    SelesStatCard(
                      title: "Customer",
                      value: "105",
                      icon: Icons.person_outline,
                      width: 185,
                      height: 120,
                      isLarge: false,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const SelesStatCard(
                  title: "Transaction",
                  value: "109",
                  icon: Icons.currency_exchange,
                  width: double.infinity, 
                  height: 130,
                  isLarge: true, 
                ),
              ],
            ),

            const SizedBox(height: 30),

            // TOP SALES
            TopSalesCard(
              data: [
                {"name": "Fresh Croquette", "sold": "120 Sold"},
                {"name": "Salin Croquette", "sold": "80 Sold"},
              ],
            ),

            const SizedBox(height: 30),

            // TRANSACTIONS
            TransactionsCard(
              data: [
                {
                  "name": "Marselia",
                  "date": DateTime(2025, 10, 15),
                  "total": 760000,
                },
                {
                  "name": "Dewi",
                  "date": DateTime(2025, 10, 15),
                  "total": 310000,
                },
                {
                  "name": "Raiiiii",
                  "date": DateTime(2025, 10, 15),
                  "total": 1550000,
                },
                {
                  "name": "Raiiiii",
                  "date": DateTime(2025, 10, 15),
                  "total": 1550000,
                },
              ],
            ),

            const SizedBox(height: 30),

            // PRINT BUTTON
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF8A1538)),
                ),
                child: const Text(
                  "Print Report",
                  style: TextStyle(
                    color: Color(0xFF8A1538),
                    fontWeight: FontWeight.bold,
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
