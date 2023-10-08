import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tottho_apa_flutter/Screens/merchant_details_screen.dart';
import '../Models/merchant_model.dart';
import '../Providers/merchant_provider.dart';
import '../Providers/user_provider.dart';

class AllMerchantScreen extends StatefulWidget {
  @override
  _AllMerchantScreenState createState() => _AllMerchantScreenState();
}

class _AllMerchantScreenState extends State<AllMerchantScreen> {
  @override
  void initState() {
    super.initState();
    final userToken = Provider.of<UserProvider>(context, listen: false).user.token;
    Provider.of<MerchantProvider>(context, listen: false).fetchMerchants(userToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Merchants')),
      body: Consumer<MerchantProvider>(
        builder: (ctx, merchantData, child) {
          final List<Merchant> merchants = merchantData.merchants;

          if (merchants.isEmpty) {
            return Center(child: Text('No merchants available.'));
          }

          return ListView.builder(
            itemCount: merchants.length,
            itemBuilder: (ctx, index) {
              final merchant = merchants[index];
              return MerchantCard(merchant: merchant);
            },
          );
        },
      ),
    );
  }
}

class MerchantCard extends StatelessWidget {
  final Merchant merchant;

  MerchantCard({required this.merchant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MerchantDetailsScreen(merchant)));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4, // Apply elevation for a card-like effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Apply rounded corners
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID: ${merchant.id}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Name: ${merchant.name}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                'Email: ${merchant.email ?? 'N/A'}', // Use null-aware operator
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 4),
              Text(
                'Phone: ${merchant.phone ?? 'N/A'}', // Use null-aware operator
                style: TextStyle(color: Colors.grey[700]),
              ),
              // Add other merchant details...
            ],
          ),
        ),
      ),
    );
  }
}
