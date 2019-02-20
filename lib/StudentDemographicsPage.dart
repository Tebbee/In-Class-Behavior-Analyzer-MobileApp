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
  String ageTextBox = "";
  var genderDropDownList;
  var gradeYearDropDownList;
  var ethnicityDropDownList;
  var raceDropDownList;
  String majorTextBox = "";







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(0.0),
                width: 350,
                alignment: Alignment.center,
                child: Form(child: Text("Age")),),
              Container(
                margin: EdgeInsets.all(0.0),
                width: 50,
                alignment: Alignment.center,
                child: Form(child: TextField()),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 350,
                alignment: Alignment.center,
                child: Form(
                  child: Text("Gender:")),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                width: 200,
                alignment: Alignment.center,
                child: new DropdownButton<String>(
                  items: <String>['Male', 'Female', 'Other', 'Prefer not to say'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                )
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 350,
                alignment: Alignment.center,
                child: Form(
                    child: Text("Grade year:")),
              ),
              Container(
                  margin: EdgeInsets.all(5.0),
                  width: 200,
                  alignment: Alignment.center,
                  child: new DropdownButton<String>(
                    items: <String>['Freshman', 'Sophomore', 'Junior', 'Senior', 'Senior+', 'Graduate','Other','Prefer not to say'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  )
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 350,
                alignment: Alignment.center,
                child: Form(
                    child: Text("Ethnicity:")),
              ),
              Container(
                  margin: EdgeInsets.all(5.0),
                  width: 400,
                  alignment: Alignment.center,
                  child: new DropdownButton<String>(
                    items: <String>['Hispanic or Latino or Spanish Origin', 'Not Hispanic or Latino or Spanish Origin', 'Other', 'Prefer Not To Say'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  )
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 400,
                alignment: Alignment.center,
                child: Form(
                    child: Text("Race:")),
              ),
              Container(
                  margin: EdgeInsets.all(5.0),
                  width: 400,
                  alignment: Alignment.center,
                  child: new DropdownButton<String>(
                    items: <String>['American Indian or Alaska Native', 'Asian', 'Black or African-American', 'Native Hawaiian or Other Pacific Islander','White','Other','Prefer Not To Say'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  )
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                width: 400,
                alignment: Alignment.center,
                child: Form(
                    child: Text("Major:")),
              ),
              Container(
                margin: EdgeInsets.all(0.0),
                width: 300,
                alignment: Alignment.center,
                child: Form(
                    child: TextField()),
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
    )
    );
  }
}

