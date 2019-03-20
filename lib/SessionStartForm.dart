import 'package:behavior_analyzer/StudentMainView.dart';
import 'package:flutter/material.dart';
import 'AppConsts.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'APIManager.dart';


void main() => runApp(SessionStartForm());

class SessionStartForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: SessionStartPage(title: ''),

        ),
      ),
    );
  }

}

class SessionStartPage extends StatefulWidget {
  SessionStartPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  SessionStartPageState createState() => SessionStartPageState();
}

class SessionStartPageState extends State<SessionStartPage> {
  static const String MODULE_NAME = 'Session Start Form';
  bool isReady = true;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  var bluetoothScan;
  String beaconOne = "88:3F:4A:E5:F6:E2";
  String beaconTwo = "88:3F:4A:E5:FA:7C";
  String beaconThree = "88:3F:4A:E5:FD:C5";
  int scanAttempts = 0;

  Future beaconScan() async {
    int beaconOneRssiValue = 0;
    int beaconTwoRssiValue = 0;
    int beaconThreeRssiValue = 0;
    setState(() {
      isReady = false;
    });

    print("before the res .available");
    flutterBlue.isAvailable.then((res){
      if(res.toString() != 'true'){
        setState(() {
          AppResources.showErrorDialog(MODULE_NAME, "WARNING! This device does not support required bluetooth capabilities!", context);
          isReady = true;});
        return;
      }
    }
    );
    flutterBlue.isOn.then((res){
      if(res.toString() != 'true'){
        setState(() {
          AppResources.showErrorDialog(MODULE_NAME, "The Bluetooth is not activated. Please turn on your bluetooth", context);
          isReady=true;});
        return;
      }
    });


    bluetoothScan = flutterBlue.scan().listen((scanResult) {
      int beaconRssiValue = scanResult.rssi;
      if (scanResult.device.id.id == "88:3F:4A:E5:F6:E2") {beaconOneRssiValue = beaconRssiValue;}
      if (scanResult.device.id.id == "88:3F:4A:E5:FA:7C"){beaconTwoRssiValue = beaconRssiValue;}
      if (scanResult.device.id.id == "88:3F:4A:E5:FD:C5"){beaconThreeRssiValue = beaconRssiValue;}

      new Future.delayed(const Duration(seconds: 2), () {
        bluetoothScan.cancel();
        if(beaconOneRssiValue == 0){
          setState(() {
            isReady = true;
          });
          AppResources.showErrorDialog(MODULE_NAME, "ERROR, Beacon One wasnt reached. Please try again", context);
          beaconOneRssiValue=1;
          scanAttempts++;}

        if(beaconTwoRssiValue == 0){
          setState(() {
            isReady = true;
          });
          AppResources.showErrorDialog(MODULE_NAME, "ERROR, Beacon Two wasnt reached. Please try again", context);
          beaconOneRssiValue=1;
          scanAttempts++;}

        if(beaconThreeRssiValue == 0){
          setState(() {
            isReady = true;
          });
          AppResources.showErrorDialog(MODULE_NAME, "ERROR, Beacon Three wasnt reached. Please try again", context);
          beaconOneRssiValue=1;
          scanAttempts++;}

        if (scanAttempts == 5){
          setState(() {
            isReady = true;
          });
          AppResources.showErrorDialog(MODULE_NAME, "ERROR, A beacon wasn't reached after multiple attempts. Please notify an administrator. You may close the app.", context);
          return;}

        if (beaconOneRssiValue < -10 && beaconTwoRssiValue <- 10 && beaconThreeRssiValue < -10) {
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (context) => StudentMainView()));
          });
        }
      });
      });
  }
  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset('assets/Benny2.jpg', fit: BoxFit.contain, alignment: Alignment.center),
              height: 200.0,
              alignment: Alignment.center,
            ),
            new Container(
              margin: EdgeInsets.all(15.0),
              child: new Text("This application requires bluetooth to be activated.",
                softWrap: true,
                style: new TextStyle(fontSize: 25.0, color: AppResources.labelTextColor),
              ),
            ),
            new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed:beaconScan,
                  child: new Text("Start Session", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0)),
                  color: AppResources.buttonBackColor,)
            ),

          ]
      ),
    );

  }
}