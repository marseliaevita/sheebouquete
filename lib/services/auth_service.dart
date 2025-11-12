import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  //Register
  Future<void> signUp(String name, String email, String password) async {
    final existingUser = await supabase //cek apakah email sudah terdaftar
        .from('users')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (existingUser != null) {
      throw Exception('Email sudah terdaftar.');
    }
    await supabase.from('users').insert({ //tambah data user ke tabel
      'name': name,
      'email': email,
      'password': password,
      'role': 'officer',
    });
  }

  //Login
  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    final response = await supabase
        .from('users')
        .select()
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();

    if (response == null) {
      throw Exception('Email atau password salah.');
    }

    return response;
  }

  //Logout
  Future<void> signOut() async {
    print('User signed out');
  }
}