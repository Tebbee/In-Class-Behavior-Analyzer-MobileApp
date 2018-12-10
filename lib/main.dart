import 'package:behavior_analyzer/InstructorMainView.dart';
import 'package:behavior_analyzer/StudentMainView.dart';
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
      home: MyHomePage(title: 'Survey Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(

        children: [
        Card(child:
        Image.asset('assets/BennyJPEG.jpg'),
          margin: EdgeInsets.all(20.0),
        ),
        Container(
          margin: EdgeInsets.all(10.0),
          width: 350,
            child: Form(child: TextField()),),
        Container(
          margin: EdgeInsets.all(10.0),
          width: 250,
          child: Form(child: TextField()),),
//
        RaisedButton(onPressed: (){
          Navigator.push(context,new MaterialPageRoute(builder: (context) => StudentMainView()));},
          child: Text('Student'),),

      RaisedButton(onPressed: (){
          Navigator.push(context,new MaterialPageRoute(builder: (context) => InstructorMainView()));},
          child:Text("Instructor"),),
        ],),

    );}
}





