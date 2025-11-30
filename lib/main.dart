import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/services/supabase_config.dart';
import 'package:pos_app/screens/main_screen.dart';
import 'package:pos_app/screens/Login/splash_screen.dart';

import 'package:pos_app/screens/cashier/order_screen.dart';
import 'package:pos_app/screens/product/product_screen.dart';
import 'package:pos_app/screens/stock/stock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shee Bouquete',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      //home: const SplashScreen(),
      //home: const CashierScreen(),
      //home: const ProductScreen(),
      home: const StockScreen(),
    );
  }
}
