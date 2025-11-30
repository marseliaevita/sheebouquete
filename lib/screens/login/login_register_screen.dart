import 'package:flutter/material.dart';
import 'package:pos_app/screens/Login/login_screen.dart';
import 'package:pos_app/screens/Login/register_screen.dart';

class LoginRegisterScreen extends StatelessWidget {
  const LoginRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Logo
            Positioned(
              left: 46,
              top: 105,
              child: Image.asset(
                'assets/images/logo.png',
                width: 347,
                height: 315,
                fit: BoxFit.contain,
              ),
            ),

            // Tombol Login (Card)
            Positioned(
              left: 61,
              top: 438,
              child: SizedBox(
                width: 318,
                height: 61.85,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFE6A8C5).withOpacity(0.3),
                    side: const BorderSide(color: Color(0xFF671E36), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                    // TODO: Arahkan ke halaman login
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF270611),
                    ),
                  ),
                ),
              ),
            ),

            // Tombol Register (Card)
            Positioned(
              left: 61,
              top: 530,
              child: SizedBox(
                width: 318,
                height: 61.85,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFE6A8C5).withOpacity(0.3),
                    side: const BorderSide(color: Color(0xFF671E36), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Arahkan ke halaman register
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF270611),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
