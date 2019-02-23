import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';


void main() => runApp(BluetoothView());

class BluetoothView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: BluetoothPage(title: 'Bluetooth Page'),
    );
  }
}


class BluetoothPage extends StatefulWidget {
  BluetoothPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  BluetoothPageState createState() => BluetoothPageState();
}


class BluetoothPageState extends State<BluetoothPage> {
  String bluetoothDevices = "";
  String bluetoothStatus = "";
  var ids = new List<String>();

  String beaconNumberOne = "88:3F:4A:E5:F6:E2";
  int beaconOneRssiValue;
  double beaconOneRssiDistance;
  List beaconNumberOneValueList = new List<double>();
  List beaconNumberOneAveragesList = new List<double>();

  String beaconNumberTwo = "";
  int beaconTwoRssiValue;
  double beaconTwoRssiDistance;
  List beaconNumberTwoValueList = new List<double>();
  List beaconNumberTwoAveragesList = new List<double>();

  String beaconNumberThree = "";
  int beaconThreeRssiValue;
  double beaconThreeRssiDistance;
  List beaconNumberThreeValueList = new List<double>();
  List beaconNumberThreeAveragesList = new List<double>();

  var bluetoothScan;
  double totalbeaconList = 0.0;
  int counter = 0;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  
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
     return new Future.delayed(const Duration(seconds: 5), () {
       bluetoothScan.cancel();
     });
   });
   setState(() {
     flutterBlue.isOn.then((value1) {
       bluetoothStatus = (value1.toString());
     });
   }
   );
 }
  Future beaconTwo() async {
    print("I STARTED");
    bluetoothScan = flutterBlue.scan().listen((scanResult) {
      //  if (!ids.contains(scanResult.device.id.id)) {
      //    ids.add(scanResult.device.id.id);
      //  }
      beaconTwoRssiValue = scanResult.rssi;
      beaconTwoRssiDistance = pow(10,(-55 - beaconTwoRssiValue.toDouble()) / (10 * 2));
      if (scanResult.device.id.id == "XX:XX:XX:XX:XX:XX") {
        print("Beacon Two is: " + beaconTwoRssiDistance.toString() + " meters away\n");
        beaconNumberTwoValueList.add(beaconTwoRssiDistance);
        counter++;
      }
      return new Future.delayed(const Duration(seconds: 5), () {
        bluetoothScan.cancel();
      });
    });
    setState(() {
      flutterBlue.isOn.then((value1) {
        bluetoothStatus = (value1.toString());
      });
    }
    );
  }
  Future beaconThree() async {
    print("I STARTED");
    bluetoothScan = flutterBlue.scan().listen((scanResult) {
      //  if (!ids.contains(scanResult.device.id.id)) {
      //    ids.add(scanResult.device.id.id);
      //  }
      beaconThreeRssiValue = scanResult.rssi;
      beaconThreeRssiDistance = pow(10,(-55 - beaconThreeRssiValue.toDouble()) / (10 * 2));
      if (scanResult.device.id.id == "XX:XX:XX:XX:XX:XX") {
        print("Beacon Three is: " + beaconThreeRssiDistance.toString() + " meters away\n");
        beaconNumberThreeValueList.add(beaconThreeRssiDistance);
        counter++;
      }
      return new Future.delayed(const Duration(seconds: 5), () {
        bluetoothScan.cancel();
      });
    });
    setState(() {
      flutterBlue.isOn.then((value1) {
        bluetoothStatus = (value1.toString());
      });
    }
    );
  }

  stop(){
   setState(() {
     ids.clear();
     counter = 0;
     bluetoothDevices = "";
     totalbeaconList = 0.0;
     bluetoothStatus = "";
     beaconNumberOneValueList.clear();
   });
   
 }
  void refresh(){
   setState(() {
     totalbeaconList = 0;
     for (var value in beaconNumberOneValueList) {
         bluetoothDevices = bluetoothDevices + value.toString() + "\n";
     }
     for(var value in beaconNumberOneValueList){
       totalbeaconList = totalbeaconList + value;
     }
     bluetoothStatus = ("Beacon list = " + totalbeaconList.toString().substring(0,3)
         + "\ncounter was "+ counter.toString()
         + "\nequals: " +(totalbeaconList/counter).toString());
     return;

     //
   });
  }
  button() async{
    setState((){
   print("HERE");
  });
 }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(widget.title),
        ),

        body: SingleChildScrollView(
        child: new Container(
          margin: EdgeInsets.all(10.0),

          child: new Column(


              children: <Widget>[
                Card(child: Image.asset('assets/Benny2.jpg'),
                  margin: EdgeInsets.all(10.0),
                  elevation: 0,

                ),
                new Text("Ball State University",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                  textAlign: TextAlign.center,),
                new Text(bluetoothStatus),
                new Text(bluetoothDevices),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: beaconOne,
                    child: new Text("Beacon One", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: Colors.red,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: beaconTwo,
                    child: new Text("Beacon two", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: Colors.red,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: beaconThree,
                    child: new Text("Beacon Three", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: Colors.red,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: stop,
                    child: new Text("Clear History", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: Colors.red,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: refresh,
                    child: new Text("Refresh", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: Colors.red,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: button,
                    child: new Text("Submit", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: Colors.red,
                  ),
                ),
      ]
    )
    )
    ));
    }
}