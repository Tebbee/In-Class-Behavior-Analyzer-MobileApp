import 'package:flutter/material.dart';
import 'AppConsts.dart';
import 'APIManager.dart';

class ForgotPasswordForm extends StatefulWidget {
  final VoidCallback onComplete;

  const ForgotPasswordForm({Key key, this.onComplete}): super(key:key);

  ForgotPasswordState createState() => ForgotPasswordState(onComplete);
}

///This class is the 2nd stage of the forgotten password function. It requests the username of the user
///and then will send them an email containing a code to reset their password
class ForgotPasswordState extends State<ForgotPasswordForm> {
  VoidCallback onComplete;

  ForgotPasswordState(VoidCallback complete) {
    onComplete = complete;}

  static final String MODULE_NAME = 'forgot_password_form';
  TextEditingController usernameController = new TextEditingController();
  bool isReady = true;

  ///Description: The build function consists of a text field that the user will input their username to
  ///request a password reset for their account, a button to submit , and text to show the user
  ///what they are required to do.
  ///
  ///Primary Author: Ben Lawson
  ///Secondary Author: Cody Tebbe
  ///
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

  ///This function searches the textfield for any input, then attempts to send the request to the
  ///APIManager for an email to be sent to the username.
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