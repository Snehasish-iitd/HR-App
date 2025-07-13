import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://your-backend-url.com/api/auth';

  // Login API
  Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Assuming backend returns: { "jwt": "..." }
      return data['jwt'];
    } else {
      // Handle error (e.g., invalid credentials)
      return null;
    }
  }
}
