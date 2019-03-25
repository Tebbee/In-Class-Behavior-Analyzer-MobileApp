import 'package:behavior_analyzer/StudentMainView.dart';
import 'package:flutter/material.dart';
import 'AppConsts.dart';

class DemographicSubmissionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: DemographicSubmissionPage(title: ''),
        ),
      ),
    );
  }
}

class DemographicSubmissionPage extends StatefulWidget {
  DemographicSubmissionPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  DemographicSubmissionPageState createState() => DemographicSubmissionPageState();
}

class DemographicSubmissionPageState extends State<DemographicSubmissionPage> {
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
                    "Your demographic information has been updated.",
                    style: new TextStyle(color: AppResources.labelTextColor,fontStyle: FontStyle.italic, fontSize: 30.0),
                    textAlign: TextAlign.center,
                  )),
              new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed:logoutButton,
                    child: new Text("Main Menu", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: AppResources.buttonBackColor,)
              ),
            ]
        ),
      ),
    );
  }

  void logoutButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentMainView()));
  }

}