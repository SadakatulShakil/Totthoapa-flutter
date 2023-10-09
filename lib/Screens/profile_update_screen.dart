import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tottho_apa_flutter/Models/merchant_model.dart';
import 'package:tottho_apa_flutter/Providers/profile_provider.dart';
import 'package:tottho_apa_flutter/Screens/main_screen.dart';
import 'package:tottho_apa_flutter/Screens/profile_screen.dart';
import '../Api/auth_service.dart';
import '../Models/district_model.dart';
import '../Models/upazila_model.dart';
import '../Providers/district_provider.dart';
import '../Providers/upazila_provider.dart';
import '../Providers/user_provider.dart';
import 'login_screen.dart';

class ProfileUpdateScreen extends StatefulWidget {
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _updateProfile(BuildContext context) async {
    final profileProvider =  Provider.of<ProfileProvider>(context, listen: false);
    try {
      final userToken =
          Provider.of<UserProvider>(context, listen: false).user.token;
      print("token_context: " + userToken.toString());
      final data = await AuthService.updateProfileData(
          userToken,
          nameController.text,
          phoneController.text,
          emailController.text,
          profileProvider.district_Id??'0',
          profileProvider.upazila_Id??'0',
          '',
          zipCodeController.text);

      print("data update " + data['status'].toString());
      if(data['status'].toString() == 'true'){
        try {
          Get.snackbar(
            "Success!",
            "Successfully logged in",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.yellow,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
          );
        } catch (e, s) {
          print(s);
        }
        Map<String, dynamic> userData = {
          'id': profileProvider.userId,
          'first_name': nameController.text,
          'username': profileProvider.userName,
          'email': emailController.text,
          'phone_no': phoneController.text,
          'district': int.tryParse(profileProvider.district_Id??'0'),
          'upazila': int.tryParse(profileProvider.upazila_Id??'0'),
          'district_name': profileProvider.districtName,
          'upazila_name': profileProvider.upazilaName,
          'zip': zipCodeController.text
        };

        profileProvider.updateProfileData(userData);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }else if(data['status'].toString() == '401'){
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
    } catch (e) {
      // Handle data fetch failure
      Get.snackbar(
        "Warning!",
        "Server issue arise here1!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
      print('Failed to fetch profile data: $e');
      // Display an error message to the user
    }
  }

  @override
  void initState() {
    super.initState();
    final profileProvider =
    Provider.of<ProfileProvider>(context, listen: false);
    context.read<DistrictProvider>().fetchDistricts();
    nameController.text = profileProvider.firstName.toString() ?? 'N/A';
    phoneController.text = profileProvider.phoneNo.toString() ?? 'N/A';
    emailController.text = profileProvider.email.toString() ?? 'N/A';
    zipCodeController.text = profileProvider.zipNo.toString() ?? 'N/A';
    Future.delayed(Duration.zero, ()async{
      profileProvider.setDistrictId(profileProvider.districtId.toString());
      //profileProvider.setUpazilaId(425.toString());
      await context.read<UpazilaProvider>().fetchUpazilas(int.tryParse(profileProvider.districtId.toString())??-1);
      // Delayed execution to ensure the district dropdown is populated before setting the upazila
      Future.delayed(Duration(milliseconds: 500), () {
        // Get the Upazila object from the list using the selectedUpazilaId
        Upazila selectedUpazila = context.read<UpazilaProvider>().upazilas.firstWhere(
              (upazila) => upazila.id.toString() == (profileProvider.upazilaId.toString()),
          orElse: () => Upazila(id: -1, district: 56, upazila: 'N/A'), // Default to a placeholder if not found
        );

        profileProvider.setUpazilaId(selectedUpazila.id.toString());
        context.read<UpazilaProvider>().setSelectedUpazilaObject(selectedUpazila);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
    Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile update'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name:'),
                    textInputAction: TextInputAction.next,
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Divider(
              height: 5,
              color: Colors.black,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone:'),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email:'),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 8),
            Container(
              child:
              Row(
                  children: [
                    Expanded(child:
                    Consumer<DistrictProvider>(
                      builder: (context, districtProvider, _) {
                        return DropdownButton<String>(
                          value: profileProvider.district_Id,
                          onChanged: (value) {
                            setState(() {
                              Future.delayed(Duration.zero, ()async{
                                print("test click: "+value.toString());
                                profileProvider.setDistrictId(value.toString());// value set
                                await context.read<UpazilaProvider>().fetchUpazilas(int.tryParse(value ?? '1')??1);
                                profileProvider.setUpazilaId(context.read<UpazilaProvider>().upazilas.first.id.toString());
                                //context.read<UpazilaProvider>().upazilas.first.id.toString();
                              });
                            });
                          },
                          hint: Text('Select District'),
                          items: [
                            ...districtProvider.districts.map((District district) {
                              return DropdownMenuItem<String>(
                                value: district.id.toString(),
                                child: Text(district.district),
                              );
                            }),
                          ],
                        );
                      },
                    ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Consumer<UpazilaProvider>(
                        builder: (context, upazilaProvider, _) {
                          return DropdownButton<String>(
                            value: profileProvider.upazila_Id,
                            onChanged: (value) {
                              setState(() {
                                profileProvider.setUpazilaId(value.toString());
                              });
                            },
                            hint: Text('Select Upazila'),
                            items: [
                              ...upazilaProvider.upazilas.map((Upazila upazila) {
                                return DropdownMenuItem<String>(
                                  value: upazila.id.toString(),
                                  child: Text(upazila.upazila),
                                );
                              }),
                            ],
                          );
                        },
                      ),
                    ),


                  ]),
            ),
            SizedBox(width: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: TextField(
                controller: zipCodeController,
                decoration: InputDecoration(labelText: 'Zip:'),
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Perform login logic
                    _updateProfile(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text('Update'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
