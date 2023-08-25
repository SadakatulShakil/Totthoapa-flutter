import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://laalsobuj.comjagat.org/api/totthoapa';

  static Future<Map<String, dynamic>> login(String phone, String password) async {
    final String loginUrl = '$baseUrl/login';
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        body: {'email': phone, 'password': password},
      );
      if (response.statusCode == 200) {
        print('--------->'+ response.body.toString());
        return json.decode(response.body);
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
