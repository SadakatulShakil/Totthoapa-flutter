import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:tottho_apa_flutter/Screens/login_screen.dart';
import 'package:tottho_apa_flutter/Screens/main_screen.dart';

import '../Providers/connectivity_provider.dart';
import '../Providers/user_provider.dart';
import '../Widgets/connectivity_dialog.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String isLogged = 'false';
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userToken = prefs.getString('token') ?? '';
        print('llllllllll'+userToken.toString());
        userToken != '' ? isLogged = 'true': isLogged = 'false';

      isLogged == 'true'?Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen()))
          :Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/laalsobuj_t_apa.png'), // Replace with your logo image asset
          ],
        ),
      ),
    );
  }
}
