import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tottho_apa_flutter/Screens/all_merchant_screen.dart';
import 'dart:convert';

import '../Models/district_model.dart';
import '../Screens/login_screen.dart';
import '../Screens/main_screen.dart';

class CrudMerchantProvider extends ChangeNotifier {
  //field initialized
  bool isFormModified = false;
  bool isMerchantPaymentEnabled = false;
  String latitude = '';
  String longitude = '';
  String _id = '';
  String _firstName = '';
  String _upazilaName = '';
  String _districtName = '';
  String _primaryPhoneNumber = '';
  String _secondPhoneNumber = '';
  String _nidNumber = '';
  String _emailAddress = '';
  String _userPassword = '';
  String _userCPassword = '';
  String _shopName = '';
  String _userAddress = '';
  String _profileImage = '';
  String _districtId = '14';
  String _upazilaId = '118';
  String _paymentMethod = '';
  String _accountName = '';
  String _bankName = '';
  String _accountNumber = '';
  String _memberOfJoita = '';
  String _isTrainedOfFms = '';

  String _trainingOfFmsName = '';

  bool get isDataModified => isFormModified; // Track form modification
  void setDataModified(bool modified) {
    isFormModified = modified;
    notifyListeners(); // Notify listeners when the modification status changes
  }

  String get id => _id;

  void updateUserId(String value) {
    _id = value;
    isFormModified = true;
    notifyListeners();
  }

  String get firstName => _firstName;

  void updateFirstName(String value) {
    _firstName = value;
    isFormModified = true;
    notifyListeners();
  }

  String get primaryPhoneNumber => _primaryPhoneNumber;

  void updatePrimaryPhoneNumber(String value) {
    _primaryPhoneNumber = value;
    isFormModified = true;
    notifyListeners();
  }

  String get secondPhoneNumber => _secondPhoneNumber;

  void updateSecondPhoneNumber(String value) {
    _secondPhoneNumber = value;
    isFormModified = true;
    notifyListeners();
  }

  String get nidNumber => _nidNumber;

  void updateNidNumber(String value) {
    _nidNumber = value;
    isFormModified = true;
    notifyListeners();
  }

  String get emailAddress => _emailAddress;

  void updateEmailAddress(String value) {
    _emailAddress = value;
    isFormModified = true;
    notifyListeners();
  }

  String get userPassword => _userPassword;

  void updateUserPassword(String value) {
    _userPassword = value;
    isFormModified = true;
    notifyListeners();
  }

  String get userCPassword => _userCPassword;

  void updateUserCPassword(String value) {
    _userCPassword = value;
    isFormModified = true;
    notifyListeners();
  }

  String get shopName => _shopName;

  void updateShopName(String value) {
    _shopName = value;
    isFormModified = true;
    notifyListeners();
  }

  String get userAddress => _userAddress;

  void updateUserAddress(String value) {
    _userAddress = value;
    isFormModified = true;
    notifyListeners();
  }

  String get profileImage => _profileImage;

  void updateProfileImage(String value) {
    _profileImage = value;
    isFormModified = true;
    notifyListeners();
  }

  String get districtName => _districtName;

  void updateDistrictName(String value) {
    _districtName = value;
    isFormModified = true;
    notifyListeners();
  }

  String get upazilaName => _upazilaName;

  void updateUpazilaName(String value) {
    _upazilaName = value;
    isFormModified = true;
    notifyListeners();
  }

  String get districtId => _districtId;

  void updateDistrictId(String value) {
    _districtId = value;
    isFormModified = true;
    notifyListeners();
  }

  String get upazilaId => _upazilaId;

  void updateUpazilaId(String value) {
    _upazilaId = value;
    isFormModified = true;
    notifyListeners();
  }

  String get paymentMethod => _paymentMethod;

  void updatePaymentMethod(String value) {
    _paymentMethod = value;
    isFormModified = true;
    notifyListeners();
  }

  String get accountName => _accountName;

  void updateAccountName(String value) {
    _accountName = value;
    isFormModified = true;
    notifyListeners();
  }

  String get bankName => _bankName;

  void updateBankName(String value) {
    _bankName = value;
    isFormModified = true;
    notifyListeners();
  }

  String get accountNumber => _accountNumber;

  void updateAccountNumber(String value) {
    _accountNumber = value;
    isFormModified = true;
    notifyListeners();
  }

  String get memberOfJoita => _memberOfJoita;

  void updateMemberOfJoita(String value) {
    _memberOfJoita = value;
    isFormModified = true;
    notifyListeners();
  }

  String get isTrainedOfFms => _isTrainedOfFms;

  void updateIsTrainedOfFms(String value) {
    _isTrainedOfFms = value;
    isFormModified = true;
    notifyListeners();
  }

  String get trainingOfFmsName => _trainingOfFmsName;

  void updateTrainingOfFmsName(String value) {
    _trainingOfFmsName = value;
    isFormModified = true;
    notifyListeners();
  }


  String? get district_Id => _districtId;
  String? get upazila_Id => _upazilaId;
  void setDistrictId (String? setValue){
    _districtId = setValue??'0';
    notifyListeners();
  }

  void setUpazilaId (String? setValue){
    _upazilaId = setValue??'0';
    notifyListeners();
  }

  Future<dynamic> sendMerchantDataToServer(BuildContext context, String token) async {
    final String baseUrl = 'https://laalsobuj.comjagat.org/api/totthoapa';
    final String addMerchantUrl = '$baseUrl/addmerchant';
    try{
      final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(addMerchantUrl),
      );
      // Add headers
      imageUploadRequest.headers['Authorization'] =
      'Bearer $token';
      imageUploadRequest.headers['Content-Type'] =
      'multipart/form-data';

      final Map<String, String> jsonBody = {
        'first_name': _firstName,
        'phone_no': _primaryPhoneNumber,
        'phone_one': _secondPhoneNumber,
        'nid': _nidNumber,
        'email': _emailAddress,
        'password': _userPassword,
        'shop_name': _shopName,
        'user_address': _userAddress,
        'latitude': latitude,
        'longitude': longitude,
        'district': _districtId,
        'upazila': _upazilaId,
        'payment_method': _paymentMethod,
        'account_name': _accountName,
        'bank_name': _bankName,
        'account_number': _accountNumber,
        'memberofjoita': _memberOfJoita,
        'istraineeofms': _isTrainedOfFms,
        'trainingofms': _trainingOfFmsName,
      };
      imageUploadRequest.fields.addAll(jsonBody);

      // Attach the image file
      if (_profileImage.isNotEmpty) {
        // Attach the image file if it's provided
        imageUploadRequest.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          _profileImage,
        ));
      }
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Response body234: ${response.body}');
        Get.snackbar(
          "Success!",
          "Merchant add successfully.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllMerchantScreen()),
        );
        notifyListeners();
        return true;
      }else if(response.statusCode == 500){
        print('Response body: ${response.body}');
        Get.snackbar(
          "Error!",
          "There is an issue on server.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
      }else if(response.statusCode == 403){
        try {
          final List<dynamic> errors = json.decode(response.body)['errors'];
          final List<dynamic> errorMessages = errors.map((error) => error['message']).toList();

          if (errorMessages.isNotEmpty) {
            // Show a Snackbar with the error messages
            for(var message in errorMessages){
              Get.snackbar(
                "Error!",
                message,
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                borderRadius: 10,
                margin: EdgeInsets.all(10),
              );
            }
          }
        } catch (e) {
          print('Error parsing API response: $e');
        }
        print('Response body234: ${response.body}');
        print('Response code234 : ${response.statusCode}');
      }else if(response.statusCode == 401){
        Get.snackbar(
          "Warning!",
          "Authentication failed. please login again!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', '');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }catch (e){
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<dynamic> updateMerchantDataToServer(BuildContext context, String token, String id) async {
    final String baseUrl = 'https://laalsobuj.comjagat.org/api/totthoapa';
    final String addMerchantUrl = '$baseUrl/editmerchant?id=$id';
    try{
      final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(addMerchantUrl),
      );
      // Add headers
      imageUploadRequest.headers['Authorization'] =
      'Bearer $token';
      imageUploadRequest.headers['Content-Type'] =
      'multipart/form-data';

      final Map<String, String> jsonBody = {
        'first_name': _firstName,
        'phone_no': _primaryPhoneNumber,
        'phone_one': _secondPhoneNumber,
        'nid': _nidNumber,
        'email': _emailAddress,
        'password': _userPassword,
        'shop_name': _shopName,
        'user_address': _userAddress,
        'latitude': latitude,
        'longitude': longitude,
        'district': _districtId,
        'upazila': _upazilaId,
        'payment_method': _paymentMethod,
        'account_name': _accountName,
        'bank_name': _bankName,
        'account_number': _accountNumber,
        'memberofjoita': _memberOfJoita,
        'istraineeofms': _isTrainedOfFms,
        'trainingofms': _trainingOfFmsName,
      };
      imageUploadRequest.fields.addAll(jsonBody);

      // Attach the image file
      if (_profileImage.isNotEmpty) {
        // Attach the image file if it's provided
        imageUploadRequest.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          _profileImage,
        ));
      }
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Response body234: ${response.body}');
        Get.snackbar(
          "Success!",
          "Merchant add successfully.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
        notifyListeners();
        return true;
      }else if(response.statusCode == 500){
        print('Response 3333: ${response.statusCode}');
        Get.snackbar(
          "Error!",
          "There is an issue on server.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
      }else if(response.statusCode == 403){
        try {
          final List<dynamic> errors = json.decode(response.body)['errors'];
          final List<dynamic> errorMessages = errors.map((error) => error['message']).toList();

          if (errorMessages.isNotEmpty) {
            // Show a Snackbar with the error messages
            for(var message in errorMessages){
              Get.snackbar(
                "Error!",
                message,
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                borderRadius: 10,
                margin: EdgeInsets.all(10),
              );
            }
          }
        } catch (e) {
          print('Error parsing API response: $e');
        }
        print('Response body234: ${response.body}');
        print('Response code234 : ${response.statusCode}');
      }else if(response.statusCode == 401){
        Get.snackbar(
          "Warning!",
          "Authentication failed. please login again!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', '');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }catch (e){
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> clearAllDataFields() async {
    // Clear all data fields by resetting them to their initial values or empty strings
    isFormModified = false;
    latitude = '';
    longitude = '';
    _firstName = '';
    _primaryPhoneNumber = '';
    _secondPhoneNumber = '';
    _nidNumber = '';
    _emailAddress = '';
    _userPassword = '';
    _userCPassword = '';
    _shopName = '';
    _userAddress = '';
    _profileImage = '';
    _districtId = '14';
    _upazilaId = '118';
    _paymentMethod = '';
    _accountName = '';
    _bankName = '';
    _accountNumber = '';
    _memberOfJoita = '';
    _isTrainedOfFms = '';
    _trainingOfFmsName = '0';

    notifyListeners();
  }

}
