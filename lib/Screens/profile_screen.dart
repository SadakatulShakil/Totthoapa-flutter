import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tottho_apa_flutter/Providers/profile_provider.dart';
import 'package:tottho_apa_flutter/Screens/profile_update_screen.dart';

import '../Providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                // Handle settings button tap
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileUpdateScreen()));
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
                  backgroundImage: NetworkImage('https://laalsobuj.com/storage/app/public/company/2023-08-02-64ca163a59e08.png'),
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
                  'Additional Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                SizedBox(height: 5),
                Divider(
                  height: 5,
                  color: Colors.black,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Text('ID:')),
                    Expanded(child: Text(profileProvider.userId.toString(), textAlign: TextAlign.right)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('Phone:')),
                    Expanded(child: Text(profileProvider.phoneNo, textAlign: TextAlign.right)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('Email:')),
                    Text(profileProvider.email, textAlign: TextAlign.right,),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('District:')),
                    Text(profileProvider.districtName, textAlign: TextAlign.right),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('Upazila:')),
                    Text(profileProvider.upazilaName, textAlign: TextAlign.right),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('Zip:')),
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
