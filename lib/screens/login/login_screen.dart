import 'package:flutter/material.dart';
import 'package:pos_app/screens/main_screen.dart';
import 'package:pos_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  bool _isLoading = false;

  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();

    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
  }

  void _validateEmail() {
    setState(() {
      emailError = emailController.text.trim().isEmpty ? "Email wajib diisi" : null;
    });
  }

  void _validatePassword() {
    setState(() {
      final pass = passwordController.text;
      passwordError = pass.isNotEmpty && pass.length < 6
          ? "Password minimal 6 karakter"
          : null;
    });
  }

  Future<void> _login() async {
    _validateEmail();
    _validatePassword();

    if (emailError != null || passwordError != null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login gagal, cek email & password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 33),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 103),
              const Center(
                  child: Text('Login Here',
                      style: TextStyle(
                          color: Color(0xFF741642),
                          fontSize: 32,
                          fontWeight: FontWeight.bold))),
              const SizedBox(height: 20),
              const Center(
                  child: Text("Welcome to you've \n been missed!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w300))),
              const SizedBox(height: 100),

              // EMAIL FIELD 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 375,
                    height: 67,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6A8C5).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: emailError != null ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              color: Color(0xFF686666),
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ),
                  if (emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Text(
                        emailError!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 27),

              // PASSWORD FIELD 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 375,
                    height: 67,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6A8C5).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: passwordError != null ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              color: Color(0xFF686666),
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ),
                  if (passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Text(
                        passwordError!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),
              const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text('Forgot your password?',
                        style: TextStyle(
                            color: Color(0xFF741642),
                            fontSize: 16,
                            fontWeight: FontWeight.w300)),
                  )),
              const SizedBox(height: 20),

              // SIGN IN 
              Center(
                child: SizedBox(
                  width: 352,
                  height: 67,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF741642),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      elevation: 0,
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Sign in',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}