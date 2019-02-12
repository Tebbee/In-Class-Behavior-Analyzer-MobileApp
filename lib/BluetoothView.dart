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

  var ids = new List<String>();

 Future start() async {
   BluetoothStatus = "Scanning";
   FlutterBlue flutterBlue = FlutterBlue.instance;
   flutterBlue.isOn.then((value1)  {
       BluetoothStatus = (value1.toString());
 }) ;

   print("Starting");
   var scanSubscription = flutterBlue.scan().listen((scanResult) {
     if (!ids.contains(scanResult.device.id.id)) {
     print("Found " + scanResult.device.id.id);
     ids.add(scanResult.device.id.id);
     if (scanResult.device.id.id == "98:01:A7:8F:AC:40") {
     print("Found my MAC!");
     }}
     });
//   BluetoothDevice device;
 //  List<BluetoothService> services = await device.discoverServices();
  // services.forEach((service) {
     //print(service);
     //print(device);
     // do something with service
   //});
//print(scanSubscription);

 }
 void stop(){
   BluetoothStatus = "Stopped";
   return;}

  void refresh(){
    for(var value in ids){
      BluetoothDevices = BluetoothDevices + value+"\n";
    }
    BluetoothStatus = "REFRESHED";
    return;

    //

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
                    child: new Text("Stop", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
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
                new Text(BluetoothDevices),
      ]
    )
    )
    ));
    }
}