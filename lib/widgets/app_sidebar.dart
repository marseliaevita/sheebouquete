import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final Function(String) onMenuTap;
  final String activeMenu;

  const AppSidebar({
    super.key,
    required this.onMenuTap,
    required this.activeMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 260, // ukuran drawer
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFFFFE7EB),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // PROFILE
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDADF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "assets/images/user.jpg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Marselia Evita",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF630E2B),
                          ),
                        ),
                        Text(
                          "Admin",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF7A3A4A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // MENU LIST
              _menuItem(
                icon: Icons.dashboard,
                title: "Dashboard",
                isActive: activeMenu == "dashboard",
                onTap: () {
                  onMenuTap("dashboard");
                  Navigator.pop(context); // tutup drawer
                },
              ),
              _menuItem(
                icon: Icons.category,
                title: "Product",
                isActive: activeMenu == "product",
                onTap: () {
                  onMenuTap("product");
                  Navigator.pop(context);
                },
              ),
              _menuItem(
                icon: Icons.shopping_bag,
                title: "Cashier",
                isActive: activeMenu == "cashier",
                onTap: () {
                  onMenuTap("cashier");
                  Navigator.pop(context);
                },
              ),
              _menuItem(
                icon: Icons.people,
                title: "Customer",
                isActive: activeMenu == "customer",
                onTap: () {
                  onMenuTap("customer");
                  Navigator.pop(context);
                },
              ),
              _menuItem(
                icon: Icons.receipt_long,
                title: "Report",
                isActive: activeMenu == "report",
                onTap: () {
                  onMenuTap("report");
                  Navigator.pop(context);
                },
              ),
              _menuItem(
                icon: Icons.inventory,
                title: "Stock",
                isActive: activeMenu == "stock",
                onTap: () {
                  onMenuTap("stock");
                  Navigator.pop(context);
                },
              ),
              _menuItem(
                icon: Icons.person,
                title: "Account",
                isActive: activeMenu == "account",
                onTap: () {
                  onMenuTap("account");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFDADF) : const Color(0xFFF2CFCF),
          borderRadius: BorderRadius.circular(20),
          border: isActive
              ? Border.all(color: const Color(0xFFB84C69), width: 1)
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF630E2B)),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF630E2B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
