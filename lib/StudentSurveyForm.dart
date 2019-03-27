import 'package:behavior_analyzer/StudentMainView.dart';
import 'package:behavior_analyzer/AppConsts.dart';
import 'package:behavior_analyzer/APIManager.dart';
import 'package:flutter/material.dart';

void main() => runApp(StudentSurveyForm());

class StudentSurveyForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(backgroundColor: AppResources.buttonBackColor
      ),
      home: StudentSurveyPage(title: 'Survey'),
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
        backgroundColor: AppResources.buttonBackColor,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Inserted Question Here"),
              RaisedButton(onPressed: (){
                APIManager.surveySubmission();
                Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));},
                child: new Text("Submit", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0),),
                color: AppResources.buttonBackColor,
              ),
              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));},
                  child: new Text("Main Menu", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0),),
                  color: AppResources.buttonBackColor,),


            ]
        ),
      ),
    );

  }
}

