import 'package:behavior_analyzer/APIManager.dart';
import 'package:behavior_analyzer/DemographicForm.dart';
import 'package:behavior_analyzer/FeedbackForm.dart';
import 'package:behavior_analyzer/StudentSurveyForm.dart';
import 'package:behavior_analyzer/main.dart';
import 'package:behavior_analyzer/BluetoothView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math';
import 'dart:async';
import 'AppConsts.dart';

class StudentMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: AppResources.buttonBackColor,
        body: SafeArea(
            child: StudentPage(title: 'Main Menu'),
        ),
      ),
    );
  }

}

class StudentPage extends StatefulWidget {
  StudentPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  StudentPageState createState() => StudentPageState();
}

class StudentPageState extends State<StudentPage> {


  @override
  initState() {
    super.initState();
  }

  bool isReady = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppResources.buttonBackColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed: surveyButton,
                  child: new Text("Survey", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 20.0)),
                  color: AppResources.buttonBackColor,)
            ),
            new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed: demographicButton,
                  child: new Text("Demographic Information", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 20.0)),
                  color: AppResources.buttonBackColor,)
            ),
            new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed:logoutButton,
                  child: new Text("Logout", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 20.0)),
                  color: AppResources.buttonBackColor,)
            ),
            new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed: bluetooth,
                  child: new Text("Bluetooth", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0)),
                  color: Colors.blue,)
            ),
            new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed: feedbackButton,
                  child: new Text("Feedback", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0)),
                  color: AppResources.buttonBackColor,
                  )
            ),
            ]
          ),
          ),
        );
  }

  void logoutButton(){
    APIManager.logout();
    Navigator.push(context,new MaterialPageRoute(builder: (context) => MyApp()));
    APIManager.SESSION_ID = "";
    }
  void demographicButton(){
    Navigator.push(context,new MaterialPageRoute(builder: (context) => DemographicForm()));
  }
  void surveyButton(){
    Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentSurveyForm()));
  }
  void feedbackButton(){
    Navigator.push(context,new MaterialPageRoute(builder: (context) => FeedbackForm()));

  }
  void bluetooth() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothView()));}
  }
