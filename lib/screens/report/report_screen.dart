import 'package:flutter/material.dart';
import 'package:pos_app/widgets/card_report.dart';

class ReportScreen extends StatefulWidget {
  final Function(String) onSwitch;

  const ReportScreen({super.key, required this.onSwitch});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onSwitch("sales"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF8A1538)),
                      ),
                      child: const Text(
                        "Sales",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF8A1538)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8A1538),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Report",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
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

            const SizedBox(height: 30),

            // CARD STAT
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ReportStatCard(
                      title: "Item Order",
                      value: "120",
                      width: 185,
                      height: 120,
                    ),
                    ReportStatCard(
                      title: "Costs",
                      value: "Rp.9.000.000",
                      width: 185,
                      height: 120,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ReportStatCard(
                      title: "Income",
                      value: "Rp.19.000.000",
                      width: 185,
                      height: 120,
                    ),
                    ReportStatCard(
                      title: "Profit",
                      value: "Rp.10.000.000",
                      width: 185,
                      height: 120,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 25),
            //GRAPHIC
            DailyGraphicSection(
              data: [
                {'costs': 65, 'revenue': 20, 'profit': 75},
                {'costs': 90, 'revenue': 25, 'profit': 85},
                {'costs': 85, 'revenue': 95, 'profit': 50},
                {'costs': 25, 'revenue': 65, 'profit': 35},
                {'costs': 70, 'revenue': 55, 'profit': 65},
                {'costs': 50, 'revenue': 90, 'profit': 45},
                {'costs': 30, 'revenue': 25, 'profit': 90},
              ],
            ),
            const SizedBox(height: 25),

            // DETAILS
            DetailsSection(
              dailyData: [
                {
                  'date': 'Sunday, 11 Oct 2025',
                  'income': 3100000,
                  'costs': 910000,
                  'profit': 2190000,
                },
                {
                  'date': 'Monday, 12 Oct 2025',
                  'income': 3100000,
                  'costs': 910000,
                  'profit': 2190000,
                },
                {
                  'date': 'Tuesday, 13 Oct 2025',
                  'income': 3100000,
                  'costs': 910000,
                  'profit': 2190000,
                },
                {
                  'date': 'Wednesday, 14 Oct 2025',
                  'income': 3100000,
                  'costs': 910000,
                  'profit': 2190000,
                },
              ],
            ),
            const SizedBox(height: 25),

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
