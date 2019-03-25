import 'package:behavior_analyzer/DemographicSubmissionForm.dart';
import 'package:flutter/material.dart';
import 'APIManager.dart';
import 'APIModels.dart';
import 'AppConsts.dart';

class DemographicForm extends StatefulWidget {
  @override
  DemographicFormState createState() => DemographicFormState();
}

class DemographicFormState extends State<DemographicForm> {
  static const String MODULE_NAME = 'demographic_form';

  var genders = ["Male","Female", "Other", "Prefer not to say"];
  var gradeYears = ["Freshman","Sophomore","Junior","Senior","Super Senior","Graduate","Other","Prefer not to say"];
  var races = ["American Indian or Alaska Native","Asian","Black or African American","Native Hawaiian or Other Pacific Islander","White","Other","Prefer not to say"];
  var ethnicities = ["Hispanic or Latino","Not Hispanic or Latino","Other","Prefer not to say"];
  var currentGenderSelected = 'Male';
  var currentGradeYearSelected = "Freshman";
  var currentRaceSelected = "American Indian or Alaska Native";
  var currentEthnicitySelected = "Hispanic or Latino";

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
                      DropdownButton<String>(
                        value : currentGenderSelected,
                        items: genders.map((String dropDownStringItem){
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected){
                          setState((){
                            currentGenderSelected = newValueSelected;
                          });
                        },
                        iconSize: 50,
                      ),

                      SizedBox(height: 15.0,),

                      Text('Grade Year:', style: new TextStyle(color: AppResources.labelTextColor),),
                      DropdownButton<String>(
                        value : currentGradeYearSelected,
                        items: gradeYears.map((String dropDownStringItem){
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected){
                          setState((){
                            currentGradeYearSelected = newValueSelected;
                          });
                        },
                        iconSize: 50,
                      ),
                      SizedBox(height: 15.0,),

                      Text('Race:', style: new TextStyle(color: AppResources.labelTextColor),),
                      DropdownButton<String>(
                        value : currentRaceSelected,
                        items: races.map((String dropDownStringItem){
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        isExpanded: true,
                        onChanged: (String newValueSelected){
                          setState((){
                            currentRaceSelected = newValueSelected;
                          });
                        },
                        iconSize: 50,
                      ),

                      SizedBox(height: 15.0,),

                      Text('Ethnicity:', style: new TextStyle(color: AppResources.labelTextColor),),
                      DropdownButton<String>(
                        value : currentEthnicitySelected,
                        items: ethnicities.map((String dropDownStringItem){
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected){
                          setState((){
                            currentEthnicitySelected = newValueSelected;
                          });
                        },
                        iconSize: 50,
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
      AppResources.showErrorDialog(MODULE_NAME, 'You are not logged in!', context);
      return;
    }

    setState(() {
      isReady = false;
    });
    
    APIManager.demographicCreate(int.parse(ageController.text),
        convertToNumber(genders, currentGenderSelected),
        convertToNumber(gradeYears, currentGradeYearSelected),
        convertToNumber(races, currentRaceSelected),
        convertToNumber(ethnicities, currentEthnicitySelected),
        majorController.text).then((response) {
      setState(() {
        isReady = true;
      });
      if(response.body.contains("204")){
        APIManager.demographicUpdate(int.parse(ageController.text),
          convertToNumber(genders, currentGenderSelected),
          convertToNumber(gradeYears, currentGradeYearSelected),
          convertToNumber(races, currentRaceSelected),
          convertToNumber(ethnicities, currentEthnicitySelected),
          majorController.text);
        Navigator.push(context, MaterialPageRoute(builder: (context) => DemographicSubmissionForm()));

      }
    });
  }

  convertToNumber(list, selectedWord){
    int number = 1;
    for(var word in list){
      if (word != selectedWord){
        number++;
      }
      return number;
    }
    return number;
  }

}