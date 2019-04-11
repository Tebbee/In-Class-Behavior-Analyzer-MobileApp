import 'AppConsts.dart';
import 'APIManager.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';

class StudentSurveyPage extends StatefulWidget {
  StudentSurveyPage({Key key, this.title, this.returnCallback}) : super(key: key);

  final Function returnCallback;
  final String title;

  @override
  StudentSurveyState createState() => StudentSurveyState();
}

class StudentSurveyState extends State<StudentSurveyPage> {
  static final String MODULE_NAME = 'Survey_Form';
  Map<String, dynamic> formValues = Map();
  List <Widget> rangeCreator = [];
  List <Widget> shortAnswerCreator = [];
  List <Widget> longAnswerCreator = [];
  bool isReady = true;
  String className = "";
  String generatedDate = "";

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
    return SingleChildScrollView(
        child: Center(
        child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                  alignment: Alignment.topLeft,
                  child: new IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => widget.returnCallback()
                  )
              ),
              new Text(className,
                style: TextStyle(
                  fontSize: 24,
                  color: AppResources.labelTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Text(generatedDate,
                style: TextStyle(
                  fontSize: 14,
                  color: AppResources.labelTextColor,
                  fontStyle: FontStyle.italic
                ),
              ),
              new Column(
                  children:shortAnswerCreator,),
              new Column(
                  children:rangeCreator),
              new Column(
                  children:longAnswerCreator),

              Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(onPressed: submitSurvey,
                    child: new Text("Submit", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0),),
                    color: AppResources.buttonBackColor,
                  ),
              ),
            ]
        ),
      ),
    );
  }

  closePage() {

  }

  questionRetrieval(){
    APIManager.surveyRequest().then((response){
      var jsonObj = json.decode(response.body);
      print(jsonObj);

      if (jsonObj['status'] == "success") {
        className = jsonObj['data']['survey_instance']['class']['title'];
        generatedDate = jsonObj['data']['survey_instance']['date_generated'];
        formValues['survey_id'] = jsonObj['data']['survey_instance']['id'].toString();
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
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
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
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        child: new TextField(
          decoration: new InputDecoration(
            labelStyle: AppResources.labelStyle,
            labelText: className,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 3,
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
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
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
    print(APIManager.SESSION_ID);
    print(formValues);
    APIManager.surveySubmission(formValues).then((response) {
      var jsonObj = json.decode(response.body);
      if (jsonObj['status'] == "success") {
        // Navigate to another page
      } else {
        print(jsonObj);
      }
    });

  }

}

