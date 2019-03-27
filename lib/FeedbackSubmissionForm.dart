import 'package:behavior_analyzer/StudentMainView.dart';
import 'package:flutter/material.dart';
import 'AppConsts.dart';

class FeedbackSubmissionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: FeedbackSubmissionPage(title: 'Success!'),
        ),
      ),
    );
  }
}

class FeedbackSubmissionPage extends StatefulWidget {
  FeedbackSubmissionPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  FeedbackSubmissionPageState createState() => FeedbackSubmissionPageState();
}

class FeedbackSubmissionPageState extends State<FeedbackSubmissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppResources.buttonBackColor,
      ),
      body: Center(
        child: Column(
            children: <Widget>[
              new Container(
                  margin: EdgeInsets.all(25.0),
                  child: new Text(
                    "Thank you for your input! it really means a lot!",
                    style: new TextStyle(color: AppResources.labelTextColor,fontStyle: FontStyle.italic, fontSize: 30.0),
                    textAlign: TextAlign.center,
                  )),
              new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed:mainMenuButton,
                    child: new Text("Main Menu", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: AppResources.buttonBackColor,)
              ),
            ]
        ),
      ),
    );
  }
  void mainMenuButton() {
    Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));
  }
}