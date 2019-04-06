import 'APIManager.dart';
import 'package:flutter/material.dart';
import 'LoginForm.dart';
import 'RegisterForm.dart';
import 'AppConsts.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child: LoginPage()
        ),
      ),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => new LoginPage(),
        '/register': (BuildContext context) => new RegisterForm()
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

///Description: The initial page for the entire application and the first page of the login/register group
///The LoginForm is the default section of the application
///
///Primary Author: Ben Lawson
///Secondary Author: Cody Tebbe
///
///Primary Purpose:
///   - Switches the field between login and register
class _LoginPageState extends State<LoginPage> {
  RaisedButton loginButton;
  RaisedButton registerButton;
  RaisedButton feedbackButton;

  Color loginBackColor = AppResources.buttonBackColor;
  Color loginTextColor = AppResources.buttonTextColor;
  Color registerBackColor = AppResources.buttonTextColor;
  Color registerTextColor = AppResources.buttonBackColor;

  LoginForm loginForm = LoginForm();
  RegisterForm registerForm = RegisterForm();
  Widget currentForm;

  ///Upon beginning the application, it tests if anyone is logged in and then attempts to
  ///log them out to prevent any SESSION_ID issues
  @override
  initState() {
    super.initState();
    currentForm = loginForm;
    if(APIManager.SESSION_ID!="")
      APIManager.logout();
  }

  ///Creates the initial application with two buttons, "Login and Register"
  ///Login is the initial application form within the application. Any changes and adjustments
  ///can be assisted with Flutter's website
  @override
  Widget build(BuildContext context) {
    loginButton = new RaisedButton(
        child: new Text('LOGIN'),
        textColor: loginTextColor,
        color: loginBackColor,
        onPressed: login
    );

    registerButton = new RaisedButton(
        child: new Text('REGISTER'),
        textColor: registerTextColor,
        color: registerBackColor,
        onPressed: register
    );

    return Scaffold(
        body: SafeArea(
          child:
          SingleChildScrollView(
              child:
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Image.asset('assets/Benny2.jpg', fit: BoxFit.contain, alignment: Alignment.center),
                      height: 200.0,
                      alignment: Alignment.center,
                    ),
                    SizedBox(height:25.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: loginButton,
                        ),
                        Expanded(
                          child: registerButton,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: currentForm,
                    )
                  ]
              )
          ),
        )
    );
  }

  ///Description: Changes the form to the login form
  void login() {
    setState(() {
      loginTextColor = AppResources.buttonTextColor;
      loginBackColor = AppResources.buttonBackColor;
      registerTextColor = AppResources.buttonBackColor;
      registerBackColor = AppResources.buttonTextColor;

      currentForm = loginForm;
    });
  }

  ///Description: Changes the form to the register form
  void register() {
    setState(() {
      loginTextColor = AppResources.buttonBackColor;
      loginBackColor = AppResources.buttonTextColor;
      registerTextColor = AppResources.buttonTextColor;
      registerBackColor = AppResources.buttonBackColor;
      currentForm = registerForm;
    });
  }

}


