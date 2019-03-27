import 'package:behavior_analyzer/StudentMainView.dart';
import 'package:behavior_analyzer/AppConsts.dart';
import 'package:behavior_analyzer/APIManager.dart';
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
//
class StudentSurveyPage extends StatefulWidget {
  StudentSurveyPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  StudentSurveyState createState() => StudentSurveyState();
}

class StudentSurveyState extends State<StudentSurveyPage> {
  static final String MODULE_NAME = 'Survey_Form';
  var shortAnswerPrompts = [];
  var longAnswerPrompts = [];
  var rangePrompts = [];
  var sliderValue;
  TextEditingController shortAnswerController = new TextEditingController();
  TextEditingController longAnswerController = new TextEditingController();

  @override
  initState() {
    super.initState();
    questionRetrieval();
  }

  @override
  Widget build(BuildContext context) {
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
        Container(
        padding: EdgeInsets.all(20.0),
            child:Text(
               "How was your experience today?"
              ),),Container(
            padding: EdgeInsets.all(20.0),
            child:
              new Slider(
                label: "0 = bad, 5 = great",
                activeColor: AppResources.buttonBackColor,
                value: 1,
                min: 0,
                max: 5,
                divisions: 5,
                onChanged: (newRating) {
                  setState(() => sliderValue = newRating);
                    },
              ),),
          Container(
            padding: EdgeInsets.all(20.0),
            child:
              TextField(
                decoration: new InputDecoration(
                    labelText: 'What is your favorite color?',
                    labelStyle: AppResources.labelStyle,
                ),
                controller: shortAnswerController,
              ),),
          Container(
              padding: EdgeInsets.all(20.0),
              child:
              TextField(
                decoration: new InputDecoration(
                    labelText: 'Why did you move around the room?',
                    labelStyle: AppResources.labelStyle
                ),
                controller: longAnswerController,
              ),),
              Container(
                padding: EdgeInsets.all(20.0),
                child:
              RaisedButton(onPressed: (){
                APIManager.surveySubmission();
                Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));},
                child: new Text("Submit", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0),),
                color: AppResources.buttonBackColor,
              )),
              Container(
                padding: EdgeInsets.all(20.0),
                child:
              RaisedButton(
                onPressed: questionRetrieval,
                child: new Text("Main Menu", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0),),
                color: AppResources.buttonBackColor,
                ))

            ]
        ),
      ),),
    );

  }

  questionRetrieval(){
    APIManager.surveyRequest().then((response){
      if (response.body.contains("success")){
      if (response.body.split("{").length>2) {
        int counter = 0;
        for(var section in response.body.split("{")){
          if(counter >=3){
            print(section.split(",")[2].replaceAll('"', "").substring(1));
      if(section.split(",")[2].replaceAll('"', "").substring(1).contains("SA")){
        print("I CONTAIN A SHORT ANSWER");
        setState(() {
          shortAnswerPrompts.add(section.split(",")[3].replaceAll('"', "").substring(9).replaceAll("}", "").replaceAll("]", "").toString());
        });
      }
      if(section.split(",")[2].replaceAll('"', "").substring(1).contains("LA")){
        print("I CONTAIN AN ESSAY");
        setState(() {
          longAnswerPrompts.add(section.split(",")[3].replaceAll('"', "").substring(9).replaceAll("}", "").replaceAll("]", "").toString());
        });
      }
      if(section.split(",")[2].replaceAll('"', "").substring(1).contains("RA")){
        print("I CONTAIN A RANGE");
          rangePrompts.add(section.split(",")[3].replaceAll('"', "").substring(9).replaceAll("}", "").replaceAll("]", "").toString());
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
    questionPlacement();
  }

  questionPlacement(){
    for(var value in shortAnswerPrompts){
      print(value+"\n");

    }
    for(var value in longAnswerPrompts){
      print(value+"\n");
    }
    for(var value in rangePrompts){
      print(value+"\n");
      new Text(value,style: TextStyle(color: AppResources.labelTextColor),);
      new Slider(
        activeColor: AppResources.buttonBackColor,
        min: 0,
        max: 5,
        divisions: 5,

        onChanged: (newRating) {
          setState(() => sliderValue = newRating);
        },
        value: sliderValue,
      );

    }




  }
}

