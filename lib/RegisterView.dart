import 'package:behavior_analyzer/LoginView.dart';
import 'package:behavior_analyzer/FeedbackView.dart';
import 'package:behavior_analyzer/SubmissionView.dart';
import 'package:flutter/material.dart';

void main() => runApp(RegisterView());
class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: RegisterPage(title: 'Register Page'),
    );
  }
}



class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  List<String> studentUsernameList = ["student"];
  List<String> instructorUsernameList = ["teacher"];
  List<String> emailList = ["student@bsu"];

  String usernameTextBox = "";
  String passwordTextBox = "";
  String testString = "";
  String emailTextBox = "";
  int counter;

  void registerButton(){
    setState(() {
      if (usernameTextBox.isEmpty) {
        testString = "Username cannot be blank";
        return;
      }
      if (passwordTextBox.isEmpty) {
        testString = "Password cannot be blank";
        return;
      }
      for (counter = 0; counter < studentUsernameList.length; counter++) {
        if (usernameTextBox.toLowerCase() ==
            studentUsernameList[counter].toLowerCase()) {
          return;
        }
      }
      for (counter = 0; counter < instructorUsernameList.length; counter++) {
        if (usernameTextBox.toLowerCase() ==
            instructorUsernameList[counter].toLowerCase()) {
          return;
        }
      }
    }
    );}

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
                new Text(testString,
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),



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
                        onPressed: registerButton,
                        child: new Text("Register", style: new TextStyle(color: Colors.red,fontStyle: FontStyle.italic,fontSize: 15.0)),
                        color: Colors.white,
                        elevation: 0,

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
                new TextField(
                  decoration: new InputDecoration(
                      hintText: "Username"),
                  textAlign: TextAlign.center,
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
                  onSubmitted: (String passwordSubmission){
                    setState((){
                      passwordTextBox = passwordSubmission;
                    });},
                ),
                new TextField(
                  decoration: new InputDecoration(
                      hintText: "Email"),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onSubmitted: (String emailSubmission){
                    setState((){
                      emailTextBox = emailSubmission;
                    });},
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.all(5.0),
                      child: new RaisedButton(
                        onPressed: (){Navigator.push(context,new MaterialPageRoute(builder: (context) => SubmissionView()));},
                        child: new Text("Register", style: new TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 15.0)),
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