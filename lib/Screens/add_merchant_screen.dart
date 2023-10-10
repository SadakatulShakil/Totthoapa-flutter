import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tottho_apa_flutter/Providers/add_merchant_provider.dart';

class AddMerchant extends StatefulWidget {
  @override
  _AddMerchantState createState() => _AddMerchantState();
}

class _AddMerchantState extends State<AddMerchant> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  String selectedPaymentMethod = '';
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController userAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _checkLocationPermission() async {
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
    final addMerchantProvider = Provider.of<AddMerchantProvider>(context, listen: false);
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
    final addMerchantProvider = Provider.of<AddMerchantProvider>(context, listen: false);
    _checkLocationPermission();
    storeNameController.text = addMerchantProvider.shopName;
    merchantNameController.text = addMerchantProvider.firstName;
    phoneNo1Controller.text = addMerchantProvider.primaryPhoneNumber;
    phoneNo2Controller.text = addMerchantProvider.secondPhoneNumber;
    emailController.text = addMerchantProvider.emailAddress;
    nidController.text = addMerchantProvider.nidNumber;
    accountHolderNameController.text = addMerchantProvider.accountName;
    bankNameController.text = addMerchantProvider.bankName;
    accountNoController.text = addMerchantProvider.accountNumber;
    userAddressController.text = addMerchantProvider.userAddress;
    passwordController.text = addMerchantProvider.userPassword;
    confirmPasswordController.text = addMerchantProvider.userCPassword;
  }

  @override
  Widget build(BuildContext context) {
    final addMerchantProvider = Provider.of<AddMerchantProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Merchant'),
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
                        'Upload a photo for the business of the merchant. Type should be .png, .jpg, .jpeg',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                buildRequiredLabel('Store Name*', true),
                buildTextField(storeNameController, onChanged: addMerchantProvider.updateShopName, isRequired: true),
                SizedBox(height: 8.0),
                buildRequiredLabel('Merchant Name*', true),
                buildTextField(merchantNameController, onChanged: addMerchantProvider.updateFirstName, isRequired: true),
                SizedBox(height: 8.0),
                buildRequiredLabel('Phone No 1*', true),
                buildTextField(phoneNo1Controller,
                    keyboardType: TextInputType.phone, onChanged: addMerchantProvider.updatePrimaryPhoneNumber, isRequired: true),
                SizedBox(height: 8.0),
                buildRequiredLabel('Phone No 2', false),
                buildTextField(phoneNo2Controller,
                    keyboardType: TextInputType.phone, onChanged: addMerchantProvider.updateSecondPhoneNumber),
                SizedBox(height: 8.0),
                buildRequiredLabel('Email', false),
                buildTextField(emailController,
                    keyboardType: TextInputType.emailAddress, onChanged: addMerchantProvider.updateEmailAddress),
                SizedBox(height: 8.0),
                buildRequiredLabel('NID', false),
                buildTextField(nidController, keyboardType: TextInputType.number, onChanged: addMerchantProvider.updateNidNumber),
                SizedBox(height: 16.0),
                buildRequiredLabel('Are you a member of Joyeta?', false),
                Row(
                  children: [
                    buildRadioButton('Yes',
                        addMerchantProvider.memberOfJoita == '1',
                        onChanged: (value) {
                          setState(() {
                            addMerchantProvider.updateMemberOfJoita('1');
                          });
                        }),
                    buildRadioButton('No',
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
                    'Are you taking any training from a women\'s organization?',
                    false),
                Row(
                  children: [
                    buildRadioButton('Yes',
                        addMerchantProvider.isTrainedOfFms == '1',
                        onChanged: (value) {
                          setState(() {
                            addMerchantProvider.updateIsTrainedOfFms('1');
                          });
                        }),
                    buildRadioButton('No',
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
                          'Select training name*', true),
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
                            'Merchant Payment Way', isMerchantPaymentEnabled,
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
                              buildRequiredLabel('Select Payment Method*', true),
                              Row(
                                children: [
                                  buildRadioButton('Bank Account',
                                      addMerchantProvider.paymentMethod == 'bank',
                                      onChanged: (value) {
                                    setState(() {
                                      addMerchantProvider.updateAccountName('');
                                      addMerchantProvider.updateAccountNumber('');
                                      addMerchantProvider.updateBankName('');
                                      addMerchantProvider.updatePaymentMethod('bank');
                                    });
                                  }),
                                  buildRadioButton('Mobile Banking',
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
                                        'Account Holder Name*', true),
                                    buildTextField(accountHolderNameController, onChanged: addMerchantProvider.updateAccountName),
                                    SizedBox(height: 8.0),
                                    buildRequiredLabel('Name of Bank*', true),
                                    buildTextField(bankNameController, onChanged: addMerchantProvider.updateBankName),
                                    SizedBox(height: 8.0),
                                    buildRequiredLabel('Account No*', true),
                                    buildTextField(accountNoController,
                                        keyboardType: TextInputType.number, onChanged: addMerchantProvider.updateAccountNumber),
                                  ],
                                ),
                              if (addMerchantProvider.paymentMethod == 'mobilebank')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildRequiredLabel(
                                        'Account Holder Name*', true),
                                    buildTextField(accountHolderNameController, onChanged: addMerchantProvider.updateAccountName),
                                    SizedBox(height: 8.0),
                                    buildRequiredLabel(
                                        'Select mobile banking name*', true),
                                    buildDropdown(
                                      value: addMerchantProvider.bankName,
                                      onChanged: (value) {
                                        setState(() {
                                          addMerchantProvider.updateBankName(value.toString());
                                        });
                                      },
                                    ),
                                    SizedBox(height: 8.0),
                                    buildRequiredLabel('Account No*', true),
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
                buildRequiredLabel('Address*', true),
                buildTextField(userAddressController, onChanged: addMerchantProvider.updateUserAddress, isRequired: true),
                SizedBox(height: 8.0),
                buildRequiredLabel('Password*', true),
                buildTextField(passwordController, onChanged: addMerchantProvider.updateUserPassword, isRequired: true),
                SizedBox(height: 8.0),
                buildRequiredLabel('Confirm Password*', true),
                buildTextField(confirmPasswordController,onChanged: addMerchantProvider.updateUserCPassword, isRequired: true),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async{
                        ///demo check

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
                              "One Payment method is required.",
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
                                "Account holder name is required.",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                borderRadius: 10,
                                margin: EdgeInsets.all(10),
                              );
                            }else if(addMerchantProvider.bankName == ''){
                              Get.snackbar(
                                "Validation Error!",
                                "Bank name is required.",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                borderRadius: 10,
                                margin: EdgeInsets.all(10),
                              );
                            }else if(addMerchantProvider.accountNumber == ''){
                              Get.snackbar(
                                "Validation Error!",
                                "Account number is required.",
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
                                "Training name is required.",
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
                          : Text('Submit'),
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
                      'Select Image from',
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
