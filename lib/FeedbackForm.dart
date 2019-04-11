import 'StudentMainView.dart';
import 'APIManager.dart';
import 'FeedbackSubmissionForm.dart';
import 'package:flutter/material.dart';
import 'AppConsts.dart';

class FeedbackForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: FeedbackPage(title: 'Feedback'),
        ),
      ),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  FeedbackPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  FeedbackPageState createState() => FeedbackPageState();
}

///Description: The purpose of this class is to create a feedback form and submit the results in the text field
///back to the server.
///
///Primary Uses:
///   - Taking the values in the textbox and sending it to the server
///   - Showing the user when the submission was successful
///
///Primary Author: Cody Tebbe
///
class FeedbackPageState extends State<FeedbackPage> {
  TextEditingController inputController = new TextEditingController();

  ///This build function is the view of the application on the Feedback page. Any updates/changes
  ///should go through Flutter's documentation found online to ensure proper code is created.
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              new SizedBox(
                height: 20.0,
              ),
              new Text("Feedback",
                style: TextStyle(
                  fontSize: 30,
                  color: AppResources.labelTextColor,
                ),
              ),
              new Container(
                  margin: EdgeInsets.all(10.0),
                  child: new Text(
                    "Your input is important to us. \n\n" +
                        "If there is anything we can do better, please share it below!",
                    style: new TextStyle(color: AppResources.labelTextColor,fontStyle: FontStyle.italic, fontSize: 20.0),
                    textAlign: TextAlign.center,
                  )),
              new Container(
                margin: EdgeInsets.all(10.0),
                child: TextField(
                  decoration: new InputDecoration(
                      labelStyle: AppResources.labelStyle,
                      labelText: "Feedback...",
                  ),
                  controller: inputController,
                ),
              ),
              new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed:submit,
                    child: new Text("Submit", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: AppResources.buttonBackColor,)
              ),
            ]
        ),
      ),
    );
  }

  ///This function will send the user back to the StudentMainView
  void mainMenuButton(){
    Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));
  }

  ///This function will send the text box containing any information (even blank) and will send
  ///it to the server for further insight from the administration. Upon success, the user will then
  ///be send to the SubmissionForm, which will confirm their request.
  void submit() {
    APIManager.feedbackSubmission(inputController.text).then((response){
      print(response.body);
      if(response.body.contains("success")){
        Navigator.push(context,new MaterialPageRoute(builder: (context) => FeedbackSubmissionForm()));
      }
    });

  }

  void closePage() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => StudentMainView()));
  }
}