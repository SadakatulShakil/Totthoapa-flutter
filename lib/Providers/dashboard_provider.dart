import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  int totalOrder = 0;
  int totalOrderPrice = 0;
  int totalMerchant = 0;
  int totalPending = 0;
  int totalProcessing = 0;
  int totalShipped = 0;

  void updateDashboardData(Map<String, dynamic> data) {
    totalOrder = data['total_order'];
    totalOrderPrice = data['total_order_price'];
    totalMerchant = data['total_merchant'];
    totalPending = data['total_pending'];
    totalProcessing = data['total_processing'];
    totalShipped = data['total_shipped'];

    notifyListeners();
  }
}
