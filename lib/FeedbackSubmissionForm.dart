import 'StudentMainView.dart';
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

///Description: The contents within this class is simply a confirmation that the submission of the feedback
///was properly sent through. There are no calls to the APIManager or functions that require anything
///outside information.
///
///Primary Author: Cody Tebbe
class FeedbackSubmissionPageState extends State<FeedbackSubmissionPage> {
  ///This build function builds the view of the application. The two containers contain text and
  ///a button which sends them back to the Main Page.
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

  ///This function is connected to the Main Menu button from the build function.
  ///Its only purpose is to send the user back to the StudentMainView
  void mainMenuButton() {
    Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));
  }
}