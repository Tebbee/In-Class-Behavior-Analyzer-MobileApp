import 'package:icbaversion2/StudentSurveySelection.dart';

import 'StudentMainView.dart';
import 'AppConsts.dart';
import 'APIManager.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';

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

class StudentSurveyPage extends StatefulWidget {
  StudentSurveyPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  StudentSurveyState createState() => StudentSurveyState();
}

class StudentSurveyState extends State<StudentSurveyPage> {
  static final String MODULE_NAME = 'Survey_Form';
  Map<String, dynamic> formValues = Map();
  var shortAnswerPrompts = [];
  var shortAnswerAnswers = [];
  var longAnswerPrompts = [];
  var longAnswerAnswers = [];
  var rangePrompts = [];
  var rangeResults = [];
  var sliderValue = 5.0;

  TextEditingController shortAnswerController = new TextEditingController();
  TextEditingController longAnswerController = new TextEditingController();
  List <Widget> rangeCreator = [];
  List <Widget> shortAnswerCreator = [];
  List <Widget> longAnswerCreator = [];
  bool isReady = true;

  @override
  initState() {
    super.initState();
    questionRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppResources.buttonBackColor,
      ),
      body: SingleChildScrollView(
        child: Center(
        child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Column(
                  children:shortAnswerCreator,),
              new Column(
                  children:rangeCreator),
              new Column(
                  children:longAnswerCreator),

              Container(
                  padding: EdgeInsets.all(10.0),
                  child:
                  RaisedButton(onPressed:(){
                    Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentSurveySelection()));},
                    child: new Text("Back", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0),),
                    color: AppResources.buttonBackColor,
                  )
              ),

              Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(onPressed: submitSurvey,
                    child: new Text("Submit", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0),),
                    color: AppResources.buttonBackColor,
                  ),
              ),

              Container(
                  padding: EdgeInsets.all(10.0),
                  child:
                  RaisedButton(onPressed:(){
                      Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));
                    },
                    child: new Text("Main Menu", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0),),
                    color: AppResources.buttonBackColor,
                  )
              ),
            ]
        ),
      ),),
    );
  }

  questionRetrieval(){
    APIManager.surveyRequest().then((response){
      var jsonObj = json.decode(response.body);

      if (jsonObj['status'] == "success") {
        formValues['survey'] = jsonObj['data']['survey_instance']['id'].toString();
        for (var question in jsonObj['data']['questions']) {
          if (question['question']['type'] == 'SA') {
            setState(() {buildShortAnswer(question['question']['prompt'], question['id']);});
          } else if (question['question']['type'] == 'LA') {
            setState(() {buildLongAnswer(question['question']['prompt'], question['id']);});
          } else if (question['question']['type'] == 'RA') {
            setState(() {buildRange(question['question']['prompt'], question['id']);});
          }
        }

        for (int i = 0; i < jsonObj['data']['positions'].length; i++) {
          var xValue = jsonObj['data']['positions'][i]['position']['x'];
          var yValue = jsonObj['data']['positions'][i]['position']['y'];
          var instanceId = jsonObj['data']['positions'][i]['id'];

          if (i == 0) {
            setState(() {
              buildShortAnswer("Why did you sit at " + xValue.toString() + ", " + yValue.toString() + " at the beginning of class?", instanceId);
            });
          } else {
            setState(() {
              buildShortAnswer("Why did you move to " + xValue.toString() + ", " + yValue.toString() + "?", instanceId);
            });
          }
        }
      }

    });

  }

  buildRange(className, id){
    formValues[id.toString()] = 5.0.toString();

    rangeCreator.add(new Container(
      padding: EdgeInsets.all(20.0),
      child: new TextField(
        decoration: new InputDecoration(
          labelStyle: AppResources.labelStyle,
          labelText: className,
        ),
        keyboardType: TextInputType.number,
        onChanged: (newValue) {
          formValues[id.toString()] = newValue.toString();
        },
      ),
    )
    );
  }
  buildLongAnswer(className, id){
    formValues[id.toString()] = "";

    longAnswerCreator.add(new Container(
        padding: EdgeInsets.all(20.0),
        child: new TextField(
          decoration: new InputDecoration(
            labelStyle: AppResources.labelStyle,
            labelText: className,
          ),
          onChanged: (newValue) {
            formValues[id.toString()] = newValue;
          },
        ),
    )
    );
  }
  buildShortAnswer(className, id){
    formValues[id.toString()] = "";

    shortAnswerCreator.add(new Container(
        padding: EdgeInsets.all(20.0),
        child: new TextField(

            decoration: new InputDecoration(
              labelStyle: AppResources.labelStyle,
              labelText: className,
            ),
          onChanged: (newValue) {
              formValues[id.toString()] = newValue;
          },
        ),
    )
    );}

  submitSurvey(){
    APIManager.surveySubmission(formValues).then((response) {
      var jsonObj = json.decode(response.body);
      if (jsonObj['status'] == "success") {
        // Navigate to another page
      }
    });

  }

}

