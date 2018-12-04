import 'package:behavior_analyzer/InstructorMainView.dart';
import 'package:flutter/material.dart';

void main() => runApp(InstructorDemographicsView());

class InstructorDemographicsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: InstructorDemographicsPage(title: 'Instructor Demographics Page'),
    );
  }
}

class InstructorDemographicsPage extends StatefulWidget {
  InstructorDemographicsPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  InstructorDemographicsState createState() => InstructorDemographicsState();
}

class InstructorDemographicsState extends State<InstructorDemographicsPage> {
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
                print("Adding Question");},
                child:Text("New Question"),
              ),
              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => InstructorMainView()));
                print("Saved");},
                child:Text("Save"),
              ),
              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => InstructorMainView()));},
                child:Text("Exit to main page"),),

            ]),
      ),
    );

  }
}

