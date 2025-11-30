import 'package:flutter/material.dart';
import 'login_register_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: GestureDetector(
        onTap: () {
          // Fungsi dijalankan saat di klik
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginRegisterScreen(),
            ),
          );
        },
        child: Center(
          // Logo 
          child: Image.asset(
            'assets/images/logo.png', 
            width: 250, 
          ),
        ),
      ),
    );
  }
}
