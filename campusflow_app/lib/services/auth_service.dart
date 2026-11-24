import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  final http.Client client;

  AuthService({http.Client? client}) : client = client ?? http.Client();

  Future<String> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Échec de connexion');
    }

    return data['token'] as String;
  }

  Future<bool> validateToken(String token) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/tasks'),
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<String> register({
    required String fullName,
    required String email,
    required String institution,
    required String program,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': fullName,
        'email': email,
        'institution': institution,
        'program': program,
        'password': password,
      }),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode != 201) {
      throw Exception(data['message'] ?? 'Inscription impossible');
    }

    return data['token'] as String;
  }
}
