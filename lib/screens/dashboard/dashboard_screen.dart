import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pos_app/screens/dashboard/customeractive_screen.dart';
import 'package:pos_app/screens/dashboard/dtransaction_screen.dart';
import 'package:pos_app/screens/dashboard/dproduct_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              // CARD
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CARD 1
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomerActiveScreen(),
                          ),
                        );
                      },
                      child: _buildStatCard(
                        icon: Icons.person,
                        number: "55",
                        text: "Customer\n Active",
                      ),
                    ),

                    const SizedBox(width: 21),

                    // CARD 2
                     GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DTransactionScreen(),
                          ),
                        );
                      },
                      child: _buildStatCard(
                      icon: Icons.receipt_long,
                      number: "111",
                      text: "Transaction",
                    ),
                    ),

                    const SizedBox(width: 28),

                    // CARD 3
                     GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DProductScreen(),
                          ),
                        );
                      },
                      child: _buildStatCard(
                      icon: Icons.shopping_bag,
                      number: "6",
                      text: "Product",
                    ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // TODAY REPORT CHART
              _buildTodayReportChart(),

              const SizedBox(height: 25),

              // ANALYSIS REPORT CHART
              _buildAnalysisReportChart(),
            ],
          ),
        ),
      ),
    );
  }

  // CARD WIDGET
  Widget _buildStatCard({
    required IconData icon,
    required String number,
    required String text,
  }) {
    return Container(
      width: 98,
      height: 127,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF761B2D), width: 2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF671E36), size: 28),
          const SizedBox(height: 4),
          Text(
            number,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF671E36),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF671E36),
            ),
          ),
        ],
      ),
    );
  }

  // TODAY REPORT CHART
  Widget _buildTodayReportChart() {
    return Container(
      height: 335,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE6A8C5).withOpacity(0.35),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF761B2D), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today Report",
            style: TextStyle(
              color: Color(0xFF761B2D),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: BarChart(
                BarChartData(
                  minY: 0,
                  maxY: 160,
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),

                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          const labels = [
                            "Custom\nBouquet",
                            "Fresh\nBouquet",
                            "Money\nBouquet",
                            "Satin\nBouquet",
                            "Snack\nBouquet",
                            "Flower\nBox",
                          ];

                          if (value.toInt() >= labels.length) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Text(
                              labels[value.toInt()],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                height: 1.15,
                                color: Color(0xFF761B2D),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  barGroups: _makeBars(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _makeBars() {
    final values = [90.0, 130.0, 105.0, 150.0, 135.0, 100.0];

    return List.generate(values.length, (i) {
      return BarChartGroupData(
        x: i,
        barsSpace: 8,
        barRods: [
          BarChartRodData(
            toY: values[i],
            width: 22,
            color: const Color(0xFF761B2D),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      );
    });
  }

  // ANALYSIS REPORT CHART
  Widget _buildAnalysisReportChart() {
    return Container(
      height: 290,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6A8C5).withOpacity(0.5),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: const Color(0xFF761B2D), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Analysis Report",
            style: TextStyle(
              color: const Color(0xFF671E36),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 20,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.4),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF671E36),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        const labels = [
                          'May',
                          'June',
                          'July',
                          'Aug',
                          'Sep',
                          'Oct',
                        ];
                        if (value.toInt() < 0 ||
                            value.toInt() >= labels.length) {
                          return SizedBox.shrink();
                        }
                        return Text(
                          labels[value.toInt()],
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF671E36),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    barWidth: 3.2,
                    color: const Color(0xFF788CFF),

                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: const Color(0xFF788CFF),
                          ),
                    ),

                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF788CFF).withOpacity(0.30),
                          const Color(0xFF788CFF).withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),

                    spots: const [
                      FlSpot(0, 60),
                      FlSpot(1, 80),
                      FlSpot(2, 60),
                      FlSpot(3, 95),
                      FlSpot(4, 90),
                      FlSpot(5, 55),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
