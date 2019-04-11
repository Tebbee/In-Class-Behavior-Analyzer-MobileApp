import 'APIManager.dart';
import 'DemographicForm.dart';
import 'FeedbackForm.dart';
import 'StudentSurveySelection.dart';
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
    //flutterBlueAvailabilityTest();
  }

  ///Scans for all the beacons, uses a math equation to find the distance from the beacon, and records the results.
  Future beaconScan() async {
    BluetoothPageState.bluetoothScan = flutterBlue.scan().listen((scanResult) {
      print("HERE");
      BluetoothPageState.beaconRssiValue = scanResult.rssi.toDouble();
      BluetoothPageState.beaconRssiDistance = pow(10,(-55 - BluetoothPageState.beaconRssiValue.toDouble()) / (10 * 2));
      if (scanResult.device.id.id == BluetoothPageState.beaconOne) {
        print("Beacon One is: " + BluetoothPageState.beaconRssiDistance.toString() + " meters away\n");
        if (BluetoothPageState.beaconRssiDistance < 30){
          BluetoothPageState.beaconNumberOneValueList.add(BluetoothPageState.beaconRssiDistance);
          BluetoothPageState.counterOne++;}
      }
      if (scanResult.device.id.id == BluetoothPageState.beaconTwo) {
        print("Beacon Two is: " + BluetoothPageState.beaconRssiDistance.toString() + " meters away\n");
        if (BluetoothPageState.beaconRssiDistance < 30){
          BluetoothPageState.beaconNumberTwoValueList.add(BluetoothPageState.beaconRssiDistance);
          BluetoothPageState.counterTwo++;
        }
      }
      if (scanResult.device.id.id == BluetoothPageState.beaconThree) {
        print("Beacon Three is: " + BluetoothPageState.beaconRssiDistance.toString() + " meters away\n");
        if (BluetoothPageState.beaconRssiDistance < 30){
          BluetoothPageState.beaconNumberThreeValueList.add(BluetoothPageState.beaconRssiDistance);
          BluetoothPageState.counterThree++;}
      }

      Future.delayed(const Duration(seconds: 5), () {
        BluetoothPageState.bluetoothScan.cancel();
        BluetoothPageState.beaconNumberOneValueList.sort();
        BluetoothPageState.beaconNumberTwoValueList.sort();
        BluetoothPageState.beaconNumberThreeValueList.sort();

        Future.delayed(const Duration (seconds: 10),(){
          calculateLocation();
          // BluetoothPageState.clearAll();
           flutterBlueAvailabilityTest();
        });
      });
    });}


  ///Calculates the intersecting points of the bluetooth beacon circles, and records the results.
  calculateLocation(){
    print("One and Two");
    print(BluetoothPageState.calculateThreeCircleIntersection(
        BluetoothPageState.beaconOneCoords[0], BluetoothPageState.beaconOneCoords[1], BluetoothPageState.beaconNumberOneValueList[0],
        BluetoothPageState.beaconTwoCoords[0], BluetoothPageState.beaconTwoCoords[1], BluetoothPageState.beaconNumberTwoValueList[0]));
    print("One and Three");
    print(BluetoothPageState.calculateThreeCircleIntersection(
      BluetoothPageState.beaconOneCoords[0], BluetoothPageState.beaconOneCoords[1], BluetoothPageState.beaconNumberOneValueList[0],
      BluetoothPageState.beaconThreeCoords[0], BluetoothPageState.beaconThreeCoords[1], BluetoothPageState.beaconNumberThreeValueList[0]));
    print("Three and Two");
    print(BluetoothPageState.calculateThreeCircleIntersection(
      BluetoothPageState.beaconThreeCoords[0], BluetoothPageState.beaconThreeCoords[1], BluetoothPageState.beaconNumberThreeValueList[0],
      BluetoothPageState.beaconTwoCoords[0], BluetoothPageState.beaconTwoCoords[1], BluetoothPageState.beaconNumberTwoValueList[0]));
    }

  ///Tests if the user's bluetooth is on and will tell the user if it is not, connects into beaconScan
  void flutterBlueTestOn(){
    flutterBlue.isOn.then((res){
      if(res.toString() == 'true'){
        beaconScan();}
      else
        setState(() {
          AppResources.showErrorDialog(MODULE_NAME, "The Bluetooth is not activated. Please turn on your bluetooth", context);
        });
    });}

  ///Tests if the user's bluetooth is available and will tell the user if it is not, connects into flutterBlueTestOn
  flutterBlueAvailabilityTest(){
    flutterBlue.isAvailable.then((res){
      if(res.toString() == 'true'){
        flutterBlueTestOn();}
      else
        setState(() {
          AppResources.showErrorDialog(MODULE_NAME, "WARNING! This device does not support required bluetooth capabilities!", context);
        });
      return false;
    });
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

  ///Sends the user to the Bluetooth page to be used for testing for developers
  void bluetooth() {
    setStateFalse();
    Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothView()));}
}

