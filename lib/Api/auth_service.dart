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

  static Future<Map<String, dynamic>> profileData(String token) async {
    final String loginUrl = '$baseUrl/profile';
    try {
      final response = await http.get(
        Uri.parse(loginUrl),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        print('--------->'+ response.body.toString());
        return json.decode(response.body);
      } else {
        throw Exception('profile data failed');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<Map<String, dynamic>> updateProfileData(
      String token,
      String name,
      String phone,
      String email,
      String dis_id,
      String up_id,
      String password,
      String zip,
      ) async {
    final String loginUrl = '$baseUrl/editprofile';
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'first_name': name,
          'phone_no': phone,
          'email': email,
          'district': dis_id,
          'upazila': up_id,
          'password': password,
          'zip': zip,
        },
      );
      if (response.statusCode == 200) {
        print('--------->'+ response.body.toString());
        return json.decode(response.body);
      } else {
        throw Exception('profile data failed');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

}
