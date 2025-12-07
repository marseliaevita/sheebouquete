import 'package:flutter/material.dart';
import 'package:pos_app/models/users_model.dart';


class CurrentUser {
  static UserModel? _user;
  static UserModel? get user => _user;
  static set user(UserModel? user) => _user = user;

  static void clear() => _user = null;
}

class AppSidebar extends StatelessWidget {
  final Function(String) onMenuTap;
  final String activeMenu;

  const AppSidebar({
    super.key,
    required this.onMenuTap,
    required this.activeMenu,
  });

  String _getInitials(String name) {
    final names = name.trim().split(' ');
    String initials = '';
    for (var n in names.take(2)) {
      if (n.isNotEmpty) initials += n[0].toUpperCase();
    }
    return initials.isEmpty ? '??' : initials;
  }

  @override
  Widget build(BuildContext context) {
    final user = CurrentUser.user;

    final String displayName = user?.name ?? "Marselia";
    final String displayRole = user?.role ?? "Admin";
    final String initials = _getInitials(displayName);

    return Drawer(
      width: 260,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Color(0xFFFFE7EB)),
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
                    // PROFILE INISIAL 
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB84C69),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF630E2B),
                          ),
                        ),
                        Text(
                          displayRole,
                          style: const TextStyle(
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

              // MENU ITEMS
              _menuItem(
                icon: Icons.dashboard,
                title: "Dashboard",
                isActive: activeMenu == "dashboard",
                onTap: () => onMenuTap("dashboard"),
              ),
              _menuItem(
                icon: Icons.category,
                title: "Product",
                isActive: activeMenu == "product",
                onTap: () => onMenuTap("product"),
              ),
              _menuItem(
                icon: Icons.shopping_bag,
                title: "Cashier",
                isActive: activeMenu == "cashier",
                onTap: () => onMenuTap("cashier"),
              ),
              _menuItem(
                icon: Icons.people,
                title: "Customer",
                isActive: activeMenu == "customer",
                onTap: () => onMenuTap("customer"),
              ),
              _menuItem(
                icon: Icons.receipt_long,
                title: "Report",
                isActive: activeMenu == "report",
                onTap: () => onMenuTap("report"),
              ),
              _menuItem(
                icon: Icons.inventory,
                title: "Stock",
                isActive: activeMenu == "stock",
                onTap: () => onMenuTap("stock"),
              ),
              _menuItem(
                icon: Icons.logout,
                title: "Logout",
                isActive: activeMenu == "logout",
                onTap: () => onMenuTap("logout"),
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