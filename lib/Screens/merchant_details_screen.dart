import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tottho_apa_flutter/Models/merchant_model.dart';
import 'package:tottho_apa_flutter/Providers/profile_provider.dart';

import '../Providers/connectivity_provider.dart';
import '../Providers/crud_merchant_provider.dart';
import '../Providers/user_provider.dart';
import '../Widgets/connectivity_dialog.dart';
import 'add_merchant_screen.dart';
import 'edit_merchant_screen.dart';

class MerchantDetailsScreen extends StatefulWidget {
  Merchant userData;
  MerchantDetailsScreen(this.userData);
  @override
  _MerchantDetailsScreenState createState() => _MerchantDetailsScreenState();

}

class _MerchantDetailsScreenState extends State<MerchantDetailsScreen>{
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      final addMerchantProvider = Provider.of<CrudMerchantProvider>(context, listen: false);
      print('........: '+ widget.userData.trainingOfMs.toString());
      addMerchantProvider.updateUserId(widget.userData.id.toString()??'');
      addMerchantProvider.updateFirstName(widget.userData.name??'');
      addMerchantProvider.updatePrimaryPhoneNumber(widget.userData.phone??'');
      addMerchantProvider.updateSecondPhoneNumber(widget.userData.phone2??'');
      addMerchantProvider.updateNidNumber(widget.userData.nid??'');
      addMerchantProvider.updateEmailAddress(widget.userData.email??'');
      addMerchantProvider.updateShopName(widget.userData.storeName??'');
      addMerchantProvider.updateUserAddress(widget.userData.userAddress??'');
      addMerchantProvider.updateDistrictId(widget.userData.district.toString()??'');
      addMerchantProvider.updateDistrictName(widget.userData.districtName.toString()??'');
      addMerchantProvider.updateUpazilaName(widget.userData.upazilaName??'');
      addMerchantProvider.updateUpazilaId(widget.userData.upazila.toString()??'');
      addMerchantProvider.updatePaymentMethod(widget.userData.paymentMethod??'');
      addMerchantProvider.updateAccountName(widget.userData.accountName??'');
      addMerchantProvider.updateBankName(widget.userData.bankName??'');
      addMerchantProvider.updateAccountNumber(widget.userData.accountNumber??'');
      addMerchantProvider.updateMemberOfJoita(widget.userData.memberOfJoita.toString()??'');
      addMerchantProvider.updateIsTrainedOfFms(widget.userData.isTraineeOfMs.toString()??'');
      addMerchantProvider.updateTrainingOfFmsName(widget.userData.trainingOfMs.toString()??'');
      if(widget.userData.paymentMethod == null){
        addMerchantProvider.isMerchantPaymentEnabled = false;
      }else{
        addMerchantProvider.isMerchantPaymentEnabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);

    if (connectivityProvider.status == ConnectivityStatus.Offline) {
      // Show the connectivity dialog
      showDialog(
        context: context,
        builder: (context) => ConnectivityDialog(),
      );
    }
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
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditMerchantScreen()));
                },
                  child: Icon(Icons.settings)),
            ),
          ),
        ],
      ),
      body: Consumer<CrudMerchantProvider>(
        builder: (context, addMerchantProvider, _){
         return SingleChildScrollView(
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
                       addMerchantProvider.firstName?? 'N/A',
                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                     ),
                     SizedBox(height: 10),
                     Text(
                       addMerchantProvider.userAddress ?? 'N/A',
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
                         Expanded(child: Text(addMerchantProvider.shopName??'N/A', textAlign: TextAlign.right)),
                       ],
                     ),
                     SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: Text('Phone 01:')),
                         Expanded(child: Text(addMerchantProvider.primaryPhoneNumber??'N/A', textAlign: TextAlign.right)),
                       ],
                     ),
                     SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: Text('Phone 02:')),
                         Expanded(child: Text(addMerchantProvider.secondPhoneNumber??'N/A', textAlign: TextAlign.right)),
                       ],
                     ),
                     SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: Text('Email:')),
                         Text(addMerchantProvider.emailAddress??'N/A', textAlign: TextAlign.right,),
                       ],
                     ),

                     SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: Text('District:')),
                         Text(addMerchantProvider.districtName??'N/A', textAlign: TextAlign.right),
                       ],
                     ),
                     SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: Text('Upazila:')),
                         Text(addMerchantProvider.upazilaName??'N/A', textAlign: TextAlign.right),
                       ],
                     ),
                     SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: Text('Payment method:')),
                         Expanded(child: Text(addMerchantProvider.paymentMethod??'N/A', textAlign: TextAlign.right)),
                       ],
                     ),
                     SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: Text('Account holder:')),
                         Expanded(child: Text(addMerchantProvider.accountName??'N/A', textAlign: TextAlign.right)),
                       ],
                     ),
                     SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: Text('Bank Name/MobileBanking Name:')),
                         Text(addMerchantProvider.bankName??'N/A', textAlign: TextAlign.right),
                       ],
                     ),
                     SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(child: Text('Account number:')),
                         Expanded(child: Text(addMerchantProvider.accountNumber??'N/A', textAlign: TextAlign.right)),
                       ],
                     ),
                   ],
                 ),
               ),
             ],
           ),
         );
        }
      ),
    );
  }
}
