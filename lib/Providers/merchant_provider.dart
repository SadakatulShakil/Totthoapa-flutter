import 'package:flutter/foundation.dart';

import '../Api/merchant_service.dart';
import '../Models/merchant_model.dart';

class MerchantProvider with ChangeNotifier {
  List<Merchant> _merchants = [];
  List<Merchant> get merchants => [..._merchants];

  Future<void> fetchMerchants(String userToken) async {
    try {
      final merchantService = MerchantService();
      final merchantData = await merchantService.fetchMerchants(userToken);

      List<Merchant> merchantsData = merchantData
          .map((json) => Merchant.fromJson(json))
          .toList();

      _merchants = merchantsData;
      notifyListeners();
    } catch (error) {
      print('Error fetching merchants: $error');
      // Handle error appropriately
    }
  }
}
