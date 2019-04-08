import 'package:icbaversion2/StudentSurveySelection.dart';

import 'StudentMainView.dart';
import 'AppConsts.dart';
import 'APIManager.dart';
import 'package:flutter/material.dart';

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
                  )
              ),

              Container(
                  padding: EdgeInsets.all(10.0),
                  child:
                  RaisedButton(onPressed:(){
                    Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));},
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
      print(response.body);
      if (response.body.contains("success")){
      if (response.body.split("{").length>2) {
        int counter = 0;
        for(var section in response.body.split("{")){
          if(counter >=3){
      if(section.split(",")[2].replaceAll('"', "").substring(1).contains("SA")){
        setState(() {
          shortAnswerPrompts.add(section.split(",")[3].replaceAll('"', "").substring(9).replaceAll("}", "").replaceAll("]", "").toString());
          buildShortAnswer(section.split(",")[3].replaceAll('"', "").substring(9).replaceAll("}", "").replaceAll("]", "").toString());
        });
      }
      if(section.split(",")[2].replaceAll('"', "").substring(1).contains("LA")){
        setState(() {
          longAnswerPrompts.add(section.split(",")[3].replaceAll('"', "").substring(9).replaceAll("}", "").replaceAll("]", "").toString());
          buildLongAnswer(section.split(",")[3].replaceAll('"', "").substring(9).replaceAll("}", "").replaceAll("]", "").toString());
        });
      }
      if(section.split(",")[2].replaceAll('"', "").substring(1).contains("RA")){
          rangePrompts.add(section.split(",")[3].replaceAll('"', "").substring(9).replaceAll("}", "").replaceAll("]", "").toString());
          buildRange(section.split(",")[3].replaceAll('"', "").substring(9).replaceAll("}", "").replaceAll("]", "").toString());
          }
        }
      counter++;
          }
        }
      }
      if(response.body.contains("error")){
        AppResources.showErrorDialog(MODULE_NAME, "ERROR, \nSomething is wrong with the Post request", context);
      }
    });
  }

  buildRange(className){

    rangeCreator.add(
        new Container(
        padding: EdgeInsets.all(10.0),
        child: new Slider(
          min: 0.0,
          max: 10.0,
          divisions: 10,
          activeColor: AppResources.buttonBackColor,
          label: className,
          onChanged: (double value){
            setState(() {
              sliderValue = value;
              print(sliderValue);
            });
          },
          value: sliderValue,
        ),
      )
    );}
  buildLongAnswer(className){
    longAnswerCreator.add(new Container(
        padding: EdgeInsets.all(20.0),
        child: new TextField(
          decoration: new InputDecoration(
            labelStyle: AppResources.labelStyle,
            hintText: className,
          ),
          controller: shortAnswerController,
        ),
    )
    );}
  buildShortAnswer(className){
    shortAnswerCreator.add(new Container(
        padding: EdgeInsets.all(20.0),
        child: new TextField(

            decoration: new InputDecoration(
              labelStyle: AppResources.labelStyle,
              hintText: className,
            ),
          controller: longAnswerController,
        ),
    )
    );}

  submitSurvey(){

  }

}

