import 'package:flutter/material.dart';
import 'package:pos_app/screens/main_screen.dart';
import 'package:pos_app/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  bool _isLoading = false;
  final AuthService authService = AuthService();

  Future<void> _register() async {
    final name = nameController.text.trim();
    final role = selectedRole;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || role == null || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua field harus diisi!')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await authService.register(name: name, email: email, password: password, role: role);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil!')));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuat akun')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI tetap sama, panggil _register() di tombol
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 33),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 103),
              const Center(child: Text('Register', style: TextStyle(color: Color(0xFF741642), fontSize: 32, fontWeight: FontWeight.bold))),
              const SizedBox(height: 20),
              const Center(child: Text("Welcome to you've \nbeen missed!", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300))),
              const SizedBox(height: 60),
              _buildInputField(controller: nameController, hint: 'Name'),
              const SizedBox(height: 20),
              // Dropdown Role
              Container(
                width: 375,
                height: 67,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: const Color(0xFFE6A8C5).withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRole,
                    hint: const Text('Position', style: TextStyle(color: Color(0xFF686666), fontSize: 20, fontWeight: FontWeight.w300)),
                    items: ['admin', 'cashier'].map((role) {
                      return DropdownMenuItem(value: role, child: Text(role, style: const TextStyle(color: Color(0xFF686666), fontSize: 20, fontWeight: FontWeight.w300)));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedRole = value),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField(controller: emailController, hint: 'Email'),
              const SizedBox(height: 20),
              _buildInputField(controller: passwordController, hint: 'Password', obscureText: true),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Align(alignment: Alignment.centerRight, child: Text('Forgot your password?', style: TextStyle(color: const Color(0xFF741642), fontSize: 16, fontWeight: FontWeight.w300))),
              ),
              const SizedBox(height: 25),
              Center(
                child: SizedBox(
                  width: 352,
                  height: 67,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE6A8C5).withOpacity(0.3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), elevation: 0),
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Register', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
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

  Widget _buildInputField({required TextEditingController controller, required String hint, bool obscureText = false}) {
    return Container(
      width: 375,
      height: 67,
      decoration: BoxDecoration(color: const Color(0xFFE6A8C5).withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(controller: controller, obscureText: obscureText, decoration: InputDecoration(border: InputBorder.none, hintText: hint, hintStyle: const TextStyle(color: Color(0xFF686666), fontSize: 20, fontWeight: FontWeight.w300))),
      ),
    );
  }
}
