import 'SessionStartForm.dart';
import 'StudentMainView.dart';
import 'package:flutter/material.dart';
import 'ForgotPasswordPage.dart';
import 'AppConsts.dart';
import 'APIManager.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

///Description: This class contains all the options for logging into the application
///
///Primary functions:
///   - API call to Login from the APIManager
///
///Primary Author: Ben Lawson
///Secondary Author: Cody Tebbe
///
class LoginState extends State<LoginForm> {
  static const String MODULE_NAME = 'login_form';

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isReady = true;

  ///This function checks to make sure that the SESSION_ID has a value, otherwise it will
  ///attempt to log the user out
  @override
  initState() {
    super.initState();
    if(APIManager.SESSION_ID!=""){
      APIManager.SESSION_ID="";
    }
  }

  ///Building the page on the App. (The text boxes, pictures, buttons) Any assistance on creation
  ///can be directed to Flutter's web page.
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
              //(){Navigator.push(context, MaterialPageRoute(builder: (context) => StudentMainView()));},

              child: new Text('Submit'),
            ),

            SizedBox(height: 20.0),

            new FlatButton(
              textColor: AppResources.labelTextColor,
              child: new Text('Forgot Password?'),
              onPressed: forgotPasswordClick,
            ),
          ],
        ));

  }

  ///Activates the Login function from the APIManager.dart It checks if all the areas and ensures
  ///that they all have a value, and will test the possible error codes that are held within the server
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
      APIManager.logout();
    }

    setState(() {
      isReady = false;
    });

    APIManager.login(username, password).then((res) {
      print(res.body);
      APIManager.parseLoginResponse(res);
      if (APIManager.SESSION_ID == "104,") {
        AppResources.showErrorDialog(MODULE_NAME, "ERROR, \nWrong username. Perhaps a misspelling or capitalized letter?", context);
        APIManager.logout();
        setState(() {
          isReady = true;
        });
        return;
      }
      if (APIManager.SESSION_ID == "105,") {
        AppResources.showErrorDialog(MODULE_NAME, "ERROR, wrong password", context);
        APIManager.logout();
        setState(() {
          isReady = true;
        });
        return;}
      if(APIManager.SESSION_ID != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => StudentMainView()));
        setState(() {
          isReady = true;
        });
      }
      else{
        AppResources.showErrorDialog(MODULE_NAME, "ERROR, contact administration", context);
      }
    });
  }

  ///Activates the ForgotPasswordForm and sends the user to that screen
  void forgotPasswordClick() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
  }
}