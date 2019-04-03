import 'package:flutter/material.dart';
import 'ForgotPasswordForm.dart';
import 'PasswordResetForm.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();

}

///Description: This is the initial page of the Forgot Password process. Depending on what stage is required,
///will depend on what form is shown, whether it be PasswordResetForm or ForgotPasswordForm.
///
///Primary Author: Ben Lawson
///Secondary Author: Cody Tebbe
class ForgotPasswordState extends State<ForgotPasswordPage> {
  static final String MODULE_NAME = "forgot_passsword_page";

  List<StatefulWidget> states;
  int currentState = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ForgotPasswordForm fpf = new ForgotPasswordForm(onComplete: this.onRequestResetCodeComplete,);
    PasswordResetForm prf = new PasswordResetForm(onComplete: this.onPasswordResetComplete,);
    states = [fpf, prf];
  }

  ///This function builds the page for the application,
  ///variable currentState determines which page is shown, ForgotPasswordPage or PasswordResetForm
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.close),
                onPressed: closePage,),
              states[currentState],
            ],
          )
        )
      )
    );
  }

  ///Upon utilization the page will be sent to the previous screen in an instant
  void closePage() {
    Navigator.pop(context);
  }

  ///This function will change the Form to appear like the PasswordResetForm
  void onRequestResetCodeComplete() {
    setState(() {
      currentState += 1;
    });
  }

  ///Upon utilization the page will be sent to the previous screen in an instant.
  void onPasswordResetComplete() {
    Navigator.pop(context);
  }

}