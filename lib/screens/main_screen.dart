import 'package:flutter/material.dart';
import 'package:pos_app/screens/dashboard/dashboard_screen.dart';
import 'package:pos_app/screens/product/product_screen.dart';
import 'package:pos_app/screens/cashier/cashier_screen.dart';
import 'package:pos_app/screens/customer/customer_screen.dart';
import 'package:pos_app/screens/report/sales_screen.dart';
import 'package:pos_app/screens/report/report_screen.dart';
import 'package:pos_app/screens/stock/stock_screen.dart';
import 'package:pos_app/widgets/app_sidebar.dart';
import 'package:pos_app/screens/login/logout_screen.dart';

class MainScreen extends StatefulWidget {
  final String? initialMenu; // <<< tambahan

  const MainScreen({super.key, this.initialMenu});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String activeMenu;

  @override
  void initState() {
    super.initState();
    activeMenu = widget.initialMenu ?? "dashboard";
  }

  String getAppBarTitle() {
    switch (activeMenu) {
      case "dashboard": return "Dashboard";
      case "product": return "Product";
      case "cashier": return "Cashier";
      case "customer": return "Customer";
      case "sales": return "Report";
      case "report": return "Report";
      case "stock": return "Stock";
      default: return "Dashboard";
    }
  }

  Widget getActiveScreen() {
    switch (activeMenu) {
      case "dashboard": return const DashboardScreen();
      case "product": return const ProductScreen();
      case "cashier": return const CashierScreen();
      case "customer": return const CustomerScreen();
      case "sales": return SalesScreen(onSwitch: (menu) => setState(() => activeMenu = menu));
      case "report": return ReportScreen(onSwitch: (menu) => setState(() => activeMenu = menu));
      case "stock": return const StockScreen();
      default: return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppSidebar(
        activeMenu: activeMenu,
        onMenuTap: (menu) {
          if (menu == "logout") {
            LogoutDialog.show(context);
          } else {
            setState(() => activeMenu = menu);
            Navigator.pop(context);
          }
        },
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.only(top: 60, left: 18, right: 18),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: const Color(0xFF630E2B),
            automaticallyImplyLeading: true,
            titleSpacing: 0,
            title: Text(getAppBarTitle(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Color(0xFF630E2B))),
          ),
        ),
      ),
      body: getActiveScreen(),
    );
  }
}