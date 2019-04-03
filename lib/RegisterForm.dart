import 'SubmissionForm.dart';
import 'package:flutter/material.dart';
import 'APIManager.dart';
import 'AppConsts.dart';

class RegisterForm extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

///Description: Shows the user the register form in which they can input their information
///A button clearly shows that this is what they are supposed to use to submit their information
///A pop-up menu will appear if an error is reported, and errors are documented within the register function
///
///Primary Author: Ben Lawson
///Secondary Author: Cody Tebbe
///
///Primary purpose:
///   - creation of a new user
///   - checking to see is the username is taken
///   - checking to see if the password is quality
///
class RegisterState extends State<RegisterForm> {
  static final String MODULE_NAME = 'register_form';

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordConfirmController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();

  bool isReady = true;

  ///Creates the build for the application and everything the user sees
  ///Any updates to this section should be guided by the Flutter Website.
  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(padding: new EdgeInsets.all(20.0), child: Column(
      children: <Widget>[
        new TextFormField(
          controller: usernameController,
          obscureText: false,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: AppResources.labelTextColor),
            //hintText: 'Username...',
            labelText: 'Username:',
          ),
        ),

        SizedBox(height: 20.0),

        new TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: AppResources.labelTextColor),
            labelText: 'Password:',
          ),
        ),

        SizedBox(height: 20.0),

        new TextFormField(
          controller: passwordConfirmController,
          obscureText: true,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: AppResources.labelTextColor),
            labelText: 'Password (Confirm):',
          ),
        ),

        SizedBox(height: 20.0),

        new TextFormField(
            controller: emailController,
            obscureText: false,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: AppResources.labelTextColor),
              labelText: 'Email:',
            )
        ),

        SizedBox(height: 20.0,),

        new TextFormField(
          controller: firstNameController,
          obscureText: false,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: AppResources.labelTextColor),
            labelText: 'First Name:',
          ),
        ),

        SizedBox(height: 20.0),

        new TextFormField(
          controller: lastNameController,
          obscureText: false,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: AppResources.labelTextColor),
            labelText: 'Last Name:',
          ),
        ),

        SizedBox(height: 20.0),

        new RaisedButton(
          color: AppResources.buttonBackColor,
          textColor: AppResources.buttonTextColor,
          onPressed: registerToServer,
          child: new Text('Submit'),
        )
      ],
    ));
  }

  ///registerToServer checks to make sure all fields are filled, the password contains a quality password,
  ///and sends the information to the server via the APIManager. Upon success will
  ///send the user to the Submission form to confirm their submission. Error codes are also
  ///checked with pop-ups in case one occurs.
  void registerToServer() {
    String username = usernameController.text;
    String password = passwordController.text;
    String confirmPassword = passwordConfirmController.text;
    String email = emailController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;

    if (username == "" || username == null) {
      AppResources.showErrorDialog(MODULE_NAME, 'No username!', context);
      return;
    }

    if (password == "" || password == null) {
      AppResources.showErrorDialog(MODULE_NAME, 'No password!', context);
      return;
    }

    if (password != confirmPassword) {
      AppResources.showErrorDialog(MODULE_NAME, 'Passwords do not match!', context);
      return;
    }

    if (email == "" || email == null) {
      AppResources.showErrorDialog(MODULE_NAME, 'No email!', context);
      return;
    }

    setState(() {
      isReady = false;
    });

    APIManager.register(username, password, email, firstName, lastName).then((res) {
      setState(() {
        isReady = true;
        print(res.body);
      });
      if (res.body.contains("success")) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SubmissionForm()));
      }
      if (res.body.contains("106")) {
        AppResources.showErrorDialog(
            MODULE_NAME, "ERROR, Username has been taken", context);
      }
      if (res.body.contains("111")) {
        AppResources.showErrorDialog(
            MODULE_NAME, "ERROR, Not strong enough password", context);}
    });
  }

}