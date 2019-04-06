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


  @override
  initState() {
    super.initState();
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
                new Container(
                    margin: EdgeInsets.all(5.0),
                    child: new RaisedButton(
                      onPressed: questionRetrieval,
                      child: new Text("Bluetooth", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0)),
                      color: Colors.blue,)
                ),
                new Container(
                    padding: EdgeInsets.all(20.0),
                    child:
                    RaisedButton(onPressed:(){
                      Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));},
                      child: new Text("Main Menu", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0),),
                      color: AppResources.buttonBackColor,
                    )),
              ]
          ),
        ),),
    );
  }

  questionRetrieval(){
    APIManager.allOpenSurveyRequest().then((response) {
      print(response.body);
    });
  }
/*
  createButton(buttonName){
    new Container(
        margin: EdgeInsets.all(5.0),
        child: new RaisedButton(
          onPressed: questionRetrieval,
          child: new Text(buttonName, style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0)),
          color: Colors.blue,)
    );
  }*/
}
