import 'package:behavior_analyzer/APIManager.dart';
import 'package:behavior_analyzer/DemographicForm.dart';
import 'package:behavior_analyzer/StudentSurveyExample.dart';
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
            child: StudentPage(title: 'Student Main Page'),
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


            RaisedButton(onPressed: (){
              Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentSurveyExample()));},
            child:Text("Survey Questions"),),
            RaisedButton(onPressed: (){
              Navigator.push(context,new MaterialPageRoute(builder: (context) => DemographicForm()));},
            child:Text("Demographic Information"),),
            new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed:logoutButton,
                  child: new Text("Logout", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                  color: Colors.red,)
            ),
            new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed: bluetooth,
                  child: new Text("Bluetooth On", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                  color: Colors.blue,)
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


  void bluetooth() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothView()));}
  }
