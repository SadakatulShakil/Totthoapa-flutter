import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tottho_apa_flutter/Providers/crud_merchant_provider.dart';

import '../Models/add_merchant_model.dart';
import '../Models/district_model.dart';
import '../Models/upazila_model.dart';
import '../Providers/connectivity_provider.dart';
import '../Providers/district_provider.dart';
import '../Providers/upazila_provider.dart';
import '../Providers/user_provider.dart';
import '../Widgets/connectivity_dialog.dart';

class AddMerchant extends StatefulWidget {
  String from;
  merchantDataModel userData;
  AddMerchant(this.from, this.userData);

  @override
  _AddMerchantState createState() => _AddMerchantState();
}

class _AddMerchantState extends State<AddMerchant> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<void> _initFuture;
  TextEditingController storeNameController = TextEditingController();
  TextEditingController merchantNameController = TextEditingController();
  TextEditingController phoneNo1Controller = TextEditingController();
  TextEditingController phoneNo2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nidController = TextEditingController();

  String selectedImagePathForReporting = '';
  bool isLoading = false;
  bool isMemberOfJoyeta = false;
  bool isTakingTraining = false;
  bool isMerchantPaymentEnabled = false;
  var isConnected = false;

  String selectedPaymentMethod = '';
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController userAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _checkLocationPermission() async {
    // final addMerchantProvider = Provider.of<CrudMerchantProvider>(context, listen: false);
    // await addMerchantProvider.clearAllDataFields();
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      _getCurrentLocation();
    } else if (status == PermissionStatus.denied) {
      _showLocationPermissionDeniedDialog();
    } else if (status == PermissionStatus.permanentlyDenied) {
      _showLocationPermissionPermanentlyDeniedDialog();
    }
  }

  Future<void> _getCurrentLocation() async {
    print('calling location');
    final addMerchantProvider = Provider.of<CrudMerchantProvider>(context, listen: false);
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        print('calling location:'+position.latitude.toString()+"..."+position.longitude.toString());
        addMerchantProvider.latitude = position.latitude.toString();
        addMerchantProvider.longitude = position.longitude.toString();
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _showLocationPermissionDeniedDialog() {
    // You can show a dialog to inform the user and ask them to enable permissions
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Permission Denied"),
          content: Text("Please enable location permissions to use this feature."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showLocationPermissionPermanentlyDeniedDialog() {
    // You can show a dialog to inform the user and guide them to app settings
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Permission Permanently Denied"),
          content: Text("Please enable location permissions in app settings."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      final addMerchantProvider = Provider.of<CrudMerchantProvider>(context, listen: false);
      _checkLocationPermission();
      context.read<DistrictProvider>().fetchDistricts();
      Future.delayed(Duration.zero,(){
        addMerchantProvider
            .setDistrictId(addMerchantProvider.districtId.toString());
        // Delayed execution to ensure the district dropdown is populated before setting the upazila
        Future.delayed(Duration(milliseconds: 500), () async{
          // Get the Upazila object from the list using the selectedUpazilaId
          await context.read<UpazilaProvider>().fetchUpazilas(
              int.tryParse(addMerchantProvider.districtId.toString()) ?? -1);
          Upazila selectedUpazila =
          context.read<UpazilaProvider>().upazilas.firstWhere(
                (upazila) =>
            upazila.id.toString() ==
                (addMerchantProvider.upazilaId.toString()),
            orElse: () => Upazila(
                id: -1,
                district: 56,
                upazila: 'N/A'), // Default to a placeholder if not found
          );

          addMerchantProvider.setUpazilaId(selectedUpazila.id.toString());
          context
              .read<UpazilaProvider>()
              .setSelectedUpazilaObject(selectedUpazila);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final addMerchantProvider = Provider.of<CrudMerchantProvider>(context, listen: false);
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('appbar_add_merchant'.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          selectPhotoForMerchant();
                        },
                        child: selectedImagePathForReporting == ''?
                        Icon(
                          Icons.camera_alt,
                          size: 50,
                        ):buildImageForMerchant()),
                    // Replace with your desired icon
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        'image_note'.tr,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                buildRequiredLabel('store_name'.tr, true),
                buildTextField(storeNameController, onChanged: addMerchantProvider.updateShopName, isRequired: true),
                SizedBox(height: 8.0),
                buildRequiredLabel('merchant_name'.tr, true),
                buildTextField(merchantNameController, onChanged: addMerchantProvider.updateFirstName, isRequired: true),
                SizedBox(height: 8.0),
                buildRequiredLabel('phone_no_1'.tr, true),
                buildTextField(phoneNo1Controller,
                    keyboardType: TextInputType.phone, onChanged: addMerchantProvider.updatePrimaryPhoneNumber, isRequired: true),
                SizedBox(height: 8.0),
                buildRequiredLabel('phone_no_2'.tr, false),
                buildTextField(phoneNo2Controller,
                    keyboardType: TextInputType.phone, onChanged: addMerchantProvider.updateSecondPhoneNumber),
                SizedBox(height: 8.0),
                buildRequiredLabel('email'.tr, false),
                buildTextField(emailController,
                    keyboardType: TextInputType.emailAddress, onChanged: addMerchantProvider.updateEmailAddress),
                SizedBox(height: 8.0),
                buildRequiredLabel('nid'.tr, false),
                buildTextField(nidController, keyboardType: TextInputType.number, onChanged: addMerchantProvider.updateNidNumber),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Container(
                    child: Row(
                        children: [
                      Expanded(
                        child:  buildRequiredLabel('select_district'.tr, true),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: buildRequiredLabel('select_upazila'.tr, true),
                      ),
                    ]),
                  ),
                ),
                Card(
                  elevation: 5, // Set the elevation as needed
                  child: Container(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16, left: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Consumer<DistrictProvider>(
                            builder: (context, districtProvider, _) {
                              String selectedDistrict = addMerchantProvider.districtId;
                              return DropdownButton<String>(
                                value: selectedDistrict,
                                onChanged: (value) {
                                  setState(() {
                                    Future.delayed(Duration.zero, () async {
                                      final selectedDistrict = districtProvider.districts.firstWhere((district) =>
                                      district.id.toString() == value);
                                      addMerchantProvider.updateDistrictName(
                                          selectedDistrict.district ?? '');
                                      addMerchantProvider.setDistrictId(value.toString());
                                      await context
                                          .read<UpazilaProvider>()
                                          .fetchUpazilas(
                                          int.tryParse(value ?? '1') ?? 1);
                                      addMerchantProvider.setUpazilaId(context
                                          .read<UpazilaProvider>()
                                          .upazilas
                                          .first
                                          .id
                                          .toString());
                                    });
                                  });
                                },
                                hint: Text('select'.tr),
                                items: [
                                  ...districtProvider.districts.map((District district) {
                                    return DropdownMenuItem<String>(
                                      value: district.id.toString(),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 2.8,
                                        child: Text(district.district),
                                      ),
                                    );
                                  }),
                                ],
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Consumer<UpazilaProvider>(
                            builder: (context, upazilaProvider, _) {
                              return DropdownButton<String>(
                                value: addMerchantProvider.upazilaId,
                                onChanged: (value) {
                                  setState(() {
                                    Future.delayed(Duration.zero,(){
                                      final selectedUpazila = upazilaProvider.upazilas.firstWhere((upazila) =>
                                      upazila.id.toString() == value);
                                      addMerchantProvider.updateUpazilaName(
                                          selectedUpazila.upazila);
                                      addMerchantProvider.setUpazilaId(value.toString());
                                    });
                                  });
                                },
                                hint: Text('select'.tr),
                                items: [
                                  ...upazilaProvider.upazilas.map((Upazila upazila) {
                                    return DropdownMenuItem<String>(
                                      value: upazila.id.toString(),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 2.8,
                                        child: Text(upazila.upazila),
                                      ),
                                    );
                                  }),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                buildRequiredLabel('member_of_joita'.tr, false),
                Row(
                  children: [
                    buildRadioButton('yes'.tr,
                        addMerchantProvider.memberOfJoita == '1',
                        onChanged: (value) {
                          setState(() {
                            addMerchantProvider.updateMemberOfJoita('1');
                          });
                        }),
                    buildRadioButton('no'.tr,
                        addMerchantProvider.memberOfJoita == '0',
                        onChanged: (value) {
                          setState(() {
                            addMerchantProvider.updateMemberOfJoita('0');
                          });
                        }),
                  ],
                ),
                SizedBox(height: 16.0),
                buildRequiredLabel(
                    'take_training'.tr,
                    false),
                Row(
                  children: [
                    buildRadioButton('yes'.tr,
                        addMerchantProvider.isTrainedOfFms == '1',
                        onChanged: (value) {
                          setState(() {
                            addMerchantProvider.updateIsTrainedOfFms('1');
                          });
                        }),
                    buildRadioButton('no'.tr,
                        addMerchantProvider.isTrainedOfFms == '0',
                        onChanged: (value) {
                          setState(() {
                            addMerchantProvider.updateIsTrainedOfFms('0');
                            addMerchantProvider.updateTrainingOfFmsName('');
                          });
                        }),
                  ],
                ),
                if(addMerchantProvider.isTrainedOfFms == '1')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      buildRequiredLabel(
                          'select_training_name'.tr, true),
                      buildDropdownForTraining(
                        value: addMerchantProvider.trainingOfFmsName,
                        onChanged: (value) {
                          setState(() {
                            addMerchantProvider.updateTrainingOfFmsName(value.toString());
                          });
                        },
                      ),
                    ],
                  ),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        buildSwitch(
                            'payment_way'.tr, isMerchantPaymentEnabled,
                            onChanged: (value) {
                          setState(() {
                            isMerchantPaymentEnabled = value!;
                            // Reset the selected payment method and clear the corresponding text fields
                            addMerchantProvider.updatePaymentMethod('');
                            addMerchantProvider.updateAccountName('');
                            addMerchantProvider.updateAccountNumber('');
                            addMerchantProvider.updateBankName('');
                          });
                        }),
                        if (isMerchantPaymentEnabled)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.0),
                              buildRequiredLabel('select_payment_method'.tr, true),
                              Row(
                                children: [
                                  buildRadioButton('bank_account'.tr,
                                      addMerchantProvider.paymentMethod == 'bank',
                                      onChanged: (value) {
                                    setState(() {
                                      addMerchantProvider.updateAccountName('');
                                      addMerchantProvider.updateAccountNumber('');
                                      addMerchantProvider.updateBankName('');
                                      addMerchantProvider.updatePaymentMethod('bank');
                                    });
                                  }),
                                  buildRadioButton('mobile_banking'.tr,
                                      addMerchantProvider.paymentMethod == 'mobilebank',
                                      onChanged: (value) {
                                    setState(() {
                                      addMerchantProvider.updateAccountName('');
                                      addMerchantProvider.updateAccountNumber('');
                                      addMerchantProvider.updateBankName('');
                                      addMerchantProvider.updatePaymentMethod('mobilebank');
                                    });
                                  }),
                                ],
                              ),
                              if (addMerchantProvider.paymentMethod == 'bank')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildRequiredLabel(
                                        'account_holder_name'.tr, true),
                                    buildTextField(accountHolderNameController, onChanged: addMerchantProvider.updateAccountName),
                                    SizedBox(height: 8.0),
                                    buildRequiredLabel('name_of_bank'.tr, true),
                                    buildTextField(bankNameController, onChanged: addMerchantProvider.updateBankName),
                                    SizedBox(height: 8.0),
                                    buildRequiredLabel('account_no'.tr, true),
                                    buildTextField(accountNoController,
                                        keyboardType: TextInputType.number, onChanged: addMerchantProvider.updateAccountNumber),
                                  ],
                                ),
                              if (addMerchantProvider.paymentMethod == 'mobilebank')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildRequiredLabel(
                                        'account_holder_name'.tr, true),
                                    buildTextField(accountHolderNameController, onChanged: addMerchantProvider.updateAccountName),
                                    SizedBox(height: 8.0),
                                    buildRequiredLabel(
                                        'Select_mobile_banking_name'.tr, true),
                                    buildDropdown(
                                      value: addMerchantProvider.bankName,
                                      onChanged: (value) {
                                        setState(() {
                                          addMerchantProvider.updateBankName(value.toString());
                                        });
                                      },
                                    ),
                                    SizedBox(height: 8.0),
                                    buildRequiredLabel('account_no'.tr, true),
                                    buildTextField(accountNoController,
                                        keyboardType: TextInputType.number, onChanged: addMerchantProvider.updateAccountNumber),
                                  ],
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                buildRequiredLabel('address'.tr, true),
                buildTextField(userAddressController, onChanged: addMerchantProvider.updateUserAddress, isRequired: true),
                SizedBox(height: 8.0),
                buildRequiredLabel('password'.tr, true),
                buildTextField(passwordController, onChanged: addMerchantProvider.updateUserPassword, isRequired: true),
                SizedBox(height: 8.0),
                buildRequiredLabel('confirm_password'.tr, true),
                buildTextField(confirmPasswordController,onChanged: addMerchantProvider.updateUserCPassword, isRequired: true),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async{
                        ///demo check
                        var result = await Connectivity().checkConnectivity();
                        setState(() {
                          isConnected = (result != ConnectivityResult.none);
                        });
                        if(!isConnected){
                          showDialog(
                            context: context,
                            builder: (context) => ConnectivityDialog(),
                          );
                        }else{
                          // print('data: '+
                          //     addMerchantProvider.latitude+"--"+
                          //     addMerchantProvider.longitude+"--"+
                          //     addMerchantProvider.firstName+"--"+
                          //     addMerchantProvider.primaryPhoneNumber+"--"+
                          //     addMerchantProvider.secondPhoneNumber+"--"+
                          //     addMerchantProvider.nidNumber+"--"+
                          //     addMerchantProvider.emailAddress+"--"+
                          //     addMerchantProvider.userPassword+"--"+
                          //     addMerchantProvider.userCPassword+"--"+
                          //     addMerchantProvider.shopName+"--"+
                          //     addMerchantProvider.userAddress+"--"+
                          //     selectedImagePathForReporting+"--"+
                          //     addMerchantProvider.districtId+"--"+
                          //     addMerchantProvider.upazilaId+"--"+
                          //     addMerchantProvider.accountName+"--"+
                          //     addMerchantProvider.bankName+"--"+
                          //     addMerchantProvider.paymentMethod+"--"+
                          //     addMerchantProvider.accountNumber+"--"+
                          //     addMerchantProvider.memberOfJoita+"--"+
                          //     addMerchantProvider.trainingOfFmsName+"--"+
                          //     addMerchantProvider.isTrainedOfFms+" --->end"
                          // );

                          ///Actual logic

                          if(isMerchantPaymentEnabled){
                            if(addMerchantProvider.paymentMethod==''){
                              Get.snackbar(
                                "Validation Error!",
                                'validated_payment_method'.tr,
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                borderRadius: 10,
                                margin: EdgeInsets.all(10),
                              );
                            }
                            if(addMerchantProvider.paymentMethod !=''){
                              if(addMerchantProvider.accountName == ''){
                                Get.snackbar(
                                  "Validation Error!",
                                  'validated_account_holder'.tr,
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  borderRadius: 10,
                                  margin: EdgeInsets.all(10),
                                );
                              }else if(addMerchantProvider.bankName == ''){
                                Get.snackbar(
                                  "Validation Error!",
                                  'validated_bank_name'.tr,
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  borderRadius: 10,
                                  margin: EdgeInsets.all(10),
                                );
                              }else if(addMerchantProvider.accountNumber == ''){
                                Get.snackbar(
                                  "Validation Error!",
                                  'validated_ac_number'.tr,
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  borderRadius: 10,
                                  margin: EdgeInsets.all(10),
                                );
                              }
                            }
                          }
                          else if(addMerchantProvider.isTrainedOfFms == '1'){
                            print("--------? "+addMerchantProvider.trainingOfFmsName);
                            if(addMerchantProvider.trainingOfFmsName == ''){
                              {
                                Get.snackbar(
                                  "Validation Error!",
                                  'validated_training_name'.tr,
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  borderRadius: 10,
                                  margin: EdgeInsets.all(10),
                                );
                              }
                            }
                          }
                          if (_formKey.currentState!.validate()) {
                            // The form is valid, perform your actions here
                            final userToken = Provider.of<UserProvider>(context, listen: false).user.token;
                            await addMerchantProvider.sendMerchantDataToServer(context, userToken);
                            print('data: '+
                                addMerchantProvider.latitude+"--"+
                                addMerchantProvider.longitude+"--"+
                                addMerchantProvider.firstName+"--"+
                                addMerchantProvider.primaryPhoneNumber+"--"+
                                addMerchantProvider.secondPhoneNumber+"--"+
                                addMerchantProvider.nidNumber+"--"+
                                addMerchantProvider.emailAddress+"--"+
                                addMerchantProvider.userPassword+"--"+
                                addMerchantProvider.userCPassword+"--"+
                                addMerchantProvider.shopName+"--"+
                                addMerchantProvider.userAddress+"--"+
                                selectedImagePathForReporting+"--"+
                                addMerchantProvider.districtId+"--"+
                                addMerchantProvider.upazilaId+"--"+
                                addMerchantProvider.accountName+"--"+
                                addMerchantProvider.bankName+"--"+
                                addMerchantProvider.paymentMethod+"--"+
                                addMerchantProvider.accountNumber+"--"+
                                addMerchantProvider.memberOfJoita+"--"+
                                addMerchantProvider.trainingOfFmsName+"--"+
                                addMerchantProvider.isTrainedOfFms+" --->end"

                            );
                            await addMerchantProvider.clearAllDataFields();
                            setState(() {
                              storeNameController.text ='';
                              merchantNameController.text ='';
                              phoneNo1Controller.text ='';
                              phoneNo2Controller.text ='';
                              emailController.text ='';
                              nidController.text ='';
                              userAddressController.text ='';
                              passwordController.text ='';
                              confirmPasswordController.text ='';
                              accountHolderNameController.text ='';
                              accountNoController.text ='';
                              isMerchantPaymentEnabled = false;
                            });
                          }
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
                          : Text('add_btn'.tr),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
        required void Function(String value) onChanged, bool isRequired = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Enter value',
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null; // Return null if the validation is successful
      },
    );
  }

  Widget buildRequiredLabel(String label, bool isRequired) {
    return Text(
      '$label',
      style: isRequired
          ? TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
          : TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }

  Widget buildRadioButton(String label, bool value,
      {required ValueChanged<bool?> onChanged}) {
    return Row(
      children: [
        Radio<bool>(
          value: true,
          groupValue: value,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }

  Widget buildSwitch(String label, bool value,
      {required ValueChanged<bool?> onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: value.isNotEmpty ? value : null,
      // Ensure value is not empty before setting
      onChanged: onChanged,
      hint: buildRequiredLabel('Select banking', false),
      isExpanded: true,
      // Set isExpanded to true to make the dropdown icon right-aligned
      icon: Icon(
        Icons.arrow_drop_down, size: 35, // Custom dropdown icon
        color: Theme.of(context).primaryColor, // Customize icon color as needed
      ),
      items: ['Select banking', 'Bkash', 'Rocket', 'Nagad'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget buildDropdownForTraining({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: value.isNotEmpty ? value : null,
      // Ensure value is not empty before setting
      onChanged: onChanged,
      hint: buildRequiredLabel('Select Training', false),
      isExpanded: true,
      // Set isExpanded to true to make the dropdown icon right-aligned
      icon: Icon(
        Icons.arrow_drop_down, size: 35, // Custom dropdown icon
        color: Theme.of(context).primaryColor, // Customize icon color as needed
      ),
      items: ['Select Training',
        'প্রশিক্ষন বাছাই করুন',
        'সেলাই ও এমব্রয়ডারী',
        'ব্লক-বাটিক এন্ড স্ক্রীণ প্রিন্ট',
        'সাবান-মোমবাতি ও শোপিস তৈরী',
        'বাইন্ডিং এন্ড প্যাকেজিং',
        'পোলট্রি উন্নয়ন',
        'খাদ্য প্রক্রিয়াজাতকরণ ও সংরক্ষণ',
        'চামড়াজাত দ্রব্য তৈরী',
        'নকশী কাঁথা ও কাটিং',
        'মোবাইল সার্ভিসিং',
        'বিউটিফিকেশন'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  ///for  image
  Future selectPhotoForMerchant() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'image_alert_dialog'.tr,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            selectedImagePathForReporting =
                                await selectImageFromGallery();
                            if (selectedImagePathForReporting != '') {
                              Navigator.pop(context);
                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("No Image Selected !"),
                              ));
                            }
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/gallery.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    const Text('Gallery'),
                                  ],
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            selectedImagePathForReporting =
                                await selectImageFromCamera();
                            if (selectedImagePathForReporting != '') {
                              Navigator.pop(context);
                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("No Image Captured !"),
                              ));
                            }
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/camera.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    Text('Camera'),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  Widget buildImageForMerchant() => Container(
    child: selectedImagePathForReporting == ''
        ? Container()
        : ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.file(
        File(selectedImagePathForReporting),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    ),
  );
}
