import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository {
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString("x-auth-token");
    } catch (e, st) {
      print("LocalStorage getToken error: $e\n$st");
      return null; // fallback
    }
  }

  Future<void> setToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("x-auth-token", token);
      print("Token saved successfully: $token");
    } catch (e, st) {
      print("LocalStorage setToken error: $e\n$st");
    }
  }

  Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("x-auth-token");
      print("Token cleared");
    } catch (e, st) {
      print("LocalStorage clearToken error: $e\n$st");
    }
  }
}
