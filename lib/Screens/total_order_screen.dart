import 'package:flutter/material.dart';

class TotalOrderScreen extends StatefulWidget {
  @override
  _TotalOrderScreenState createState() => _TotalOrderScreenState();
}

class _TotalOrderScreenState extends State<TotalOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
