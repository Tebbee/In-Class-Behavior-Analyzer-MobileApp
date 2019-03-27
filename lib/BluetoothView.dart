import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';
import 'AppConsts.dart';


var x,y;

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

  static Object get beaconOne => "88:3F:4A:E5:F6:E2";
  static Object get beaconTwo => "88:3F:4A:E5:FA:7C";
  static Object get beaconThree => "88:3F:4A:E5:FD:C5";


  static var beaconOneCoords = [0.0,0.0];
  static var beaconTwoCoords = [0.0,2.0];
  static var beaconThreeCoords = [2.0,0.0];

  static double beaconRssiValue;
  static double beaconRssiDistance;

  static List beaconNumberOneValueList = new List<double>();
  static List beaconNumberTwoValueList = new List<double>();
  static List beaconNumberThreeValueList = new List<double>();

  static List beaconNumberOneAveragesList = new List<double>();
  static List beaconNumberTwoAveragesList = new List<double>();
  static List beaconNumberThreeAveragesList = new List<double>();

  static var bluetoothScan;
  static double totalBeaconOneList = 0.0;
  static double totalBeaconTwoList = 0.0;
  static double totalBeaconThreeList = 0.0;

  static double beaconOneAverageDistance;
  static double beaconTwoAverageDistance;
  static double beaconThreeAverageDistance;

  static int counterOne = 0;
  static int counterTwo = 0;
  static int counterThree = 0;
  static FlutterBlue flutterBlue = FlutterBlue.instance;
  static final double EPSILON = 0.000001;

  var r;
  var x;
  var y;

  flutterBlueTestOn(){
    flutterBlue.isOn.then((res){
      if(res.toString() != 'true'){
        setState(() {
          AppResources.showErrorDialog(MODULE_NAME, "The Bluetooth is not activated. Please turn on your bluetooth", context);
          });
        return true;
      }});}
  flutterBlueAvailabilityTest(){
    flutterBlue.isOn.then((res){
      if(res.toString() != 'true'){
        setState(() {
          AppResources.showErrorDialog(MODULE_NAME, "WARNING! This device does not support required bluetooth capabilities!", context);
          });
        return true;
      }});}

  Future beaconScan() async {
    if(flutterBlueAvailabilityTest() && flutterBlueTestOn()){


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
      return new Future.delayed(const Duration(seconds: 30), () {
        bluetoothScan.cancel();
      });
    });}
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
    //calculateThreeCircleIntersection(x1, y1, beaconOneDistance, x2, y2, beaconTwoDistance, x3, y3, beaconThreeDistance);
    circleCircleIntersectionPoints(x1,y1,beaconOneDistance,x2,y2,beaconTwoDistance);
 }

 static calculateThreeCircleIntersection(
      double x0, double y0, double r0,
      double x1, double y1, double r1,
      ) {
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


  }
  
  
  circleCircleIntersectionPoints(x1,y1,r1,x2,y2,r2) {

    var  d, dx, dy;

    if (r1 < r2) {
      r1  = r1;  r2 = r2;
      x1 = x1; y1 = y1;
      x2 = x2; y2 = y2;
    } else {
      r1  = r2; r2  = r1;
      x2 = x1; y2 = y1;
      x1 = x2; y1 = y2;
    }

    dx = (x1 - x2).abs();
    dy = (y1 - y2).abs();

    d = sqrt( dx*dx + dy*dy );
    print("THERE");
    
    if (d < EPSILON && (r2-r1).abs() < EPSILON){
      print("HERE");
      return [];}

    // No intersection (circles centered at the
    // same place with different size)
    else if (d < EPSILON){print("Or here");
    return [];}

    var x = (dx / d) * r2 + x2;
    var y = (dy / d) * r2 + y2;
    var P = Point(x, y);

    // Single intersection (kissing circles)
    if (((r2+r1)-d).abs() < EPSILON || ((r2-(r1+d)).abs() < EPSILON)) {
      print("kissing");
      return [P];}
    // No intersection. Either the small circle contained within
    // big circle or circles are simply disjoint.
    if ( (d+r1) < r2 || (r2+r1 < d) ) {
      print("No intersection");
      return [];}


    var C = Point(x2, y2);
    var angle = acossafe((r1*r1-d*d-r2*r2)/(-2.0*d*r2));
    var pt1 = rotatePoint(C, P, angle);
    var pt2 = rotatePoint(C, P, -1*angle);
    return [pt1, pt2];
  }

   rotatePoint(fp, pt, a) {
    var x = pt.x - fp.x;
    var y = pt.y - fp.y;
    var xRot = x * cos(a) + y * sin(a);
    var yRot = y * cos(a) - x * sin(a);
    return Point(fp.x+xRot,fp.y+yRot);
  }
   Point(x, y) {
    this.x = x;
    this.y = y;
  }
   acossafe(x) {
    if (x >= 1.0) return 0;
    if (x <= -1.0) return pi;
    return acos(x);
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

  static void clearAll() {
    beaconRssiValue = 0;
    beaconRssiDistance = 0;
    beaconNumberOneValueList.clear();
    beaconNumberTwoValueList.clear();
    beaconNumberThreeValueList.clear();
    beaconNumberOneAveragesList.clear();
    beaconNumberTwoAveragesList.clear();
    beaconNumberThreeAveragesList.clear();
    totalBeaconOneList = 0.0;
    totalBeaconTwoList = 0.0;
    totalBeaconThreeList = 0.0;
    beaconOneAverageDistance = 0;
    beaconTwoAverageDistance = 0;
    beaconThreeAverageDistance = 0;
    counterOne = 0;
    counterTwo = 0;
    counterThree = 0;
  }

}
