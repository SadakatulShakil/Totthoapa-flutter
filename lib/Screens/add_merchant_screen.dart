import 'package:flutter/material.dart';

class AddMerchant extends StatefulWidget {
  @override
  _AddMerchantState createState() => _AddMerchantState();
}

class _AddMerchantState extends State<AddMerchant> {
  TextEditingController storeNameController = TextEditingController();
  TextEditingController merchantNameController = TextEditingController();
  TextEditingController phoneNo1Controller = TextEditingController();
  TextEditingController phoneNo2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nidController = TextEditingController();
  bool isLoading = false;
  bool isMemberOfJoyeta = false;
  bool isTakingTraining = false;
  bool isMerchantPaymentEnabled = false;

  String selectedPaymentMethod = '';
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController mobileBankNameController = TextEditingController();
  String selectedMobileBank = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Merchant'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.camera_alt, size: 45,), // Replace with your desired icon
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Text('Upload a photo for the business of the merchant. Type should be .png, .jpg, .jpeg',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              buildRequiredLabel('Store Name*', true),
              buildTextField(storeNameController),
              SizedBox(height: 8.0),
              buildRequiredLabel('Merchant Name*', true),
              buildTextField(merchantNameController),
              SizedBox(height: 8.0),
              buildRequiredLabel('Phone No 1*', true),
              buildTextField(phoneNo1Controller, keyboardType: TextInputType.phone),
              SizedBox(height: 8.0),
              buildRequiredLabel('Phone No 2',false),
              buildTextField(phoneNo2Controller, keyboardType: TextInputType.phone),
              SizedBox(height: 8.0),
              buildRequiredLabel('Email', false),
              buildTextField(emailController, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 8.0),
              buildRequiredLabel('NID', false),
              buildTextField(nidController, keyboardType: TextInputType.number),
              SizedBox(height: 16.0),
              buildRequiredLabel('Are you a member of Joyeta?', false),
              Row(
                children: [
                  buildRadioButton('Yes', false, onChanged: (value) {
                    setState(() {
                      isMemberOfJoyeta = value!;
                    });
                  }),
                  buildRadioButton('No', false, onChanged: (value) {
                    setState(() {
                      isMemberOfJoyeta = value!;
                    });
                  }),
                ],
              ),
              SizedBox(height: 16.0),
              buildRequiredLabel('Are you taking any training from a women\'s organization?', false),
              Row(
                children: [
                  buildRadioButton('Yes', false, onChanged: (value) {
                    setState(() {
                      isTakingTraining = value!;
                    });
                  }),
                  buildRadioButton('No', false, onChanged: (value) {
                    setState(() {
                      isTakingTraining = value!;
                    });
                  }),
                ],
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      buildSwitch('Merchant Payment Way', isMerchantPaymentEnabled, onChanged: (value) {
                        setState(() {
                          isMerchantPaymentEnabled = value!;
                          // Reset the selected payment method and clear the corresponding text fields
                          selectedPaymentMethod = '';
                          accountHolderNameController.clear();
                          bankNameController.clear();
                          accountNoController.clear();
                          mobileBankNameController.clear();
                          selectedMobileBank = '';
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
                                buildRadioButton('Bank Account', selectedPaymentMethod == 'Bank Account',
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPaymentMethod = 'Bank Account';
                                      });
                                    }),
                                buildRadioButton('Mobile Banking', selectedPaymentMethod == 'Mobile Banking',
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPaymentMethod = 'Mobile Banking';
                                      });
                                    }),
                              ],
                            ),
                            if (selectedPaymentMethod == 'Bank Account')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildRequiredLabel('Account Holder Name*', true),
                                  buildTextField(accountHolderNameController),
                                  SizedBox(height: 8.0),
                                  buildRequiredLabel('Name of Bank*', true),
                                  buildTextField(bankNameController),
                                  SizedBox(height: 8.0),
                                  buildRequiredLabel('Account No*', true),
                                  buildTextField(accountNoController, keyboardType: TextInputType.number),
                                ],
                              ),
                            if (selectedPaymentMethod == 'Mobile Banking')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildRequiredLabel('Account Holder Name*', true),
                                  buildTextField(accountHolderNameController),
                                  SizedBox(height: 8.0),
                                  buildRequiredLabel('Select mobile banking name*', true),
                                  buildDropdown(
                                    value: selectedMobileBank,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedMobileBank = value.toString();
                                      });
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  buildRequiredLabel('Account No*', true),
                                  buildTextField(accountNoController, keyboardType: TextInputType.number),
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
              buildTextField(storeNameController),
              SizedBox(height: 8.0),
              buildRequiredLabel('Password*', true),
              buildTextField(merchantNameController),
              SizedBox(height: 8.0),
              buildRequiredLabel('Confirm Password*', true),
              buildTextField(merchantNameController),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform login logic
                      //_login(context);
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
    );
  }

  Widget buildTextField(TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: 'Enter value',
      ),
    );
  }

  Widget buildRequiredLabel(String label, bool isRequired) {
    return Text(
      '$label',
      style: isRequired?TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
          :TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }

  Widget buildRadioButton(String label, bool value, {required ValueChanged<bool?> onChanged}) {
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

  Widget buildSwitch(String label, bool value, {required ValueChanged<bool?> onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
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
      value: value.isNotEmpty ? value : null, // Ensure value is not empty before setting
      onChanged: onChanged,
      hint: buildRequiredLabel('Select banking', false),
      isExpanded: true, // Set isExpanded to true to make the dropdown icon right-aligned
      icon: Icon(Icons.arrow_drop_down, size: 35, // Custom dropdown icon
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
}
