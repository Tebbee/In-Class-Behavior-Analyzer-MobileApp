import 'package:behavior_analyzer/InitialOpenedApp.dart';
import 'package:behavior_analyzer/SubmissionView.dart';
import 'package:flutter/material.dart';

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
  String emailTextBox = "";
  String usernameTextBox = "";

  requestPassword(){

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

         new Text("Please fill out on option below", style: new TextStyle(fontSize: 20,),),
            new TextField(
            decoration: new InputDecoration(
                hintText: "Email"),
          textAlign: TextAlign.center,
          onSubmitted: (String emailSubmission){
            setState((){
              emailTextBox = emailSubmission;
            });},
        ),
        new Text("Or", style: new TextStyle(fontSize: 20,),),
        new TextField(
            decoration: new InputDecoration(
                hintText: "Username"),
            obscureText: true,
            textAlign: TextAlign.center,
            onSubmitted: (String usernameSubmission){
              setState((){
                usernameTextBox = usernameSubmission;
              });},
        ),
        new Container(
          margin: EdgeInsets.all(5.0),
          child: new RaisedButton(
          onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => SubmissionView()));},
          child: new Text("Submit", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
          color: Colors.red,
        ),
        ),
         new Container(
           margin: EdgeInsets.all(5.0),
           child: new RaisedButton(
             onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => MyApp()));},
             child: new Text("Back", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
             color: Colors.red,
           ),
         )
                ]
            )
        )
    );
  }
}