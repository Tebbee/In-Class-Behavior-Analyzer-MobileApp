import 'package:behavior_analyzer/InstructorMainView.dart';
import 'package:behavior_analyzer/StudentMainView.dart';
import 'package:behavior_analyzer/RegisterView.dart';
import 'package:behavior_analyzer/LoginView.dart';
import 'package:behavior_analyzer/FeedbackView.dart';
import 'package:behavior_analyzer/BluetoothView.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'In Classroom Behavior Analyzer'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<MyHomePage> {
    List<String> studentUsernameList = ["student"];
    List<String> studentPasswordList = ["student"];
    List<String> instructorUsernameList = ["teacher"];
    List<String> instructorPasswordList = ["teacher"];
    String usernameTextBox = "";
    String passwordTextBox = "";
    String testString = "";
    int counter;

    void loginButton(){
      setState(() {
      if (usernameTextBox.isEmpty){
        testString = "Username cannot be blank";
        return;
      }
      if (passwordTextBox.isEmpty){
        testString = "Password cannot be blank";
        return;
      }
      for (counter = 0; counter < studentUsernameList.length; counter++){
        if (usernameTextBox.toLowerCase() == studentUsernameList[counter].toLowerCase()){
          if(studentPasswordList[counter] == passwordTextBox){
            Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));
            return;
          }
        }
      }
      for (counter = 0; counter < instructorUsernameList.length; counter++){
        if (usernameTextBox.toLowerCase() == instructorUsernameList[counter].toLowerCase()){
          if(instructorPasswordList[counter] == passwordTextBox){
            Navigator.push(context,new MaterialPageRoute(builder: (context) => InstructorMainView()));
            return;
          }
        }
      }
    });
    }

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
        Card(child: Image.asset('assets/Benny2.jpg'),
        margin: EdgeInsets.all(10.0),
        elevation: 0,

        ),
        new Text("Ball State University",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0), textAlign: TextAlign.center,),
        new Text(testString,
        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),

       /* new TextField(
          decoration: new InputDecoration(
              hintText: "Username"),
              textAlign: TextAlign.center,
              key: loginButtonChange(),
              onSubmitted: (String usernameSubmission){
            setState((){
              usernameTextBox = usernameSubmission;
            });},
        ),

        new TextField(
          decoration: new InputDecoration(
              hintText: "Password"),
              obscureText: true,
              textAlign: TextAlign.center,
              key: loginButtonChange(),
              onSubmitted: (String passwordSubmission){
            setState((){
              passwordTextBox = passwordSubmission;
            });},

        ),*/

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
                margin: EdgeInsets.all(5.0),
                child: new RaisedButton(
                  onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => FeedbackView()));},
                  child: new Text("Feedback", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
                  color: Colors.red,
                ),
              ),
            ],
          ),

        new RaisedButton(onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => BluetoothView()));},
          child: new Text("Bluetooth", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 20.0)),
          color: Colors.red,
        ),
            ]
        )



    ,));

    }


}
