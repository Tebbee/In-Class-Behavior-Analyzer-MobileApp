import 'package:behavior_analyzer/StudentMainView.dart';
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

class FeedbackPageState extends State<FeedbackPage> {
  TextEditingController inputController = new TextEditingController();

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
            children: <Widget>[
              new Container(
                  margin: EdgeInsets.all(10.0),
                  child: new Text(
                    "Your input is important to us. \n\n" +
                        "If there is anything we can do better, please list it below!",
                    style: new TextStyle(color: AppResources.labelTextColor,fontStyle: FontStyle.italic, fontSize: 20.0),
                    textAlign: TextAlign.center,
                  )),
              new Container(
                margin: EdgeInsets.all(10.0),
                child: TextField(
                  decoration: new InputDecoration(
                      labelStyle: AppResources.labelStyle,
                      hintText: "Input",
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
              ),new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed:logoutButton,
                    child: new Text("Main Menu", style: new TextStyle(color: AppResources.buttonTextColor,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: AppResources.buttonBackColor,)
              ),
            ]
        ),
      ),
    )
    );
  }

  void logoutButton(){
    Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));
  }

  void submit() {

  }
}