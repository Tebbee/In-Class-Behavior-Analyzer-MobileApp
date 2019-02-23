import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'APIManager.dart';
import 'APIModels.dart';
import 'AppConsts.dart';

class DemographicForm extends StatefulWidget {
  @override
  DemographicFormState createState() => DemographicFormState();
}

class DemographicFormState extends State<DemographicForm> {
  static const String MODULE_NAME = 'demographic_form';

  List<GenderLookup> genders = new List<GenderLookup>();
  List<GradeYearLookup> gradeYears = new List<GradeYearLookup>();
  List<RaceLookup> races = new List<RaceLookup>();
  List<EthnicityLookup> ethnicities = new List<EthnicityLookup>();

  GenderLookup selectedGender;
  GradeYearLookup selectedGradeYear;
  RaceLookup selectedRace;
  EthnicityLookup selectedEthnicity;

  bool isReady = false;

  TextEditingController ageController = new TextEditingController();
  TextEditingController majorController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    APIManager.demographicForm().then((response) {
      populateFormChoices(response);
      setState(() {
        isReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Center(
        child: new CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                  padding: new EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Student Demographics",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppResources.labelTextColor, fontSize: 30.0),
                      ),

                      TextField(
                        decoration: new InputDecoration(
                            labelText: 'Age:',
                            labelStyle: AppResources.labelStyle
                        ),
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: ageController,
                      ),

                      SizedBox(height: 15.0,),

                      Text('Gender:', style: new TextStyle(color: AppResources.labelTextColor),),
                      DropdownButton<GenderLookup>(
                        isExpanded: true,
                        items: genders.map((GenderLookup g) {
                          return new DropdownMenuItem(child: new Text(g.name), value: g);
                        }).toList(),
                        value: selectedGender,
                        onChanged: (val){
                          setState(() {
                            selectedGender = val;
                          });
                        },
                      ),

                      SizedBox(height: 15.0,),

                      Text('Grade Year:', style: new TextStyle(color: AppResources.labelTextColor),),
                      DropdownButton<GradeYearLookup>(
                        isExpanded: true,
                        items: gradeYears.map((GradeYearLookup g) {
                          return new DropdownMenuItem(child: new Text(g.name), value: g);
                        }).toList(),
                        value: selectedGradeYear,
                        onChanged: (val){
                          setState(() {
                            selectedGradeYear = val;
                          });
                        },
                      ),

                      SizedBox(height: 15.0,),

                      Text('Race:', style: new TextStyle(color: AppResources.labelTextColor),),
                      DropdownButton<RaceLookup>(
                        isExpanded: true,
                        items: races.map((RaceLookup g) {
                          return new DropdownMenuItem(child: new Text(g.name), value: g);
                        }).toList(),
                        value: selectedRace,
                        onChanged: (val){
                          setState(() {
                            selectedRace = val;
                          });
                        },
                      ),

                      SizedBox(height: 15.0,),

                      Text('Ethnicity:', style: new TextStyle(color: AppResources.labelTextColor),),
                      DropdownButton<EthnicityLookup>(
                        isExpanded: true,
                        items: ethnicities.map((EthnicityLookup g) {
                          return new DropdownMenuItem(child: new Text(g.name), value: g);
                        }).toList(),
                        value: selectedEthnicity,
                        onChanged: (val){
                          setState(() {
                            selectedEthnicity = val;
                          });
                        },
                      ),

                      SizedBox(height:15.0,),

                      TextField(
                        decoration: new InputDecoration(
                            labelText: 'Major:',
                            labelStyle: AppResources.labelStyle
                        ),
                        controller: majorController,
                      ),

                      SizedBox(height:15.0,),
                      Center(child: RaisedButton(
                        onPressed: submitData,
                        color: AppResources.buttonBackColor,
                        textColor: AppResources.buttonTextColor,
                        child: Text("Submit"),
                      )
                      )
                    ]
                )
              )
            ],
          )
        )
      )
    );
  }

  void populateFormChoices(http.Response response) {
    Map<String, dynamic> formValues = json.decode(response.body);

    for (Map<String, dynamic> gender in formValues['genders']) {
      genders.add(new GenderLookup(gender['id'], gender['name']));
    }
    selectedGender = genders.first;

    for (Map<String, dynamic> gradeYear in formValues['grade_years']) {
      gradeYears.add(new GradeYearLookup(gradeYear['id'], gradeYear['name']));
    }
    selectedGradeYear = gradeYears.first;

    for (Map<String, dynamic> race in formValues['races']) {
      races.add(new RaceLookup(race['id'], race['name']));
    }
    selectedRace = races.first;

    for (Map<String, dynamic> ethnicity in formValues['ethnicities']) {
      ethnicities.add(new EthnicityLookup(ethnicity['id'], ethnicity['name']));
    }
    selectedEthnicity = ethnicities.first;
  }

  void submitData() {
    if (ageController.text.isEmpty) {
      AppResources.showErrorDialog(MODULE_NAME, 'No age inputted!', context);
      return;
    }

    if (majorController.text.isEmpty) {
      AppResources.showErrorDialog(MODULE_NAME, 'No major inputted', context);
      return;
    }

    if (!APIManager.isUserLoggedIn()) {
      //AppResources.showErrorDialog(MODULE_NAME, 'You are not logged in!', context);
      //return;
    }

    setState(() {
      isReady = false;
    });

    APIManager.demographicCreate(int.parse(ageController.text), selectedGender, selectedGradeYear, selectedEthnicity, selectedRace, majorController.text).then((response) {
      setState(() {
        isReady = true;
      });
      print(response.body);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });


  }

}