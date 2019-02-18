import 'package:behavior_analyzer/StudentDemographicsPage.dart';
import 'package:behavior_analyzer/StudentSurveyExample.dart';
import 'package:behavior_analyzer/InitialOpenedApp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(StudentMainView());
class StudentMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StudentPage(title: 'Student Home Page'),
    );
  }
}

//

class StudentPage extends StatefulWidget {
  StudentPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  StudentPageState createState() => StudentPageState();
}

class StudentPageState extends State<StudentPage> {
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
              Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentSurveyView()));},
            child:Text("Survey Questions"),),
            RaisedButton(onPressed: (){
              Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentDemographicsView()));},
            child:Text("Demographic Information"),),
            new Container(
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed:logoutButton,
                  child: new Text("Logout", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                  color: Colors.red,)
            )
            ]
              ),
      ),
        );

  }
  void logoutButton(){
    var url = "http://192.168.0.235:8000/api/logut/";
    http.get(url)
        .then((response) {
      Navigator.push(context,new MaterialPageRoute(builder: (context) => InitialOpenedApp()));},);
    }
}