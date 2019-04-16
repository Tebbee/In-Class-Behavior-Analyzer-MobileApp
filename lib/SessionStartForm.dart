import 'APIManager.dart';
import 'package:flutter/material.dart';
import 'AppConsts.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'BluetoothView.dart';


class SessionStartForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: SessionStartPage(title: ''),
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

///Description: Scans for the Bluetooth beacons around the rooms and prepares the survey for future use
///
///Primary Author: Cody Tebbe
///
///Primary Purpose:
///   - Activates automatically
///   - Checks to ensure that the beacons are available
///   - Checks that the user is in a class and will be able to pull a survey
///
class SessionStartPageState extends State<SessionStartPage> {
  static const String MODULE_NAME = 'Session Start Form';
  bool isReady = true;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  var bluetoothScan;
  String beaconOne = "88:3F:4A:E5:F6:E2";
  String beaconTwo = "88:3F:4A:E5:FA:7C";
  String beaconThree = "88:3F:4A:E5:FD:C5";
  int stopper = 0;

  ///Tests if the users bluetooth is on
  flutterBlueTestOn(){
    flutterBlue.isOn.then((res){
      print(res.toString());
      if(res.toString() == 'true'){
        beaconScan();
      }
    else
      setState(() {
      AppResources.showErrorDialog(MODULE_NAME, "The Bluetooth is not activated. Please turn on your bluetooth", context);
    });
    });}

  ///Tests if the users device could support bluetooth
  flutterBlueAvailabilityTest(){
    flutterBlue.isAvailable.then((res){
      if(res.toString() == 'true'){
        flutterBlueTestOn();}
      else
        setState(() {
          AppResources.showErrorDialog(MODULE_NAME, "WARNING! This device does not support required bluetooth capabilities!", context);
        });
      return;
    });}


  ///Sets the SetStateReady variable to true, to prevent copying the same code for multiple lines.
  setStateReady(){
    setState(() {
      isReady = true;
    });
  }

  ///Scans for the devices and ensures that all the beacons will be able to be reached and distances recorded
  Future beaconScan() async {
    int beaconOneRssiValue = 0;
    int beaconTwoRssiValue = 0;
    int beaconThreeRssiValue = 0;

    setState(() {
      isReady = false;
    });

    bluetoothScan = flutterBlue.scan().listen((scanResult) {
      int beaconRssiValue = scanResult.rssi;
      if (scanResult.device.id.id == BluetoothPageState.beaconOne) {beaconOneRssiValue = beaconRssiValue;}
      if (scanResult.device.id.id == BluetoothPageState.beaconTwo){beaconTwoRssiValue = beaconRssiValue;}
      if (scanResult.device.id.id == BluetoothPageState.beaconThree){beaconThreeRssiValue = beaconRssiValue;}

      new Future.delayed(const Duration(seconds: 1), () {
          bluetoothScan.cancel();
          if (beaconOneRssiValue < 0){
            if(beaconTwoRssiValue < 0){
              if (beaconThreeRssiValue < 0){
                if(stopper ==0){
                  BluetoothPageState.test();
                  stopper++;
                  APIManager.scanAttempts = 0;
                }
                setState(() {
                  setStateReady();
                });
              }
              if(beaconThreeRssiValue == 0){
                APIManager.scanAttempts++;
                beaconThreeRssiValue++;
                AppResources.showErrorDialog(MODULE_NAME, "ERROR, Beacon Three wasnt reached. Please try again", context);
                setStateReady();
                setBluetoothScanOff();
              }
            }
            if(beaconTwoRssiValue == 0){
              APIManager.scanAttempts++;
              beaconTwoRssiValue++;
              AppResources.showErrorDialog(MODULE_NAME, "ERROR, Beacon Two wasnt reached. Please try again", context);
              setStateReady();
              setBluetoothScanOff();
            }
          }
          if(beaconOneRssiValue == 0){
            APIManager.scanAttempts++;
            beaconOneRssiValue++;
            AppResources.showErrorDialog(MODULE_NAME, "ERROR, Beacon One wasnt reached. Please try again", context);
            setStateReady();
            setBluetoothScanOff();
          }
          if (APIManager.scanAttempts == 5){
            APIManager.scanAttempts++;
            setStateReady();
            AppResources.showErrorDialog(MODULE_NAME, "ERROR, A beacon wasn't reached after multiple attempts. Please notify an administrator. You may close the app.", context);
            setBluetoothScanOff();
          }
          else{
            setStateReady();
          }
      });
    });
  }

  void setBluetoothScanOff() {
    setState(() {
      APIManager.bluetoothActivated = false;
      APIManager.bluetoothStatus = "Scanning OFF";
    });
  }

  @override
  initState() {
    super.initState();
  }

  ///Builds the view of the app for the user, any updates should be guided by Flutter's website.
  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              alignment: Alignment.topLeft,
              child: new IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);}
              ),
            ),
            new Text("The beacons are being tested for. \nPlease be patient!",
              style: new TextStyle(color: AppResources.buttonBackColor,fontStyle: FontStyle.italic,fontSize: 25.0,),
              softWrap: true,
              textAlign: TextAlign.center,),
            CircularProgressIndicator(),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      //child: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              alignment: Alignment.topLeft,
              child: new IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);}
              ),
            ),
            Container(
              child: Image.asset('assets/benny-main.png', fit: BoxFit.contain, alignment: Alignment.center),
              height: 200.0,
              alignment: Alignment.center,

            ),
            new Container(
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: new Text("This application requires bluetooth to be activated.",
                softWrap: true,
                textAlign: TextAlign.center,
                style: new TextStyle(fontSize: 25.0, color: AppResources.labelTextColor,),
              ),
            ),

            new RaisedButton(
              child: new Text(APIManager.bluetoothStatus,style: TextStyle(fontSize: 30.0),),
              textColor: AppResources.buttonTextColor,
              color: APIManager.bluetoothActivated ? Colors.green:AppResources.buttonBackColor,
              onPressed: buttonLabelChanger,

            ),
          ]
    ));
  }

  buttonLabelChanger(){
    if(APIManager.bluetoothActivated == false){
      setState(() {
        stopper = 0;
        APIManager.bluetoothActivated = true;
        APIManager.bluetoothStatus = "Scanning ON";
      });
      flutterBlueAvailabilityTest();
      return;}

    if(APIManager.bluetoothActivated == true){
      setState(() {
        APIManager.bluetoothActivated = false;
        APIManager.bluetoothStatus = "Scanning OFF";
        bluetoothScan.cancel();
        stopper = 0;
        isReady=true;
        });
      return;
    }
  }

}
