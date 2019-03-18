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


void main() => runApp(StudentMainView());

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
  FlutterBlue flutterBlue = FlutterBlue.instance;
  var bluetoothScan;
  int beaconOneRssiValue;
  double beaconOneRssiDistance;
  List beaconNumberOneValueList = new List<double>();
  List beaconNumberOneAveragesList = new List<double>();
  int counter = 0;
  double beaconOneTotal=0.0;
  var outlierChecker = 0;
  var totalbeaconList = 0.0;
  String blueToothStatus = "hello";


  @override
  Widget build(BuildContext context) {
    blueToothStatus = "";
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
            new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed: beaconOneSubmit,
                  child: new Text("Bluetooth Submit", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                  color: Colors.blue,)
            ),
            new Text(blueToothStatus),
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

  Future beaconOne() async {
    print("I STARTED");
    bluetoothScan = flutterBlue.scan().listen((scanResult) {

      beaconOneRssiValue = scanResult.rssi;
      beaconOneRssiDistance = pow(10,(-55 - beaconOneRssiValue.toDouble()) / (10 * 2));
      if (scanResult.device.id.id == "88:3F:4A:E5:F6:E2") {
        print("Beacon One is: " + beaconOneRssiDistance.toString() + " meters away\n");
        beaconNumberOneValueList.add(beaconOneRssiDistance);
        counter++;
      }
      if (scanResult.device.id.id == "88:3F:4A:E5:FA:7C"){
        print("Beacon Two is: " + beaconOneRssiDistance.toString() + " meters away\n");
        counter++;
      }
      if (scanResult.device.id.id == "88:3F:4A:E5:FD:C5"){
        print("Beacon Three is: " + beaconOneRssiDistance.toString() + " meters away\n");
        counter++;
      }

      new Future.delayed(const Duration(seconds: 4), () {
        bluetoothScan.cancel();
    });
      });
}

  beaconOneSubmit() {
    setState(() {
      for (var value in beaconNumberOneValueList) {
        totalbeaconList = totalbeaconList + value;
        outlierChecker++;
      }
      print("Beacon list = " + totalbeaconList.toString().substring(0, 3)
          + "\ncounter was " + counter.toString()
          + "\nequals: " + (totalbeaconList / counter).toString());
      APIManager.locationSubmission((totalbeaconList/counter).roundToDouble(), 0.0).then((res) {
        setState(() {
          print(APIManager.SESSION_ID);
          print(res.body);

        });
      });
  });
}

  void bluetooth() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothView()));}
  }
