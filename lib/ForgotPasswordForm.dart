import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AppConsts.dart';
import 'PasswordResetForm.dart';
import 'APIManager.dart';

class ForgotPasswordForm extends StatefulWidget {
  final VoidCallback onComplete;

  const ForgotPasswordForm({Key key, this.onComplete}): super(key:key);

  ForgotPasswordState createState() => ForgotPasswordState(onComplete);
}

class ForgotPasswordState extends State<ForgotPasswordForm> {
  VoidCallback onComplete;

  ForgotPasswordState(VoidCallback complete) {
    onComplete = complete;
  }

  static final String MODULE_NAME = 'forgot_password_form';
  TextEditingController usernameController = new TextEditingController();
  bool isReady = true;

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
              "Password Reset",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppResources.labelTextColor, fontSize: 30.0),
            ),

            SizedBox(height: 20.0,),

            Text(
              "You will need to input your username. Within a few minutes, you will recieve an email with a six digit code to reset your password.",
              textAlign: TextAlign.center,
            ),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username:',
                labelStyle: TextStyle(color: AppResources.labelTextColor)
              ),
              controller: usernameController,
            ),

            SizedBox(height: 20.0,),

            RaisedButton(
              onPressed: submitUsernameForReset,
              color: AppResources.buttonBackColor,
              textColor: AppResources.buttonTextColor,
              child: Text("Submit"),
            )
          ],
        )
    );
  }

  void submitUsernameForReset() {
    if (usernameController.text.isEmpty) {
      AppResources.showErrorDialog(MODULE_NAME, "No username!", context);
    }

    setState(() {
      isReady = false;
    });

    APIManager.requestResetPassword(usernameController.text).then((res) {
      setState(() {
        isReady = true;
      });

      print(res.body);
      onComplete();
    });
  }


}