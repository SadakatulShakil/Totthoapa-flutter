import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/connectivity_provider.dart';
import '../Widgets/connectivity_dialog.dart';

class IncompleteOrderScreen extends StatefulWidget {
  @override
  _IncompleteOrderScreenState createState() => _IncompleteOrderScreenState();
}

class _IncompleteOrderScreenState extends State<IncompleteOrderScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/nodata_image.png', // Replace with your image asset path
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'No Data Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
