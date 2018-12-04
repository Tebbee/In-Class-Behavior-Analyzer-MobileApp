import 'package:behavior_analyzer/StudentMainView.dart';
import 'package:flutter/material.dart';

void main() => runApp(StudentDemographicsView());

class StudentDemographicsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StudentDemographicsPage(title: 'Student Demographics Page'),
    );
  }
}

class StudentDemographicsPage extends StatefulWidget {
  StudentDemographicsPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  StudentDemographicsState createState() => StudentDemographicsState();
}

class StudentDemographicsState extends State<StudentDemographicsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                width: 350,
                child: Form(child: Text("Insert Question Here")),),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 350,
                child: Form(child: TextField()),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 350, child: Form(child: Text("Insert Question Here")),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 350,
                child: Form(child: TextField()),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 350, child: Form(child: Text("More need to be implemented")),
              ),
              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));
                print("Submitted");},
                child:Text("Submit"),
              ),
              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));},
                child:Text("Exit to main page"),),

            ]),
      ),
    );

  }
}

