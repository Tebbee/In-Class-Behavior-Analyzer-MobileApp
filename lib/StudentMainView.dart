import 'APIManager.dart';
import 'DemographicForm.dart';
import 'FeedbackForm.dart';
import 'main.dart';
import 'BluetoothView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math';
import 'dart:async';
import 'AppConsts.dart';
import 'SurveyMainPage.dart';
import 'SessionStartForm.dart';

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

///Description:Tests over a set amount of time if the bluetooth beacons could be connected to, records their information,
///sends it to the server, and shows other options that a user can activate (Survey, demographics, feedback)
///
///Primary Author: Cody Tebbe
///
///Primary Functions:
///   - Automatically searches and records distances of the bluetooth beacons
///   - Tracks the position of the user from the beacons
///   - Restarts after a set amount of time
///   - Provides a path to the survey, demographics, and feedback
///
class StudentPageState extends State<StudentPage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  static const String MODULE_NAME = 'Session Start Form';

  @override
  initState() {
    super.initState();
  }


  bool isReady = true;

  ///Creates the build and view for the user. Any adjustments to the view would best be guided by the
  ///Flutter website
  @override
  Widget build(BuildContext context) {
    
    if (!isReady) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return new DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("ICBA"),
            backgroundColor: AppResources.buttonBackColor,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.announcement)),
                Tab(icon: Icon(Icons.accessibility_new)),
                Tab(icon: Icon(Icons.email)),
              ],
            ),
          ),

          drawer: new Drawer(
            child: new ListView(
              children: <Widget>[
                new ListTile(
                  title: Text("Session"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SessionStartForm()));
                  },
                ),
                new Divider(
                  color: Colors.black,
                ),
                new ListTile(
                  title: Text("Logout"),
                  onTap: () {
                    APIManager.logout();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                  },
                ),
                new Divider(
                  color: Colors.black,
                )
              ],
            )
          ),

          body: TabBarView(
              children: [
                SurveyMainWidget(),
                DemographicForm(),
                FeedbackPage()
              ]
          )
        )
    );
  }

  void setStateFalse() {setState(() {isReady = false;});}

  ///Logs the user out of the app, and sends them to the beginning login/register screen
  void logoutButton(){
    setStateFalse();
    APIManager.logout();
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    }

  ///Sends the user to the Demographics page to be utilized further
  void demographicButton(){
    setStateFalse();
    Navigator.push(context, MaterialPageRoute(builder: (context) => DemographicForm()));
  }

  ///Sends the user to the Feedback form to be utilized further
  void feedbackButton(){
    setStateFalse();
    Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackForm()));}

}

