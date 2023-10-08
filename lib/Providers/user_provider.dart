import 'package:flutter/material.dart';

import '../Models/user_model.dart';
class UserProvider with ChangeNotifier {
  late User _user;

  UserProvider(User user) {
    _user = user; // Initialize the late variable with the provided user
  }

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }


}
