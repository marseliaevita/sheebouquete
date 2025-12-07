import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pos_app/models/users_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // LOGIN
  Future<User?> login({required String email, required String password}) async {
    final res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  // REGISTER
  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final res = await _supabase.auth.signUp(email: email, password: password);
    final user = res.user;
    if (user == null) return null;

    await _supabase.from('users').insert({
      'user_id': user.id,
      'name': name,
      'role': role,
      'email': email,
    });

    return user;
  }

  // LOGOUT
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}

// USER YANG LOGIN
class CurrentUser {
  static UserModel? _user;
  static set user(UserModel? user) => _user = user;
  static UserModel? get user => _user;

  /// Hapus user saat logout
  static void clear() => _user = null;
}