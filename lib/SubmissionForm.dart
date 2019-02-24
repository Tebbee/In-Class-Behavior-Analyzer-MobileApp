import 'package:flutter/material.dart';
import 'main.dart';
import 'AppConsts.dart';

class SubmissionForm extends StatefulWidget {
  final VoidCallback onComplete;

  const SubmissionForm({Key key, this.onComplete}): super(key:key);

  SubmissionState createState() => SubmissionState(onComplete);
}

class SubmissionState extends State<SubmissionForm> {
  VoidCallback onComplete;

  SubmissionState(VoidCallback complete) {
    onComplete = complete;
  }
  static final String MODULE_NAME = 'Submission_form';

  TextEditingController resetCodeController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isReady = true;

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
              "You have successfully created an account!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppResources.labelTextColor, fontSize: 30.0),
            ),

            SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: submissionView,
              color: AppResources.buttonBackColor,
              textColor: AppResources.buttonTextColor,
              child: Text("Main Menu"),
            )
          ],
        )
    );
  }


  void submissionView() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));});

  }

}