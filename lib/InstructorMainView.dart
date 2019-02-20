import 'package:behavior_analyzer/InstructorDemographicsView.dart';
import 'package:behavior_analyzer/InstructorMapView.dart';
import 'package:behavior_analyzer/InstructorSurveyView.dart';
import 'package:behavior_analyzer/InitialOpenedApp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(InstructorMainView());
class InstructorMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: InstructorPage(title: 'Instructor Home Page'),
    );
  }
}


class InstructorPage extends StatefulWidget {
  InstructorPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  InstructorPageState createState() => InstructorPageState();
}

class InstructorPageState extends State<InstructorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => InstructorSurveyView()));},
                child:Text("Survey Questions"),),
              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => InstructorDemographicsView()));},
                child:Text("Demographic Information"),),
              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => InstructorMapView()));},
                child:Text("Class Map"),),
              new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                onPressed:logoutButton,
                child: new Text("Logout", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                color: Colors.red,)
              )

            ],
      ),
    )
    );

  }
  void logoutButton(){
    var url = "http://icba-env.nrvxnah2uj.us-east-1.elasticbeanstalk.com/api/logout";
    http.get(url)
        .then((response) {
        Navigator.push(context,new MaterialPageRoute(builder: (context) => InitialOpenedApp()));
    });}
}