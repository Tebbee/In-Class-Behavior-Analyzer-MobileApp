import 'package:icbaversion2/StudentSurveyForm.dart';
import 'StudentMainView.dart';
import 'AppConsts.dart';
import 'APIManager.dart';
import 'package:flutter/material.dart';

class StudentSurveySelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(backgroundColor: AppResources.buttonBackColor
      ),
      home: StudentSurveySelectionPage(title: 'Survey Selector'),
    );
  }
}

class StudentSurveySelectionPage extends StatefulWidget {
  StudentSurveySelectionPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  StudentSurveySelectionState createState() => StudentSurveySelectionState();
}

class StudentSurveySelectionState extends State<StudentSurveySelectionPage> {
  static final String MODULE_NAME = 'Survey_Selection_Form';
  int x = 2;
  var apiResponse;
  var idArray = [];
  var surveyArray = [];
  var dateGeneratedArray = [];
  List <Widget> buttonCreator = [];
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
                new Container(
                  padding: EdgeInsets.all(10),
                  child: Text("Here are all of your open Surveys:",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppResources.labelTextColor,
                  ),)
                ),
                new Column(
                  children:buttonCreator),
                new Container(
                    padding: EdgeInsets.all(20.0),
                    child: RaisedButton(onPressed:(){
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
    APIManager.allOpenSurveyRequest().then((response) {
      int length = response.body.split("{").length;
      apiResponse = response;
      print(response.body);
      while(x < length) {
        if (response.body.split("{").length > 2) {
          setState(() {
            idArray.add(response.body.split("{")[x].split(":")[1].split(",")[0].replaceAll(" ", ""));
            surveyArray.add(response.body.split("{")[x].split(":")[2].split(",")[0].replaceAll(" ", ""));
            dateGeneratedArray.add(response.body.split("{")[x].split(":")[3].substring(2, 12));
            buildButton(response.body.split("{")[x].split(":")[3].substring(2, 12) + "   -   " + response.body.split("{")[x].split(":")[2].split(",")[0].replaceAll(" ", ""),int.parse(response.body.split("{")[x].split(":")[1].split(",")[0].replaceAll(" ", "")));
            });

          x++;
        }
      }
    });
  }

  buildButton(className, classID){
    buttonCreator.add(new Container(
        padding: EdgeInsets.all(10.0),
        child: RaisedButton(
        onPressed: () =>studentClassSurvey(classID),
        child: new Text(className, style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0),),
        color: AppResources.buttonBackColor,
        )
    ));
  }
  
  studentClassSurvey(int id){
    APIManager.CLASS_ID = id.toString();
    setState(() {
      isReady = false;
    });
    Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentSurveyForm()));
  }

}
