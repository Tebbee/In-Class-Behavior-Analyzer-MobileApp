import 'package:flutter/material.dart';
import 'ForgotPasswordForm.dart';
import 'PasswordResetForm.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();

}

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
                onPressed: closePage,
              ),
              states[currentState],
            ],
          )
        )
      )
    );
  }

  void closePage() {
    Navigator.pop(context);
  }

  void onRequestResetCodeComplete() {
    setState(() {
      currentState += 1;
    });
  }

  void onPasswordResetComplete() {
    Navigator.pop(context);
  }

}