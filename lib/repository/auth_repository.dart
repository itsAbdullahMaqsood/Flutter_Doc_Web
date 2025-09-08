// lib/services/user_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web_google_docs/models/user_model.dart';
import 'package:web_google_docs/repository/local_storage_repository.dart';

class UserService {
  final LocalStorageRepository localStorageRepo = LocalStorageRepository();
  final Client client = Client();

  Future<UserModel?> getUserData() async {
    try {
      print("Getting token...");
      String? token = await localStorageRepo.getToken();
      print("Got token: $token");

      if (token == null) return null;

      final res = await client.get(
        Uri.parse('${dotenv.env['API_HOST']}/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      print("Response: ${res.statusCode}");

      if (res.statusCode == 200) {
        final newUser = UserModel.fromJson(
          jsonDecode(res.body)['user'],
        ).copyWith(token: token);
        return newUser;
      } else {
        throw Exception("Error: ${res.statusCode}");
      }
    } catch (err, st) {
      print("getUserData crashed: $err\n$st");
      rethrow; // <-- don’t swallow silently
    }
  }
}
