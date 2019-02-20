import 'package:behavior_analyzer/RegisterView.dart';
import 'package:behavior_analyzer/LoginView.dart';
import 'package:behavior_analyzer/FeedbackView.dart';
import 'package:behavior_analyzer/BluetoothView.dart';
import 'package:flutter/material.dart';

void main() => runApp(InitialOpenedApp());

class InitialOpenedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'In Classroom Behavior Analyzer'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<MyHomePage> {


  loginButton(){



  }

  registerButton(){


  }

  feedbackButton(){


  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        margin: EdgeInsets.all(10.0),
        child: new Column(


    children: <Widget>[
        Card(child: Image.asset('assets/Benny2.jpg'),
        margin: EdgeInsets.all(10.0),
        elevation: 0,

        ),
        new Text("Ball State University",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0), textAlign: TextAlign.center,),

        new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed: loginButton,
                  child: new Text("Login", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                  color: Colors.red,
                ),
              ),

              new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => RegisterView()));},
                  child: new Text("Register", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                  color: Colors.red,
                ),
              ),
              new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => FeedbackView()));},
                  child: new Text("Feedback", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                  color: Colors.red,
                ),
              ),
            ],
          ),

        new RaisedButton(onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => BluetoothView()));},
          child: new Text("Bluetooth", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 20.0)),
          color: Colors.red,
        ),






            ]
        )

    ,));

    }


}
