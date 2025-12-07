import 'package:flutter/material.dart';

class CardCustomer extends StatelessWidget {
  final String name;
  final int orders;
  final int totalSpent;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;

  const CardCustomer({
    super.key,
    required this.name,
    required this.orders,
    required this.totalSpent,
    this.onEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 396,
        height: 91,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF5D7DF),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
          ],
        ),

        child: Row(
          children: [
            // Profile 
            Container(
              height: 76,
              width: 76,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : "",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8A0B38),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Name + Order
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "$orders Orders",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Price + Edit Icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Color(0xFF8A0B38),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Rp. ${totalSpent.toString().replaceAllMapped(
                        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                        (m) => "${m[1]}.",
                      )}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



//CARD CUSTOMER HISTORY
class CardCustomerHistory extends StatelessWidget {
  final String name;
  final String phone;

  const CardCustomerHistory({
    super.key,
    required this.name,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3D8DE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Profile
          Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8A0B38),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Nama + Phone
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//CARD ITEM HISTORY
class CardHistoryItem extends StatelessWidget {
  final String image;
  final String name;
  final int price;
  final int qty;

  const CardHistoryItem({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image,
              height: 65,
              width: 65,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // Name + Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Rp ${price.toString().replaceAllMapped(RegExp(r'(\\d)(?=(\\d{3})+(?!\\d))'), (m) => '${m[1]}.')}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Qyt
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              qty.toString(),
              style: const TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}