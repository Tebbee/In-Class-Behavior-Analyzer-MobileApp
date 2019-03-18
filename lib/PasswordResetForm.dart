import 'package:flutter/material.dart';
import 'AppConsts.dart';
import 'APIManager.dart';

class PasswordResetForm extends StatefulWidget {
  final VoidCallback onComplete;

  const PasswordResetForm({Key key, this.onComplete}): super(key:key);

  PasswordResetState createState() => PasswordResetState(onComplete);
}

class PasswordResetState extends State<PasswordResetForm> {
  VoidCallback onComplete;

  PasswordResetState(VoidCallback complete) {
    onComplete = complete;
  }
  static final String MODULE_NAME = 'password_reset_form';

  TextEditingController resetCodeController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

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
              "A code has been sent to your email\n\n",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppResources.labelTextColor, fontSize: 18.0),
            ),

            Text(
              "Password Reset",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppResources.labelTextColor, fontSize: 30.0),
            ),

            SizedBox(height: 20.0,),

            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Reset Code:',
                  labelStyle: TextStyle(color: AppResources.labelTextColor)
              ),
              controller: resetCodeController,
            ),

            SizedBox(height: 20.0,),

            TextFormField(
              decoration: InputDecoration(
                  labelText: 'New Password:',
                  labelStyle: TextStyle(color: AppResources.labelTextColor)
              ),
              obscureText: true,
              controller: passwordController,
            ),

            SizedBox(height: 20.0,),

            RaisedButton(
              onPressed: submitPasswordReset,
              color: AppResources.buttonBackColor,
              textColor: AppResources.buttonTextColor,
              child: Text("Submit"),
            )
          ],
        )
    );
  }

  void closeButtonPress() {
    Navigator.pop(context);
  }

  void submitPasswordReset() {
    if (resetCodeController.text.isEmpty) {
      AppResources.showErrorDialog(MODULE_NAME, "No reset code!", context);
    }

    if (passwordController.text.isEmpty) {
      AppResources.showErrorDialog(MODULE_NAME, "No password!", context);
    }

    setState(() {
      isReady = false;
    });

    APIManager.resetPassword(resetCodeController.text, passwordController.text).then((res) {
      setState(() {
        isReady = true;
      });
      print(res.body);
      onComplete();
    });
  }

}