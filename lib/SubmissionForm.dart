import 'package:behavior_analyzer/main.dart';
import 'package:flutter/material.dart';
import 'AppConsts.dart';

class SubmissionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: SubmissionPage(title: 'Success!'),
        ),
      ),
    );
  }
}

class SubmissionPage extends StatefulWidget {
  SubmissionPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  SubmissionPageState createState() => SubmissionPageState();
}

class SubmissionPageState extends State<SubmissionPage> {
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
                "You have successfully created an account!",
                style: new TextStyle(color: AppResources.labelTextColor,fontStyle: FontStyle.italic, fontSize: 30.0),
                textAlign: TextAlign.center,
              )),
              new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed:logoutButton,
                    child: new Text("Login Menu", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: AppResources.buttonBackColor,)
              ),
            ]
        ),
      ),
    );

  }

  void logoutButton(){
    Navigator.push(context,new MaterialPageRoute(builder: (context) => MyApp()));
  }


}