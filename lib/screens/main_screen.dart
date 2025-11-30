import 'package:flutter/material.dart';

// Sidebar
import 'package:pos_app/widgets/app_sidebar.dart';

// Screens
import 'package:pos_app/screens/dashboard/dashboard_screen.dart';
import 'package:pos_app/screens/product/product_screen.dart';
import 'package:pos_app/screens/cashier/cashier_screen.dart';
// import 'package:pos_app/screens/customer/customer_screen.dart';
// import 'package:pos_app/screens/report/report_screen.dart';
import 'package:pos_app/screens/stock/stock_screen.dart';
// import 'package:pos_app/screens/account/account_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String activeMenu = "dashboard";

  // ==============================
  // RETURN TITLE APPBAR
  // ==============================
  String getAppBarTitle() {
    switch (activeMenu) {
      case "dashboard":
        return "Dashboard";
      case "product":
        return "Product";
      case "cashier":
        return "Cashier";
      case "customer":
        return "Customer";
      case "report":
        return "Report";
      case "stock":
        return "Stock";
      case "account":
        return "Account";
      default:
        return "Dashboard";
    }
  }

  // ==============================
  // RETURN SCREEN BERDASARKAN MENU
  // ==============================
  Widget getActiveScreen() {
    switch (activeMenu) {
      case "dashboard":
        return const DashboardScreen();
      case "product":
        return const ProductScreen();
      case "cashier":
        return const CashierScreen();
      // case "customer":
      //   return const CustomerScreen();
      // case "report":
      //   return const ReportScreen();
      case "stock":
       return const StockScreen();
      // case "account":
      //   return const AccountScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppSidebar(
        activeMenu: activeMenu,
        onMenuTap: (menu) {
          setState(() {
            activeMenu = menu;
          });
        },
      ),

      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(100), // bebas, sesuaikan tinggi
  child: Padding(
    padding: const EdgeInsets.only(top: 60, left: 18, right: 18),
    child: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: const Color(0xFF630E2B),
      automaticallyImplyLeading: true, // biar tombol drawer muncul
      titleSpacing: 0, // biar sesuai padding
      title: Text(
        getAppBarTitle(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26,
          color: Color(0xFF630E2B),
        ),
      ),
    ),
  ),
),


      body: getActiveScreen(),
    );
  }
}
