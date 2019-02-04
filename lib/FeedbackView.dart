import 'package:behavior_analyzer/LoginView.dart';
import 'package:behavior_analyzer/RegisterView.dart';
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
                    Card(child: Image.asset('assets/Benny2.jpg'),
                      margin: EdgeInsets.all(10.0),
                      elevation: 0,

                    ),
                    new Text("Ball State University",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0), textAlign: TextAlign.center,),

                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.all(5.0),
                          child: new RaisedButton(
                            onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => LoginView()));},
                            child: new Text("Login", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                            color: Colors.red,
                          ),
                        ),

                        new Container(
                          margin: EdgeInsets.all(5.0),
                          child: new RaisedButton(
                            onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => RegisterView()));},
                            child: new Text("Register", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                            color: Colors.red,
                          ),
                        ),

                        new Container(
                          margin: EdgeInsets.all(15.0),
                          child: new Text("Feedback", style: new TextStyle(color: Colors.red,fontStyle: FontStyle.italic,fontSize: 15.0),textAlign: TextAlign.center,),
                          color: Colors.white,
                        ),

                      ],
                    ),

                    new Text("Welcome to the feedback page. \nAll input is 100% anonymous. \nPlease insert any comments/concerns you wish.",
                      style: new TextStyle(fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center,),
                    new TextField(
                      decoration: new InputDecoration(
                          hintText: "Feedback"),
                      textAlign: TextAlign.center,
                      onSubmitted: (String usernameSubmission){
                        setState((){
                         // usernameTextBox = usernameSubmission;
                        });},
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.all(5.0),
                          child: new RaisedButton(
                            onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => SubmissionView()));},
                            child: new Text("Submit", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    )
                  ]
              ),
            )
        )
    );
  }
}
