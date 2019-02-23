import 'package:behavior_analyzer/RegisterView.dart';
import 'package:behavior_analyzer/StudentDemographicsPage.dart';
import 'package:behavior_analyzer/StudentSurveyExample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:async';


void main() => runApp(StudentMainView());

class StudentMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StudentPage(title: 'Student Home Page'),
    );
  }
}

//

class StudentPage extends StatefulWidget {
  StudentPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  StudentPageState createState() => StudentPageState();
}

class StudentPageState extends State<StudentPage> {

  FlutterBlue flutterBlue = FlutterBlue.instance;
  var bluetoothScan;
  String beaconNumberOne = "88:3F:4A:E5:F6:E2";
  int beaconOneRssiValue;
  double beaconOneRssiDistance;
  List beaconNumberOneValueList = new List<double>();
  List beaconNumberOneAveragesList = new List<double>();
  int counter = 0;
  double beaconOneTotal=0.0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            RaisedButton(onPressed: (){
              Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentSurveyView()));},
            child:Text("Survey Questions"),),
            RaisedButton(onPressed: (){
              Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentDemographicsView()));},
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
                  onPressed: beaconOne,
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
            ]
              ),
      ),
        );

  }

  void logoutButton(){
    var url = "http://icba-env.nrvxnah2uj.us-east-1.elasticbeanstalk.com/api/logout";
    http.get(url)
        .then((response) {
      Navigator.push(context,new MaterialPageRoute(builder: (context) => RegisterView()));},);
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
      new Future.delayed(const Duration(seconds: 5), () {
        bluetoothScan.cancel();
    });
      });


}beaconOneSubmit() {
    setState(() {
      var totalbeaconList = 0.0;
      for (var value in beaconNumberOneValueList) {
        totalbeaconList = totalbeaconList + value;
      }
      print("Beacon list = " + totalbeaconList.toString().substring(0, 3)
          + "\ncounter was " + counter.toString()
          + "\nequals: " + (totalbeaconList / counter).toString());


      var url = "http://icba-env.nrvxnah2uj.us-east-1.elasticbeanstalk.com./api/position/create?";
      http.post(url, body: {"x": totalbeaconList/counter, "y": 0})
          .then((response) {

    });
  });
}
}