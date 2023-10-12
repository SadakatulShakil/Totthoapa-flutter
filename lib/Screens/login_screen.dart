import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/auth_service.dart';
import '../Models/user_model.dart';
import '../Providers/connectivity_provider.dart';
import '../Providers/user_provider.dart';
import '../Widgets/connectivity_dialog.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await AuthService.login(phoneController.text, passwordController.text);
      print(".........."+response['status'].toString());
      if(response['status'].toString() == 'true'){
        Get.snackbar(
          "Success!",
          "Successfully logged in",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
        final user = User(
          response['status'],
          response['token'],
          response['user_id'],
          response['user_name'],
          response['user_image'],
          response['full_name'],
          response['first_time_logged'],
        );

        Provider.of<UserProvider>(context, listen: false).setUser(user);
        prefs.setString('token', user.token.toString());
        prefs.setString('full_name', user.full_name.toString());
        prefs.setString('user_image', user.user_image.toString());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }else if(response['status'] == 401){
        Get.snackbar(
          "Warning!",
          "Authentication failed. User or password is incorrect",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
        );
      }
    } catch (e) {
      // Handle login failure
      print('Login failed: $e');
      // Display an error message to the user
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50),
              child: Image.asset('assets/images/laalsobuj_t_apa.png', width: 150, height: 150,), // Replace with your logo image asset
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome to my app',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Perform login logic
                        if (connectivityProvider.status == ConnectivityStatus.Offline) {
                          // Show the connectivity dialog
                          showDialog(
                            context: context,
                            builder: (context) => ConnectivityDialog(),
                          );
                        }else{
                          _login(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      )
                          : Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('Task A'),
                      Container(

                          child: Image.asset('assets/images/totthoapa.png', width: 100, height: 50,)), // Replace with your image asset
                      Container(
                          child: Image.asset('assets/images/national.png', width: 100, height: 50,)), // Replace with your image asset
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 10,),
                      Text('Task B'),
                      SizedBox(height: 10,),
                      Image.asset('assets/images/bfti_icon.png', width: 100, height: 50,), // Replace with your image asset
                      Image.asset('assets/images/com_jagat.png', width: 100, height: 50,), // Replace with your image asset
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Text(
              'Task C',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/com_jagat.png',width: 100, height: 50,), // Replace with your image asset
                  Image.asset('assets/images/totthoapa.png', width: 100, height: 50,), // Replace with your image asset
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
