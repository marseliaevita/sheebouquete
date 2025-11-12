import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://qxamaivnsszosgzjkfee.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF4YW1haXZuc3N6b3NnemprZmVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAzMTI0MTEsImV4cCI6MjA3NTg4ODQxMX0.2sqOtvr8rd5QBr_3CLPbDVWe4zP6nAE-UNthZ_h6bz8';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
