import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportStatCard extends StatelessWidget {
  final String title;
  final String value;
  final double width;
  final double height;

  const ReportStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFDFC9D5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 17),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF8A1538),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
        ]
      ),
    );
  
  }
}

//GRAPHIC
class DailyGraphicSection extends StatelessWidget {
  final List<Map<String, double>> data; 

  const DailyGraphicSection({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double maxChartHeight = 180.0;
    const double maxValue = 100.0;
    final List<String> days = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF8A1538), width: 2.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Graphic",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: maxChartHeight + 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: data.asMap().entries.map((entry) {
                int i = entry.key;
                var item = entry.value;

                double costsH   = (item['costs']!   / maxValue) * maxChartHeight;
                double revenueH = (item['revenue']! / maxValue) * maxChartHeight;
                double profitH  = (item['profit']!  / maxValue) * maxChartHeight;

                return Column(
                  children: [
                    SizedBox(
                      height: maxChartHeight,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          _barSegment(costsH,   const Color(0xFF8B5CF6)), // Costs (ungu)
                          _barSegment(revenueH, const Color(0xFFFCA5A5)), // Revenue (merah muda)
                          _barSegment(profitH,  const Color(0xFF5EEAD4)), // Profit (biru muda)
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      days[i],
                      style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 28),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legend(const Color(0xFF8B5CF6), "Costs"),
              const SizedBox(width: 28),
              _legend(const Color(0xFFFCA5A5), "Revenue"),
              const SizedBox(width: 28),
              _legend(const Color(0xFF5EEAD4), "Profit"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _barSegment(double height, Color color) {
    return Container(
      width: 28,
      height: height.clamp(0.0, double.infinity),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _legend(Color color, String text) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF374151), fontWeight: FontWeight.w500)),
      ],
    );
  }
}

//DETAILS
class DetailsSection extends StatelessWidget {
  final List<Map<String, dynamic>> dailyData;

  const DetailsSection({Key? key, required this.dailyData}) : super(key: key);

  String _formatRupiah(num amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF8A1538), width: 2), // border merah maroon
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: const Text(
              "Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),

          // List 
          ...dailyData.asMap().entries.map((entry) {
            int idx = entry.key;
            var item = entry.value;
            bool isLast = idx == dailyData.length - 1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['date'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildColumn("Income", _formatRupiah(item['income']), const Color(0xFF3B82F6)),
                          _buildColumn("Costs", _formatRupiah(item['costs']), const Color(0xFFEF4444)),
                          _buildColumn("Profit", _formatRupiah(item['profit']), const Color(0xFF10B981)),
                        ],
                      ),
                    ],
                  ),
                ),

                if (!isLast)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      height: 32,
                      thickness: 1,
                      color: Color(0xFFFCA5A5), 
                    ),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}