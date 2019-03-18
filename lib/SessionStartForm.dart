import 'package:behavior_analyzer/StudentMainView.dart';
import 'package:flutter/material.dart';
import 'AppConsts.dart';
import 'package:flutter_blue/flutter_blue.dart';


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
  Future beaconScan() async {
    int beaconOneRssiValue = 0;
    int beaconTwoRssiValue = 0;
    int beaconThreeRssiValue = 0;
    setState(() {
      isReady = false;
    });

    bluetoothScan = flutterBlue.scan().listen((scanResult) {
      int beaconRssiValue = scanResult.rssi;
      if (scanResult.device.id.id == "88:3F:4A:E5:F6:E2") {beaconOneRssiValue = beaconRssiValue;}
      if (scanResult.device.id.id == "88:3F:4A:E5:FA:7C"){beaconTwoRssiValue = beaconRssiValue;}
      if (scanResult.device.id.id == "88:3F:4A:E5:FD:C5"){beaconThreeRssiValue = beaconRssiValue;}

      new Future.delayed(const Duration(seconds: 1), () {
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
          AppResources.showErrorDialog(MODULE_NAME, "ERROR, A beacon wasnt reached. Please contact an administrator. You may close the app.", context);
          return;}

        if (beaconOneRssiValue < -10 && beaconTwoRssiValue <- 10 && beaconThreeRssiValue < -10) {
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (context) => StudentMainView()));
          });
        }
      });
      });
  }
}