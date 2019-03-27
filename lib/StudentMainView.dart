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
  FlutterBlue flutterBlue = FlutterBlue.instance;
  static const String MODULE_NAME = 'Session Start Form';


  @override
  initState() {
    super.initState();
    flutterBlueAvailabilityTest();
  }
  Future beaconScan() async {

        BluetoothPageState.bluetoothScan = flutterBlue.scan().listen((scanResult) {
        BluetoothPageState.beaconRssiValue = scanResult.rssi.toDouble();
        BluetoothPageState.beaconRssiDistance = pow(10,(-55 - BluetoothPageState.beaconRssiValue.toDouble()) / (10 * 2));
        if (scanResult.device.id.id == BluetoothPageState.beaconOne) {
          //print("Beacon One is: " + BluetoothPageState.beaconRssiDistance.toString() + " meters away\n");
          if (BluetoothPageState.beaconRssiDistance < 30){
            BluetoothPageState.beaconNumberOneValueList.add(BluetoothPageState.beaconRssiDistance);
            BluetoothPageState.counterOne++;}
        }
        if (scanResult.device.id.id == BluetoothPageState.beaconTwo) {
         //print("Beacon Two is: " + BluetoothPageState.beaconRssiDistance.toString() + " meters away\n");
          if (BluetoothPageState.beaconRssiDistance < 30){
            BluetoothPageState.beaconNumberTwoValueList.add(BluetoothPageState.beaconRssiDistance);
            BluetoothPageState.counterTwo++;
          }
        }
        if (scanResult.device.id.id == BluetoothPageState.beaconThree) {
          //print("Beacon Three is: " + BluetoothPageState.beaconRssiDistance.toString() + " meters away\n");
          if (BluetoothPageState.beaconRssiDistance < 30){
            BluetoothPageState.beaconNumberThreeValueList.add(BluetoothPageState.beaconRssiDistance);
            BluetoothPageState.counterThree++;}
        }

        new Future.delayed(const Duration(seconds: 5), () {
          BluetoothPageState.bluetoothScan.cancel();
          BluetoothPageState.beaconNumberOneValueList.sort();
          BluetoothPageState.beaconNumberTwoValueList.sort();
          BluetoothPageState.beaconNumberThreeValueList.sort();

          print("Beacon One");
          print(BluetoothPageState.beaconNumberOneValueList.first);
          print("Beacon Two");
          print(BluetoothPageState.beaconNumberTwoValueList.first);
          print("Beacon Three");
          print(BluetoothPageState.beaconNumberThreeValueList.first);

         new Future.delayed(const Duration (seconds: 10),(){
            calculateLocation();
            BluetoothPageState.clearAll();
            //flutterBlueAvailabilityTest();
          });
        });
      });}

  calculateLocation(){
    BluetoothPageState.calculateThreeCircleIntersection(
        BluetoothPageState.beaconOneCoords[0], BluetoothPageState.beaconOneCoords[1], BluetoothPageState.beaconNumberOneValueList[0],
        BluetoothPageState.beaconTwoCoords[0], BluetoothPageState.beaconTwoCoords[1], BluetoothPageState.beaconNumberTwoValueList[0],);

    BluetoothPageState.calculateThreeCircleIntersection(
      BluetoothPageState.beaconOneCoords[0], BluetoothPageState.beaconOneCoords[1], BluetoothPageState.beaconNumberOneValueList[0],
      BluetoothPageState.beaconThreeCoords[0], BluetoothPageState.beaconThreeCoords[1], BluetoothPageState.beaconNumberThreeValueList[0],);

    BluetoothPageState.calculateThreeCircleIntersection(
      BluetoothPageState.beaconThreeCoords[0], BluetoothPageState.beaconThreeCoords[1], BluetoothPageState.beaconNumberThreeValueList[0],
      BluetoothPageState.beaconTwoCoords[0], BluetoothPageState.beaconTwoCoords[1], BluetoothPageState.beaconNumberTwoValueList[0],);

    }

  void flutterBlueTestOn(){
    flutterBlue.isOn.then((res){
      if(res.toString() == 'true'){
        beaconScan();
      }
      else
        setState(() {
          AppResources.showErrorDialog(MODULE_NAME, "The Bluetooth is not activated. Please turn on your bluetooth", context);
        });

    });}
  flutterBlueAvailabilityTest(){
    flutterBlue.isAvailable.then((res){
      if(res.toString() == 'true'){
        print("AVAILABILITY IS A SUCCESS");
        flutterBlueTestOn();
      }
      else
        setState(() {
          AppResources.showErrorDialog(MODULE_NAME, "WARNING! This device does not support required bluetooth capabilities!", context);
        });
      return false;
    });
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

