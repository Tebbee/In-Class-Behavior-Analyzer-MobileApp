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

  FlutterBlue flutterBlue = FlutterBlue.instance;


 Future start() async {
   print("I STARTED");
   var bluetoothScan;
   bluetoothScan = flutterBlue.scan().listen((scanResult)
   {
     if (!ids.contains(scanResult.device.id.id)) {
       print("Found " + scanResult.device.id.id);
       ids.add(scanResult.device.id.id);
     }
     return new Future.delayed(const Duration(seconds: 5), () {
       bluetoothScan.cancel();
       print("I STOPPED");
     });
   });
   setState(() {
     flutterBlue.isOn.then((value1) {
       BluetoothStatus = (value1.toString());
     });


     AvailabilityTextBox = flutterBlue.isAvailable.toString();


   }
       );
 }

  stop(){
   setState(() {
     ids.clear();
     BluetoothDevices = "";
   });


 }



  void refresh(){
   setState(() {
     for (var value in ids) {
       if(BluetoothDevices.indexOf(value)<0) {
         BluetoothDevices = BluetoothDevices + value + "\n";
       }
     }

     BluetoothStatus = "BlueTooth Devices:";
     return;

     //
   });
  }

  button() async{
    FlutterBlue flutterBlue = FlutterBlue.instance;
    BluetoothDevice device;


    setState((){

   print(BluetoothDeviceState.connected);


   print("HERE");
   var deviceConnection = flutterBlue.connect(device).listen((s) {
     print("INSIDE");
     if(s == BluetoothDeviceState.connected) {
       print("IM HERE");
       print(device.toString());
     }
   });

   /// Disconnect from device
   deviceConnection.cancel();



   BluetoothStatus = flutterBlue.isOn.toString();
   AvailabilityTextBox = flutterBlue.isAvailable.toString();
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
                new Text(AvailabilityTextBox),
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