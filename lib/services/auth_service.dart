import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Login
  Future<User?> login({required String email, required String password}) async {
    final res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  // Register
  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    // 1️⃣ Daftar user di Supabase Auth
    final res = await _supabase.auth.signUp(email: email, password: password);
    final user = res.user;
    if (user == null) return null;

    // 2️⃣ Masukkan data ke tabel 'users'
    await _supabase.from('users').insert({
      'user_id': user.id,
      'name': name,
      'role': role,
      'email': email,
    });

    return user;
  }
}
