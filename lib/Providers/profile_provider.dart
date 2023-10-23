import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tottho_apa_flutter/Providers/user_provider.dart';

import '../Api/auth_service.dart';
import '../Screens/login_screen.dart';

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
  String? get district_Id => districtId.toString();
  String? get upazila_Id => upazilaId.toString();

  void setDistrictId (String setValue){
    districtId = int.tryParse(setValue)??0;
    notifyListeners();
  }

  void setUpazilaId (String setValue){
    upazilaId = int.tryParse(setValue)??0;
    notifyListeners();
  }

  String get first_name => firstName;
  void updateFirstName(String value){
    firstName = value;
    notifyListeners();
  }

  String get user_name => userName;
  void updateUserName(String value){
    userName = value;
    notifyListeners();
  }

  String get emailAddress => email;
  void updateEmailAddress(String value){
    email = value;
    notifyListeners();
  }

  String get phone_no => phoneNo;
  void updatePhoneNo(String value){
    phoneNo = value;
    notifyListeners();
  }

  String get district_name => districtName;
  void updateDistrictName(String value){
    districtName = value;
    notifyListeners();
  }

  String get upazila_name => upazilaName;
  void updateUpazilaName(String value){
    upazilaName = value;
    notifyListeners();
  }

  String get zip_code => zipNo;
  void updateZipCode(String value){
    zipNo = value;
    notifyListeners();
  }

}
