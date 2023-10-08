import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tottho_apa_flutter/Models/merchant_model.dart';
import 'package:tottho_apa_flutter/Providers/profile_provider.dart';

import '../Providers/user_provider.dart';

class MerchantDetailsScreen extends StatefulWidget {
  Merchant merchant;
  MerchantDetailsScreen(this.merchant);
  @override
  _MerchantDetailsScreenState createState() => _MerchantDetailsScreenState();

}

class _MerchantDetailsScreenState extends State<MerchantDetailsScreen>{
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Merchant Information'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                // Handle settings button tap
              },
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                  SizedBox(height: 10),
                  Text(
                    widget.merchant.name ?? 'N/A',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.merchant.userAddress ?? 'N/A',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                      Expanded(child: Text('Store Name:')),
                      Expanded(child: Text(widget.merchant.storeName??'N/A', textAlign: TextAlign.right)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text('Phone 01:')),
                      Expanded(child: Text(widget.merchant.phone??'N/A', textAlign: TextAlign.right)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text('Phone 02:')),
                      Expanded(child: Text(widget.merchant.phone2??'N/A', textAlign: TextAlign.right)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text('Email:')),
                      Text(widget.merchant.email??'N/A', textAlign: TextAlign.right,),
                    ],
                  ),

                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text('District:')),
                      Text(widget.merchant.districtName??'N/A', textAlign: TextAlign.right),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text('Upazila:')),
                      Text(widget.merchant.upazilaName??'N/A', textAlign: TextAlign.right),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text('Payment method:')),
                      Expanded(child: Text(widget.merchant.paymentMethod??'N/A', textAlign: TextAlign.right)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text('Account holder:')),
                      Expanded(child: Text(widget.merchant.accountName??'N/A', textAlign: TextAlign.right)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text('Bank Name/MobileBanking Name:')),
                      Text(widget.merchant.bankName??'N/A', textAlign: TextAlign.right),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text('Account number:')),
                      Expanded(child: Text(widget.merchant.accountNumber??'N/A', textAlign: TextAlign.right)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
