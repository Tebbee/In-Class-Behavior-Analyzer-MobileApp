import 'package:behavior_analyzer/InstructorMainView.dart';
import 'package:flutter/material.dart';

void main() => runApp(InstructorMapView());

class InstructorMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: InstructorMapPage(title: 'Instructor Map Page'),
    );
  }
}
//
class InstructorMapPage extends StatefulWidget {
  InstructorMapPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  InstructorMapState createState() => InstructorMapState();
}

class InstructorMapState extends State<InstructorMapPage> {
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
              RaisedButton(onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => InstructorMainView()));},
                child:Text("Exit to main page"),),

            ]),
      ),
    );

  }
}

