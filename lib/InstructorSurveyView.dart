import 'package:behavior_analyzer/InstructorMainView.dart';
import 'package:flutter/material.dart';

void main() => runApp(InstructorSurveyView());

class InstructorSurveyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: InstructorSurveyPage(title: 'Instructor Survey Page'),
    );
  }
}

class InstructorSurveyPage extends StatefulWidget {
  InstructorSurveyPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  InstructorSurveyState createState() => InstructorSurveyState();
}

class InstructorSurveyState extends State<InstructorSurveyPage> {
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
                print("Adding Question");},
                child:Text("New Question"),
              ),
              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => InstructorMainView()));
                print("Submitted");},
                child:Text("Submit"),
              ),
              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => InstructorMainView()));},
                child:Text("Exit to main page"),),

            ]),
      ),
    );

  }
}

