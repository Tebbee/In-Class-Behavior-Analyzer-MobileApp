import 'package:behavior_analyzer/InstructorMainView.dart';
import 'package:behavior_analyzer/StudentMainView.dart';
import 'package:behavior_analyzer/RegisterView.dart';
import 'package:behavior_analyzer/FeedbackView.dart';
import 'package:behavior_analyzer/ForgotPasswordView.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(LoginView());
class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginPage(title: 'Login Page'),
    );
  }
}



class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String usernameTextBox = "";
  String passwordTextBox = "";
  String testString = "";
  int counter;

  void loginButton(){
    setState(() {
      if (usernameTextBox.isEmpty){
        testString = "Username cannot be blank";
        return;}

      if (passwordTextBox.isEmpty){
        testString = "Password cannot be blank";
        return;}


      var client = new http.Client();
      client.post(
          "http://192.168.0.45:8000/api/login/",
          body: {"username": usernameTextBox, "password": passwordTextBox})
          .then((response) => testString =(response.body));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:
            SingleChildScrollView(
              child:

        new Container(
          margin: EdgeInsets.all(10.0),
          child: new Column(


              children: <Widget>[
                Card(child: Image.asset('assets/Benny2.jpg'),
                  margin: EdgeInsets.all(10.0),
                  elevation: 0,

                ),
                new Text("Ball State University",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0), textAlign: TextAlign.center,),
                new Text(testString,
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.all(25.0),
                      child: new Text("Login", style: new TextStyle(color: Colors.red,fontStyle: FontStyle.italic,fontSize: 15.0)),
                      color: Colors.white,
                    ),
                    new Container(
                      margin: EdgeInsets.all(5.0),
                      child: new RaisedButton(
                        onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => RegisterView()));},
                        child: new Text("Register", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                        color: Colors.red,
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.all(5.0),
                      child: new RaisedButton(
                        onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => FeedbackView()));},
                        child: new Text("Feedback", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                new TextField(
                  decoration: new InputDecoration(
                      hintText: "Username"),
                  textAlign: TextAlign.center,
                  onChanged: (String usernameSubmission){
                    setState((){
                      usernameTextBox = usernameSubmission;
                    });},
                ),

                new TextField(
                  decoration: new InputDecoration(
                      hintText: "Password"),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (String passwordSubmission){
                    setState((){
                      passwordTextBox = passwordSubmission;
                    });},

                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                      onPressed: loginButton,
                      child: new Text("Login", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                      color: Colors.red,
                    ),),

                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => ForgotPasswordView()));},
                      child: new Text("Forgot Password", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                      color: Colors.red,
                    ),),
                  ],
                )

              ]
          )
          ,)
            )
    );

  }


}