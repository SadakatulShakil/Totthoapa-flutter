import 'dart:convert';

import 'package:http/http.dart' as http;

class DashboardService {
  static const String baseUrl = 'https://laalsobuj.comjagat.org/api/totthoapa';

  static Future<Map<String, dynamic>> fetchDashboardData(String token) async {
    final String statesUrl = '$baseUrl/states';
    try {
      final response = await http.get(
        Uri.parse(statesUrl),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        print("----->states"+response.statusCode.toString());
        throw Exception('Failed to fetch dashboard data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server'+e.toString());
    }
  }
}
