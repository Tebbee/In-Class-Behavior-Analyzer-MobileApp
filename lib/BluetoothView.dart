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
  String BluetoothDevices = "";
  String BluetoothStatus = "";
  String AvailabilityTextBox = "";
  var ids = new List<String>();
  var BeaconNumberOne;
  var BeaconNumberTwo;
  var BeaconNumberThree;
  var bluetoothScan;
  int rssiValue;
  double rssiDistance;
  var beacon = new List<double>();
  double totalbeaconList = 0.0;
  int counter = 0;



  FlutterBlue flutterBlue = FlutterBlue.instance;
 Future start() async {
   print("I STARTED");

   bluetoothScan = flutterBlue.scan().listen((scanResult)

   {
     if (!ids.contains(scanResult.device.id.id)) {
      // print("Found " + scanResult.device.id.id);
       ids.add(scanResult.device.id.id);
     }

     rssiValue = scanResult.rssi;
     rssiDistance = pow(10,(-55 - rssiValue.toDouble()) / (10 * 2));
     if (scanResult.device.id.id == "88:3F:4A:E5:F6:E2") {
       print("The mac address is:" + scanResult.device.id.id);
       print("The distance is: " + rssiDistance.toString() + " meters\n");
     }
     if (scanResult.device.id.id == "88:3F:4A:E5:F6:E2"){
       beacon.add(rssiDistance);
       counter++;
     }


     return new Future.delayed(const Duration(seconds: 3), () {
       bluetoothScan.cancel();

     });
   });
   setState(() {
     flutterBlue.isOn.then((value1) {
       BluetoothStatus = (value1.toString());
     });




   }
       );
 }

  stop(){
   setState(() {
     ids.clear();
     counter = 0;
     BluetoothDevices = "";
     totalbeaconList = 0.0;
     BluetoothStatus = "";
     beacon.clear();
   });


 }

  void refresh(){
   setState(() {
     totalbeaconList = 0;
     for (var value in beacon) {
         BluetoothDevices = BluetoothDevices + value.toString().substring(0,3) + "\n";
     }
     for(var value in beacon){
       totalbeaconList = totalbeaconList + value;
     }
     BluetoothStatus = ("Beacon list = " + totalbeaconList.toString().substring(0,3)
         + "\ncounter was "+ counter.toString()
         + "\nequals: " +(totalbeaconList/counter).toString().substring(0,3));
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
                new Text(BluetoothStatus),
                new Text(BluetoothDevices),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: start,
                    child: new Text("Start", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
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