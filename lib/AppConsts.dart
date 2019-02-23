import 'package:flutter/material.dart';

class AppResources {
  static final Color labelTextColor = new Color(0xFFBA0C2F);
  static final Color buttonBackColor = new Color(0xFFBA0C2F);
  static final Color buttonTextColor = Colors.white;

  static final TextStyle labelStyle = new TextStyle(color: labelTextColor);

  static void showErrorDialog(String callingWidget, String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(callingWidget.toUpperCase() + ': ' + message, style: TextStyle(color: Colors.red)),
          );
        }
    );
  }
}