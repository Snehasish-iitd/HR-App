import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  final String username;
  final List<String> roles;

  User({required this.username, required this.roles});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      roles: List<String>.from(json['roles']),
    );
  }
}

class ApiService {
  static const String baseUrl = 'https://192.168.1.17:8080'; 
  final storage = const FlutterSecureStorage();

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);
      await storage.write(key: 'roles', value: jsonEncode(data['user']['roles']));
      await storage.write(key: 'username', value: data['user']['username']);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  Future<String?> getToken() async => await storage.read(key: 'token');
  Future<List<String>?> getRoles() async {
    final rolesStr = await storage.read(key: 'roles');
    if (rolesStr == null) return null;
    return List<String>.from(jsonDecode(rolesStr));
  }
  Future<String?> getUsername() async => await storage.read(key: 'username');

  Future<void> logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'roles');
    await storage.delete(key: 'username');
  }
}
//
//
//
//
//
//
//