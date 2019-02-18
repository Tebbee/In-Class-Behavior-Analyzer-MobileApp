import 'package:behavior_analyzer/InitialOpenedApp.dart';
import 'package:behavior_analyzer/SubmissionView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(ForgotPasswordView());
class ForgotPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ForgotPasswordPage(title: 'Password Recovery'),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String usernameTextBox = "";
  String testString = "";

  void submit() {
    if (usernameTextBox.isEmpty) {
      testString = "Please insert a Username";
    }
    else {
      var url = "http://192.168.0.235:8000/api/request_password_reset/<str:" +
          usernameTextBox + ">";
      http.get(url)
          .then((response) {
        if (response.body.contains("200")) {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => SubmissionView()));
        }
        if (response.body.contains("6")) {
          testString =response.body.toString();}
      });
    }
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: new Container(
              margin: EdgeInsets.all(10.0),
              child: new Column(
                  children: <Widget>[

                    new Text("Please fill out the username below",
                      style: new TextStyle(fontSize: 20,),),

                    new TextField(
                      decoration: new InputDecoration(hintText: "Username"),
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onSubmitted: (String usernameSubmission) {
                        setState(() {
                          usernameTextBox = usernameSubmission;
                        });
                      },
                    ),
                    new Container(
                      margin: EdgeInsets.all(5.0),
                      child: new RaisedButton(
                        onPressed: submit,
                        child: new Text("Submit", style: new TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 15.0)),
                        color: Colors.red,
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.all(5.0),
                      child: new RaisedButton(
                        onPressed: () {
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => InitialOpenedApp()));
                        },
                        child: new Text("Back", style: new TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 15.0)),
                        color: Colors.red,
                      ),
                    ),
                    new Text(testString,
                      style: new TextStyle(fontSize: 20,),),
                  ]
              )
          )
      );
    }
  }