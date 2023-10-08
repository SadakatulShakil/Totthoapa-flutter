import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  int userId = 0;
  String firstName = '';
  String userName = '';
  String email = '';
  String phoneNo = '';
  int districtId = 0;
  int upazilaId = 0;
  String districtName = '';
  String upazilaName = '';
  dynamic zipNo = 0;

  void updateProfileData(Map<String, dynamic> data) {
    userId = data['id'];
    firstName = data['first_name'];
    userName = data['username'];
    email = data['email'];
    phoneNo = data['phone_no'];
    districtId = data['district'];
    upazilaId = data['upazila'];
    districtName = data['district_name'];
    upazilaName = data['upazila_name'];
    zipNo = data['zip'];

    notifyListeners();
  }

  String? _districtId;
  String? _upazilaId;
  String? get district_Id => _districtId;
  String? get upazila_Id => _upazilaId;
  void setDistrictId (String? setValue){
    _districtId = setValue;
    notifyListeners();
  }

  void setUpazilaId (String? setValue){
    _upazilaId = setValue;
    notifyListeners();
  }
}
