import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tottho_apa_flutter/Providers/profile_provider.dart';
import 'package:tottho_apa_flutter/Screens/profile_update_screen.dart';

import '../Api/auth_service.dart';
import '../Providers/user_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> _fetchProfileData(BuildContext context) async {
    try {
      final userToken = Provider.of<UserProvider>(context, listen: false).user.token;
      print("token_context: "+ userToken.toString());
      final data = await AuthService.profileData(userToken);
      Provider.of<ProfileProvider>(context, listen: false).updateProfileData(data);

    } catch (e) {
      // Handle data fetch failure
      print('Failed to fetch profile data: $e');
      Get.snackbar(
        "Warning!",
        "Authentication failed. Your session has expired",
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
      // Display an error message to the user
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('drawer_two'.tr),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                // Handle settings button tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileUpdateScreen()),
                );
              },
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Image, Username, Settings
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://laalsobuj.com/storage/app/public/company/2023-08-02-64ca163a59e08.png'),
                ),

                SizedBox(height: 16),
                Text(
                  profileProvider.firstName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Additional Information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'additional_info'.tr,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                SizedBox(height: 5),
                Divider(
                  height: 5,
                  color: Colors.black,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Text('id'.tr)),
                    Expanded(child: Text(profileProvider.userId.toString(), textAlign: TextAlign.right)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('phone_label'.tr)),
                    Expanded(child: Text(profileProvider.phoneNo, textAlign: TextAlign.right)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('email'.tr)),
                    Text(profileProvider.email, textAlign: TextAlign.right,),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('district'.tr)),
                    Text(profileProvider.districtName, textAlign: TextAlign.right),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('upazila'.tr)),
                    Text(profileProvider.upazilaName, textAlign: TextAlign.right),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('zip'.tr)),
                    Text(profileProvider.zipNo.toString() == 'null'?'N/A':profileProvider.zipNo.toString(), textAlign: TextAlign.right),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
