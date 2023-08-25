import 'package:http/http.dart' as http;
import 'dart:convert';

class MerchantService {
  final String baseUrl = 'https://laalsobuj.comjagat.org/api/totthoapa';

  Future<List<Map<String, dynamic>>> fetchMerchants(String token) async {
    final String merchantsUrl = '$baseUrl/merchants';

    final response = await http.get(
        Uri.parse(merchantsUrl),
        headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return List<Map<String, dynamic>>.from(responseData['data']);
    } else {
      throw Exception('Failed to fetch merchants');
    }
  }
}
