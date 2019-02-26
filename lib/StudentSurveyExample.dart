import 'package:behavior_analyzer/StudentMainView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(StudentSurveyExample());

class StudentSurveyExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StudentSurveyPage(title: 'Student Survey Page'),
    );
  }
}
//
class StudentSurveyPage extends StatefulWidget {
  StudentSurveyPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  StudentSurveyState createState() => StudentSurveyState();
}

class StudentSurveyState extends State<StudentSurveyPage> {

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
              Text("Inserted Question Here"),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 350,
                child: Form(child: TextField()),
              ),
              Text("Inserted Question Here"),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 350,
                child: Form(child: TextField()),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 350, child: Form(child: Text("More need to be implemented")),
              ),

              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));
                print("Submitted");},
                child:Text("Submit"),
              ),
              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));},
                child:Text("Exit to main page"),),

            ]
        ),
      ),
    );

  }
}

