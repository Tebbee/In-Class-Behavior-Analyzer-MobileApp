import 'package:behavior_analyzer/LoginView.dart';
import 'package:behavior_analyzer/FeedbackView.dart';
import 'package:behavior_analyzer/SubmissionView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(RegisterView());
class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: RegisterPage(title: 'Register Page'),
    );
  }
}



class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  String usernameTextBox = "";
  String passwordTextBox = "";
  String testString = "";
  String emailTextBox = "";
  int counter;

  void registerButton(){
    setState(() {
      testString = "";
      if (usernameTextBox.toString().isEmpty) {
        testString = "Username cannot be blank";
        return;}

      if (usernameTextBox.toString().length < 6){
        testString = "Username must be at least 7 characters";
        return;}

      for (String letter in usernameTextBox.split("")){
        if (letter == "."){
          testString = "The username cannot have a '.' ";
          return;
        }
        if (letter == "@"){
          testString = "The username cannot have a '@";
          return;
        }}

      if (passwordTextBox.toString().isEmpty) {
        testString = "Password cannot be blank";
        return;}

      if (passwordTextBox.length < 8){
        testString = "Password must be at least 8 characters";
        return;}

      if (emailTextBox.isEmpty){
        testString = "We need an email to send this to!";
        return;}


      var url = "http://icba-env.nrvxnah2uj.us-east-1.elasticbeanstalk.com./api/register";
      http.post(url, body: {"username": usernameTextBox, "password": passwordTextBox, "email": emailTextBox})
          .then((response) {
        if (response.body.contains("200")){
          Navigator.push(context,new MaterialPageRoute(builder: (context) => SubmissionView()));
        }
        if (response.body.contains("6")){
          testString = "The password is not strong enough, it may be too similar to your username";        }
      });
    }
    );
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
          child: new Container(
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
                      margin: EdgeInsets.all(5.0),
                      child: new RaisedButton(
                        onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => LoginView()));},
                        child: new Text("Login", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                        color: Colors.red,
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.all(15.0),
                      child: new Text("Register", style: new TextStyle(color: Colors.red,fontStyle: FontStyle.italic,fontSize: 15.0)),
                      color: Colors.white,
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
                new TextField(
                  decoration: new InputDecoration(
                      hintText: "Email"),
                  textAlign: TextAlign.center,
                  onChanged: (String emailSubmission){
                    setState((){
                      emailTextBox = emailSubmission;
                    });},
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.all(5.0),
                      child: new RaisedButton(
                        onPressed:registerButton,
                        child: new Text("Register",
                            style: new TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontSize: 15.0)),
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ]
          ),
          )
        )
    );


  }

}