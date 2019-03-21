import 'dart:math';
import 'package:behavior_analyzer/APIManager.dart';
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
  String MODULE_NAME = "Bluetooth Error";
  var ids = new List<String>();

  String beaconOne = "88:3F:4A:E5:F6:E2";
  String beaconTwo = "88:3F:4A:E5:FA:7C";
  String beaconThree = "88:3F:4A:E5:FD:C5";

  var beaconOneCoords = [0.0,0.0];
  var beaconTwoCoords = [1.0,0.0];
  var beaconThreeCoords = [0.0,1.0];

  double beaconRssiValue;
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
  final double EPSILON = 0.000001;

  var r;
  var x;
  var y;

  Future beaconScan() async {

    flutterBlue.isAvailable.then((res){
      if(res.toString() != 'true'){
        setState(() {
          AppResources.showErrorDialog(MODULE_NAME, "WARNING! This device does not support required bluetooth capabilities!", context);
          });
        return;
      }
    }
    );
    flutterBlue.isOn.then((res){
      if(res.toString() != 'true'){
        setState(() {
          AppResources.showErrorDialog(MODULE_NAME, "The Bluetooth is not activated. Please turn on your bluetooth", context);
          });
        return;
      }
    });
    bluetoothScan = flutterBlue.scan().listen((scanResult) {
      beaconRssiValue = scanResult.rssi.toDouble();
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
      beaconPositioning();
      beaconDistance(beaconOneCoords,beaconTwoCoords,beaconThreeCoords,
     //  4.93,4.14,3.501);
       totalBeaconOneList/counterOne,
       totalBeaconTwoList/counterTwo,
       totalBeaconThreeList/counterThree);
  });
 }


  /// Tests if ANY of the beacons were not able to pull a Distance. If not, they will rerun the scanning protocol
 beaconPositioning(){
    if ((totalBeaconOneList/counterOne) == 0 || (totalBeaconTwoList/counterTwo) == 0 || (totalBeaconThreeList/counterThree) == 0){
      beaconScan();
    }
 }

 beaconDistance(firstBeacon, secondBeacon, thirdBeacon, beaconOneDistance, beaconTwoDistance, beaconThreeDistance){
    double x1 = firstBeacon[0];
    double x2 = secondBeacon[0];
    double y1 = firstBeacon[1];
    double y2 = secondBeacon[1];
    double x3 = thirdBeacon[0];
    double y3 = thirdBeacon[1];
    calculateThreeCircleIntersection(x1, y1, beaconOneDistance, x2, y2, beaconTwoDistance, x3, y3, beaconThreeDistance);

 }

 calculateThreeCircleIntersection(
      double x0, double y0, double r0,
      double x1, double y1, double r1,
      double x2, double y2, double r2) {
    double a, dx, dy, d, h, rx, ry;
    double point2_x, point2_y;

    dx = x1 - x0;
    dy = y1 - y0;

    d = sqrt((dy*dy) + (dx*dx));

    if (d > (r0 + r1))
    {
      print("THEY DID NOT COLLIDE");
      return false;
    }
    if (d < max(r0,r1)-min(r0,r1))
    {
      print("ONE CIRCLE IS INSIDE THE OTHER");
      return false;
    }
    a = ((r0*r0) - (r1*r1) + (d*d)) / (2.0 * d) ;

    point2_x = x0 + (dx * a/d);
    point2_y = y0 + (dy * a/d);

    h = sqrt((r0*r0) - (a*a));

    rx = -dy * (h/d);
    ry = dx * (h/d);

    double intersectionPoint1_x = point2_x + rx;
    double intersectionPoint2_x = point2_x - rx;
    double intersectionPoint1_y = point2_y + ry;
    double intersectionPoint2_y = point2_y - ry;

    print("INTERSECTION Circle1 AND Circle2: (" + intersectionPoint1_x.toString() + "," + intersectionPoint1_y.toString() + ") AND (" + intersectionPoint2_x.toString() + "," + intersectionPoint2_y.toString() + ")");

    dx = intersectionPoint1_x - x2;
    dy = intersectionPoint1_y - y2;
    double d1 = sqrt((dy*dy) + (dx*dx));

    dx = intersectionPoint2_x - x2;
    dy = intersectionPoint2_y - y2;
    double d2 = sqrt((dy*dy) + (dx*dx));


    if(max(d1, r2)-min(d1,r2) < EPSILON) {
      print("INTERSECTION Circle1 AND Circle2 AND Circle3: (" + intersectionPoint1_x.toString() + "," + intersectionPoint1_y.toString() + ")");
    }
    else if(max(d2 , r2)-min(d2,r2) < EPSILON) {
      print("INTERSECTION Circle1 AND Circle2 AND Circle3: (" + intersectionPoint2_x.toString() + "," + intersectionPoint2_y.toString() + ")"); //here was an error
    }
    else {
      print("INTERSECTION Circle1 AND Circle2 AND Circle3: NONE");
    }
    return true;
  }


  /// Builds the Apps appearance: Text boxes, buttons, etc.
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