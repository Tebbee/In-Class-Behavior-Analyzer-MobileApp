import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:icbaversion2/APIManager.dart';
import 'dart:async';
import 'AppConsts.dart';

///Description: This file consists of all the testing used throughout the program available in a
///commented out subsection within the StudentMainView. This page only requires variables to be kept
///within, all functions were required to be present outside of this file and exist within the StudentMainView
///
///Primary uses:
///   - Storing values of the bluetooth values from the StudentMainPage
///   - Testing for more efficient use of the bluetooth beacons in a visible file
///
///Primary Author: Cody Tebbe
///
///Locations: StudentMainView

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
  String MODULE_NAME = "Bluetooth Error";
  var ids = new List<String>();

  static Object get beaconOne => "88:3F:4A:E5:F6:E2";
  static Object get beaconTwo => "88:3F:4A:E5:FA:7C";
  static Object get beaconThree => "88:3F:4A:E5:FD:C5";
  static var beaconOneCoords = [0.0,0.0];
  static var beaconTwoCoords = [2.7,7.6];
  static var beaconThreeCoords = [6.1,0.0];

  static double beaconRssiValue;
  static double beaconRssiDistance;

  static List beaconNumberOneValueList = new List<double>();
  static List beaconNumberTwoValueList = new List<double>();
  static List beaconNumberThreeValueList = new List<double>();

  static List beaconNumberOneAveragesList = new List<double>();
  static List beaconNumberTwoAveragesList = new List<double>();
  static List beaconNumberThreeAveragesList = new List<double>();

  static var bluetoothScan;

  static int counterOne = 0;
  static int counterTwo = 0;
  static int counterThree = 0;
  static FlutterBlue flutterBlue = FlutterBlue.instance;
  static final double EPSILON = 0.000001;

  static List<double> currentPosition = [0.0,0.0];

  var r;
  var x;
  var y;

  ///Description: Tests if ANY of the beacons were not able to pull a Distance.
  ///If they did not, they will rerun the scanning protocol
  ///Description: Tests how beacons intersect one another via the circleCircleIntersectionPoints function.
  ///This function exists for test purposes within the application
  beaconDistance(firstBeacon, secondBeacon, thirdBeacon, beaconOneDistance, beaconTwoDistance, beaconThreeDistance){
    double x1 = firstBeacon[0];
    double x2 = secondBeacon[0];
    double y1 = firstBeacon[1];
    double y2 = secondBeacon[1];
    //double x3 = thirdBeacon[0];
    //double y3 = thirdBeacon[1];
    //calculateThreeCircleIntersection(x1, y1, beaconOneDistance, x2, y2, beaconTwoDistance, x3, y3, beaconThreeDistance);
    circleCircleIntersectionPoints(x1,y1,beaconOneDistance,x2,y2,beaconTwoDistance);
 }
  ///Description: Tests the intersection point of two circles, whether they be infinitely, not at all, at one point, or many
  ///This exists only for testing purposes within the application. and has removed the third circle
  ///for said testing purposes.
  ///
  ///Parameters: x0, y0, radius0 (r0), x1, y1
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

    return("INTERSECTION: " +intersectionPoint1_x.toString() + "," + intersectionPoint1_y.toString() + ") AND (" + intersectionPoint2_x.toString() + "," + intersectionPoint2_y.toString() + ")");
  }
  ///Description: Tests two circles and returns how they intersect one another, whether their points are connected
  ///via 2 points, one point, infinite points, or no points at all.
  ///
  ///Parameters: x1,y1,radius1 (r1),x2,y2,radius2 (r2)
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
  ///Description: Function utilized within the calculateThreeCircleIntersection and circleCircleIntersectionPoints
  ///(DO NOT ADJUST, THIS IS A MATH EQUATION)
  rotatePoint(fp, pt, a) {
    var x = pt.x - fp.x;
    var y = pt.y - fp.y;
    var xRot = x * cos(a) + y * sin(a);
    var yRot = y * cos(a) - x * sin(a);
    return Point(fp.x+xRot,fp.y+yRot);
  }
  ///Description: Function utilized within the calculateThreeCircleIntersection and circleCircleIntersectionPoints
  ///(DO NOT ADJUST, THIS IS A MATH EQUATION)
  Point(x, y) {
    this.x = x;
    this.y = y;
  }
  ///Description: Function utilized within the calculateThreeCircleIntersection and circleCircleIntersectionPoints
  ///(DO NOT ADJUST, THIS IS A MATH EQUATION)
  acossafe(x) {
    if (x >= 1.0) return 0;
    if (x <= -1.0) return pi;
    return acos(x);
  }




  ///Description: Builds the Apps appearance: Text boxes, buttons, etc. Check Flutter for assistance on editing
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

    )
    ));
    }
  static Timout(){
    Timer timer;
    int timeLeft = 12000; //300 = 5 min 6000 = 1 hr
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
        oneSec,
            (Timer timer) {
          if(timeLeft ==0){
            timer.cancel();
            APIManager.bluetoothStatus = "Scanning OFF";
            APIManager.bluetoothActivated = false;
            APIManager.endSession().then((res){
              print(res.body);});


            return;
          }
          if (timeLeft >0) {
            timeLeft = timeLeft - 1;
          }
          if(APIManager.bluetoothActivated==false)
            timer.cancel();
          //bluetoothScan.cancel();
        });}

  static recordPositionTimer(){
      Timer timer;
      int timeLeft = 30; //300 = 5 min
      const oneSec = const Duration(seconds: 1);
      timer = new Timer.periodic(
          oneSec,
              (Timer timer) {
            if (timeLeft == 4){
              print(beaconNumberOneValueList);
              print(beaconNumberTwoValueList);
              print(beaconNumberThreeValueList);
            }
            if (timeLeft>3){
              beaconScan();
            }
            if (timeLeft == 2){
              calculateLocation();
              bluetoothScan.cancel();
              beaconNumberOneValueList.clear();
              beaconNumberTwoValueList.clear();
              beaconNumberThreeValueList.clear();
            }
            if(timeLeft ==0){
              timer.cancel();
              recordPositionTimer();
              return;
            }
            if (timeLeft >0) {
              print(timeLeft);
              timeLeft = timeLeft - 1;
            }
            if(APIManager.bluetoothActivated==false)
              timer.cancel();
              //bluetoothScan.cancel();
          });

  }

  ///Scans for all the beacons, uses a math equation to find the distance from the beacon, and records the results.
    static beaconScan() async {
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

      Future.delayed(const Duration(seconds: 1), () {
        BluetoothPageState.beaconNumberOneValueList.sort();
        BluetoothPageState.beaconNumberTwoValueList.sort();
        BluetoothPageState.beaconNumberThreeValueList.sort();
      });
    });}

  ///Calculates the intersecting points of the bluetooth beacon circles, and records the results.
  static calculateLocation(){
    var oneAndTwo;
    var twoAndThree;
    var oneAndThree;
    print("One and Two");
    oneAndTwo = BluetoothPageState.calculateThreeCircleIntersection(
        BluetoothPageState.beaconOneCoords[0], BluetoothPageState.beaconOneCoords[1],
        BluetoothPageState.beaconNumberOneValueList[0],
        BluetoothPageState.beaconTwoCoords[0], BluetoothPageState.beaconTwoCoords[1],
        BluetoothPageState.beaconNumberTwoValueList[0]);
    print("One and Three");
    oneAndThree = BluetoothPageState.calculateThreeCircleIntersection(
        BluetoothPageState.beaconOneCoords[0], BluetoothPageState.beaconOneCoords[1],
        BluetoothPageState.beaconNumberOneValueList[0],
        BluetoothPageState.beaconThreeCoords[0], BluetoothPageState.beaconThreeCoords[1],
        BluetoothPageState.beaconNumberThreeValueList[0]);
    print("Three and Two");
    twoAndThree = BluetoothPageState.calculateThreeCircleIntersection(
        BluetoothPageState.beaconThreeCoords[0], BluetoothPageState.beaconThreeCoords[1],
        BluetoothPageState.beaconNumberThreeValueList[0],
        BluetoothPageState.beaconTwoCoords[0], BluetoothPageState.beaconTwoCoords[1],
        BluetoothPageState.beaconNumberTwoValueList[0]);

    if(oneAndTwo.toString().contains("false") || oneAndThree.toString().contains("false") || twoAndThree.toString().contains("false")){
      print("ONE IS FALSE");
      return;
    }
    else{
        print("in the setter");
        APIManager.oneAndTwoX = xSetter(oneAndTwo);
        APIManager.oneAndTwoY = ySetter(oneAndTwo);
        APIManager.oneAndThreeX = xSetter(oneAndThree);
        APIManager.oneAndThreeY = ySetter(oneAndThree);
        APIManager.twoAndThreeX = xSetter(twoAndThree);
        APIManager.twoAndThreeY = ySetter(twoAndThree);

        currentPosition[0]=((double.parse(APIManager.oneAndTwoX)+double.parse(APIManager.oneAndThreeX)+double.parse(APIManager.twoAndThreeX))/3);
        currentPosition[1]=((double.parse(APIManager.oneAndTwoY)+double.parse(APIManager.oneAndThreeY)+double.parse(APIManager.twoAndThreeY))/3);
        if(APIManager.position.isEmpty)
          {
            APIManager.position.add(currentPosition[0]);
            APIManager.position.add(currentPosition[1]);
            APIManager.locationSubmission(APIManager.position[0], APIManager.position[1]);
          }
        if((max(currentPosition[0],APIManager.position[0])-min(currentPosition[0],APIManager.position[0]) > 1)||
            (max(currentPosition[1],APIManager.position[1])-min(currentPosition[1],APIManager.position[1]))>1){
          APIManager.position[0] = currentPosition[0];
          APIManager.position[1] = currentPosition[1];
          APIManager.locationSubmission(APIManager.position[0], APIManager.position[1]);
        }
        print("****************************************");
        print("****************************************");
        print("****************************************");
        print(currentPosition);
        print("****************************************");
        print("****************************************");


    }

  }

  static xSetter(method) {
      var x = method.toString().split(" ")[3].replaceAll(")", "").replaceAll("(", "").split(",")[0].replaceAll("-", "").substring(0,2);
      return(x);
  }
  static ySetter(method) {
    var y = method.toString().split(" ")[3].replaceAll(")", "").replaceAll("(", "").split(",")[1].replaceAll("-", "").substring(0,2);
    return(y);
  }

  ///Tests if the user's bluetooth is on and will tell the user if it is not, connects into beaconScan
  flutterBlueTestOn(){
    flutterBlue.isOn.then((res){
      if(res.toString() == 'true'){
        BluetoothPageState.recordPositionTimer();
      }
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
      return;
    });
  }



}
