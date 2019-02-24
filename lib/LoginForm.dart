import 'package:behavior_analyzer/StudentDemographicsPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ForgotPasswordPage.dart';
import 'AppConsts.dart';
import 'APIManager.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginForm> {
  static const String MODULE_NAME = 'login_form';

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isReady = true;

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(padding: new EdgeInsets.all(20.0),
        child: Column(
      children: <Widget>[
        new TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: 'Username:',
            labelStyle: TextStyle(color: AppResources.labelTextColor)
          ),
        ),

        SizedBox(height: 20.0),

        new TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password:',
            labelStyle: TextStyle(color: AppResources.labelTextColor)
          ),
        ),

        SizedBox(height: 20.0),

        new RaisedButton(
          color: AppResources.labelTextColor,
          textColor: Colors.white,
          onPressed: loginToServer,
          child: new Text('Submit'),
        ),

        SizedBox(height: 20.0),

        new FlatButton(
          textColor: AppResources.labelTextColor,
          //color: Colors.white,
          child: new Text('Forgot Password?'),
          onPressed: forgotPasswordClick,
        ),
      ],
    ));

  }

  void loginToServer() {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username == "" || username == null) {
      AppResources.showErrorDialog(MODULE_NAME, 'No username!', context);
      return;
    }

    if (password == "" || password == null) {
      AppResources.showErrorDialog(MODULE_NAME, 'No password!', context);
      return;
    }

    if (APIManager.isUserLoggedIn()) {
      AppResources.showErrorDialog(MODULE_NAME, 'User already logged in!', context);
      //return;
    }

    setState(() {
      isReady = false;
    });

    APIManager.login(username, password).then((res) {
      setState(() {
        isReady = true;
      });
      APIManager.parseLoginResponse(res);
      if(APIManager.SESSION_ID != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => StudentDemographicsPage()));

      }
    });
  }
  void forgotPasswordClick() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
  }

}