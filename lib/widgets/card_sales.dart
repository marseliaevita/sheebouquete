import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// CARD STAT 
class SelesStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double width;
  final double height;
  final bool isLarge; 

  const SelesStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.width,
    required this.height,
    this.isLarge = false,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF8A1538),
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
          if (isLarge)
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                icon,
                color: const Color(0xFF8A1538).withOpacity(0.9),
                size: 52,
              ),
            )
          else
            Positioned(
              bottom: 0,
              right: 0,
              child: Icon(
                icon,
                color: const Color(0xFF8A1538).withOpacity(0.7),
                size: 26,
              ),
            ),
        ],
      ),
    );
  }
}

//TOP SALES
class TopSalesCard extends StatelessWidget {
  final List<Map<String, String>> data; 

  const TopSalesCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF8B1C1C), width: 2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top Sales",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A0932),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          ...data.map((item) => _topItem(item["name"]!, item["sold"]!)),
        ],
      ),
    );
  }

  // Product
  Widget _topItem(String name, String sold) {
    return Container(
      width: 350, 
      height: 86, 
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD7D7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF8A1538),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sold,
            style: const TextStyle(
              color: Color(0xFF8A1538),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}


//TRANSACTION
class TransactionsCard extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const TransactionsCard({
    super.key,
    required this.data,
  });

  String formatCurrency(num value) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return format.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF8B1C1C), width: 2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            "Transactions",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B1C1C),
            ),
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF8B1C1C), width: 1),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Name:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Date:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Total:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          Column(
            children: data.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFDEB5B5),
                      width: 0.6,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(item["name"]),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        DateFormat("dd MMM yyyy").format(item["date"]),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        formatCurrency(item["total"]),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}