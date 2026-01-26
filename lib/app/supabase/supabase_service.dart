// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static bool _isInitialized = false;

  /// Инициализация Supabase
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final supabaseUrl = 'https://xfmtxijpnjktzyaiykil.supabase.co';
      final supabaseAnonKey =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhmbXR4aWpwbmprdHp5YWl5a2lsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4NTIyNzMsImV4cCI6MjA3NDQyODI3M30.2fTOdyLCMtQUAqcIGwmUlJDMqVEeXg0ZAYvWSwi02iU';
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize Supabase: $e');
    }
  }

  /// Получение клиента Supabase
  static SupabaseClient get client {
    if (!_isInitialized) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return Supabase.instance.client;
  }

  /// Получение сервиса аутентификации
  static GoTrueClient get auth {
    if (!_isInitialized) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return Supabase.instance.client.auth;
  }

  /// Проверка инициализации
  static bool get isInitialized => _isInitialized;
}
