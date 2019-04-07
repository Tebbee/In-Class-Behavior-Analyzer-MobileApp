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

  List <Widget> v = [];
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
                new Column(
                  children:v),
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
            buildButton(response.body.split("{")[x].split(":")[3].substring(2, 12),studentClassSurvey);
            });
          x++;
        }
      }
    });
  }

  buildButton(name,function){
    v.add(new Container(
        padding: EdgeInsets.all(20.0),
        child: RaisedButton(
        onPressed: function,
        child: new Text(name, style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0),),
        color: AppResources.buttonBackColor,
        )
    ));
  }
  studentClassSurvey(){
    print(apiResponse.body);
  }
}
