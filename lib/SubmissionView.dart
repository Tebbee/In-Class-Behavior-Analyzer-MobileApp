import 'package:flutter/material.dart';



void main() => runApp(SubmissionView());
class SubmissionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SubmissionPage(title: 'Success!'),
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
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: new Container(
            margin: EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
            new Text("Your submission has successfully been accepted and is being processed",style: new TextStyle(fontSize: 20),
        ),
          new Container(
            margin: EdgeInsets.all(5.0),
            child: new RaisedButton(
              child: new Text("Home", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
              color: Colors.red,
            ),
          ),
              ]
            )
        )
    );
  }
}