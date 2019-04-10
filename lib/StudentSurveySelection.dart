import 'package:icbaversion2/StudentSurveyForm.dart';
import 'StudentMainView.dart';
import 'AppConsts.dart';
import 'APIManager.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

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

    if (buttonCreator.length == 0) {
      return Scaffold (
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: AppResources.buttonBackColor,
        ),

        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  alignment: Alignment.topRight,
                  child: new IconButton(
                      icon: Icon(Icons.close),
                      onPressed: closePage
                  )
                ),
                new Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "No open surveys at this time!",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppResources.labelTextColor,
                    ),
                  )
                )
              ],
            )
          ),
        ),
      );
    } else {
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
                    alignment: Alignment.topRight,
                    child: new IconButton(
                        icon: Icon(Icons.close),
                        onPressed: closePage
                    )
                ),
                new Container(
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      shrinkWrap: true,
                      children: buttonCreator,

                    ),
                ),
              ]
            ),
        ),
      ));
    }

  }

  questionRetrieval(){
    setState(() {
      isReady = false;
    });
    APIManager.allOpenSurveyRequest().then((response) {
      var jsonObj = json.decode(response.body);
      apiResponse = response;
      for (var survey in jsonObj['data']) {
        buildSurveyItem(survey['class']['title'], survey['id'], survey['date_generated']);
      }
      setState(() {
        isReady = true;
      });
    });
  }
  buildSurveyItem(className, classId, dateGenerated) {
    buttonCreator.add(
        new ListTile(
          title: Text(className),
          subtitle: Text(dateGenerated),
          onTap: () => studentClassSurvey(classId),
        )
    );
    buttonCreator.add(new Divider(
        color: Colors.black,
      )
    );
  }

  buildButton(className, classID){
    buttonCreator.add(
      new ListTile(
        title: Text(className),
        onTap: () => studentClassSurvey(classID),
      )
    );
    buttonCreator.add(new Divider(
      color: AppResources.buttonBackColor
    ));
  }
  
  studentClassSurvey(int id){
    APIManager.CLASS_ID = id.toString();
    setState(() {
      isReady = false;
    });
    Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentSurveyForm()));
  }

  void closePage() {
    Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));
  }

}
