import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';
import 'AppConsts.dart';


void main() => runApp(BluetoothView());

class BluetoothView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
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
  String bluetoothOneStatus = "";
  String bluetoothTwoStatus = "";
  String bluetoothThreeStatus = "";
  var ids = new List<String>();

  String beaconOne = "88:3F:4A:E5:F6:E2";
  String beaconTwo = "88:3F:4A:E5:FA:7C";
  String beaconThree = "88:3F:4A:E5:FD:C5";

  var beaconOneCoords = [0,0];
  var beaconTwoCoords = [0,2.5];
  var beaconThreeCoords = [2.5,0];

  int beaconRssiValue;
  double beaconRssiDistance;

  List beaconNumberOneValueList = new List<double>();
  List beaconNumberTwoValueList = new List<double>();
  List beaconNumberThreeValueList = new List<double>();

  List beaconNumberOneAveragesList = new List<double>();
  List beaconNumberTwoAveragesList = new List<double>();
  List beaconNumberThreeAveragesList = new List<double>();

  var bluetoothScan;
  double totalBeaconOneList = 0.0;
  double totalBeaconTwoList = 0.0;
  double totalBeaconThreeList = 0.0;

  int counterOne = 0;
  int counterTwo = 0;
  int counterThree = 0;

  FlutterBlue flutterBlue = FlutterBlue.instance;

  Future beaconScan() async {
    bluetoothScan = flutterBlue.scan().listen((scanResult) {
      beaconRssiValue = scanResult.rssi;
      beaconRssiDistance = pow(10,(-55 - beaconRssiValue.toDouble()) / (10 * 2));
      if (scanResult.device.id.id == beaconOne) {
        print("Beacon One is: " + beaconRssiDistance.toString() + " meters away\n");
        if (beaconRssiDistance < 30){
          beaconNumberOneValueList.add(beaconRssiDistance);
          counterOne++;}
      }
      if (scanResult.device.id.id == beaconTwo) {
        print("Beacon Two is: " + beaconRssiDistance.toString() + " meters away\n");
        if (beaconRssiDistance < 30){
          beaconNumberTwoValueList.add(beaconRssiDistance);
          counterTwo++;
        }
      }
      if (scanResult.device.id.id == beaconThree) {
        print("Beacon Three is: " + beaconRssiDistance.toString() + " meters away\n");
        if (beaconRssiDistance < 30){
          beaconNumberThreeValueList.add(beaconRssiDistance);
          counterThree++;}
      }
      return new Future.delayed(const Duration(seconds: 5), () {
        bluetoothScan.cancel();
      });
    });
  }

  reset(){
   setState(() {
     ids.clear();
     counterOne = 0;
     counterTwo = 0;
     counterThree = 0;
     bluetoothDevices = "";
     totalBeaconOneList = 0.0;
     totalBeaconTwoList = 0.0;
     totalBeaconThreeList = 0.0;
     bluetoothOneStatus = "";
     bluetoothTwoStatus = "";
     bluetoothThreeStatus = "";
     beaconNumberOneValueList.clear();
     beaconNumberTwoValueList.clear();
     beaconNumberThreeValueList.clear();
   });
 }

  void beaconAveraging(){
   setState(() {
     print(beaconNumberOneValueList);
     print(beaconNumberTwoValueList);
     print(beaconNumberThreeValueList);
     for(var value in beaconNumberOneValueList){
       totalBeaconOneList = totalBeaconOneList + value;
     }
     for (var value in beaconNumberTwoValueList){
       totalBeaconTwoList = totalBeaconTwoList + value;
     }
     for (var value in beaconNumberThreeValueList){
       totalBeaconThreeList = totalBeaconThreeList + value;
     }

     bluetoothOneStatus = ("Beacon One list = " + totalBeaconOneList.toString().substring(0,3)
         + "\ncounter was "+ counterOne.toString()
         + "\nequals: " +(totalBeaconOneList/counterOne).toString());
     bluetoothTwoStatus = ("Beacon Two list = " + totalBeaconTwoList.toString().substring(0,3)
         + "\ncounter was "+ counterTwo.toString()
         + "\nequals: " +(totalBeaconTwoList/counterTwo).toString());
     bluetoothThreeStatus = ("Beacon Three list = " + totalBeaconThreeList.toString().substring(0,3)
         + "\ncounter was "+ counterThree.toString()
         + "\nequals: " +(totalBeaconThreeList/counterThree).toString());
     return;

     //
   });
  }
  button() async{
    setState((){
   print(beaconTwoCoords[1].toDouble());
  });
 }


 beaconPositioning(){
    if ((totalBeaconOneList/counterOne) == 0 || (totalBeaconTwoList/counterTwo) == 0 || (totalBeaconThreeList/counterThree) == 0){
      beaconAveraging();
    }


 }

 beaconDistance(firstBeacon, secondBeacon){
    double x1 = firstBeacon[0];
    double x2 = secondBeacon[0];
    double y1 = firstBeacon[1];
    double y2 = secondBeacon[1];
    if (x1 >= x2) {
      if (y1 >= y2) {double Distance = sqrt(pow(2, x1 - x2) + pow(2, y1 - y2)) / 2;}
      if (y1 < y2) {double Distance = sqrt(pow(2, x1 - x2) + pow(2, y2 - y1)) / 2;}
    }
    if (x1 < x2) {
      if (y1 >= y2) {double Distance = sqrt(pow(2, x2 - x1) + pow(2, y1 - y2)) / 2;}
      if (y1 < y2) {double Distance = sqrt(pow(2, x2 - x1) + pow(2, y2 - y1)) / 2;}
    }


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
                new Text(bluetoothOneStatus),
                new Text(bluetoothTwoStatus),
                new Text(bluetoothThreeStatus),
                new Text(bluetoothDevices),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: beaconScan,
                    child: new Text("Beacon One", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: Colors.red,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: reset,
                    child: new Text("Clear History", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: Colors.red,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: beaconAveraging,
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