import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectivityDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('No Internet Connection'),
      content: Text('Please check your internet connection and try again.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    );
  }
}
