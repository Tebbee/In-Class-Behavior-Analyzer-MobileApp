import 'package:behavior_analyzer/InitialOpenedApp.dart';
import 'package:behavior_analyzer/SubmissionView.dart';
import 'package:flutter/material.dart';

void main() => runApp(FeedbackView());
class FeedbackView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: FeedbackPage(title: 'Feedback Page'),
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
  @override
  Widget build(BuildContext context) {
    String testString;
    List<String> FeedbackList = [""];

    submitButton(){

    }

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:
        SingleChildScrollView(
        child: new Container(
          margin: EdgeInsets.all(10.0),
          child: new Column(


              children: <Widget>[

                new Text("Welcome to the feedback page. Here, all of your opinions can be heard and possible fixes can be scrutinized.\n"
                    "All submissions are 100% anonymous as well.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0), textAlign: TextAlign.center, softWrap: true,),

                new TextField(
                  decoration: new InputDecoration(
                      hintText: "Feedback"),
                  textAlign: TextAlign.center,
                  onSubmitted: (String usernameSubmission){
                    setState((){
                      testString = usernameSubmission;
                    });},
                ),


                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => SubmissionView()));},
                    child: new Text("Submit", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: Colors.red,
                    elevation: 0,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.all(5.0),
                  child: new RaisedButton(
                    onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => MyApp()));},
                    child: new Text("Back", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                    color: Colors.red,
                  ),
                ),
              ]
          ),
        )
        )
    );

  }


}