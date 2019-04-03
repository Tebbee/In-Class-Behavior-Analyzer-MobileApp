import 'DemographicSubmissionForm.dart';
import 'package:flutter/material.dart';
import 'APIManager.dart';
import 'AppConsts.dart';

class DemographicForm extends StatefulWidget {
  @override
  DemographicFormState createState() => DemographicFormState();
}

///Description: This class handles everything within the Demographic field besides the server calls.
///Within this section consists of the creation of the application view, the immediate appearance, and the
///values that are able to be utilized
///
///Primary Author: Cody Tebbe
///Secondary Author: Ben Lawson
///
///Primary Uses:
///   - Creation of Demographics
///   - Updating of Demographics
class DemographicFormState extends State<DemographicForm> {
  static const String MODULE_NAME = 'demographic_form';

  var genders = ["Male","Female", "Other", "Prefer not to say"];
  var gradeYears = ["Freshman","Sophomore","Junior","Senior","Super Senior","Graduate","Other","Prefer not to say"];
  var races = ["American Indian or Alaska Native","Asian","Black or African American","Native Hawaiian or Other Pacific Islander","White","Other","Prefer not to say"];
  var ethnicities = ["Hispanic or Latino","Not Hispanic or Latino","Other","Prefer not to say"];
  var currentGenderSelected;
  var currentGradeYearSelected;
  var currentRaceSelected;
  var currentEthnicitySelected;

  bool isReady = false;

  TextEditingController ageController = new TextEditingController();
  TextEditingController majorController = new TextEditingController();

  ///Description: Activates upon initialization of the page, in this instance, it requests any demographics
  ///that the user has pushed to the server. If there is demographics present, then it places the values in
  ///their appropriate positions.
  @override
  void initState() {
    super.initState();
    getDemographics();
  }

  ///Description: Building the Demographic form page of the apps users, this includes filling the values of
  ///the dropdown lists. More questions and buttons can be implemented using the Flutter guidelines online regarding
  ///their widgets.
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

  ///Description: This function checks the demographic fields to ensure that all the fields are filled.
  ///It will then use the APIManager.demographicUpdate from the APIManager to update/create the required action
  ///for the demographics.
  ///
  ///Primary Objects: Compares the selected value in the checkboxes to a number, these numbers correspond to
  ///those in the server.
  ///
  ///A 206 errors simply states that there was no demographics before, so it will use the APIManager.demographicCreate
  ///to create them.
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

    APIManager.demographicUpdate(int.parse(ageController.text),
        convertToNumber(genders, currentGenderSelected),
        convertToNumber(gradeYears, currentGradeYearSelected),
        convertToNumber(ethnicities, currentEthnicitySelected),
        convertToNumber(races, currentRaceSelected),
        majorController.text).then((response){
          setState(() {
            print(response.body);
            isReady = true;
          });
        if(response.body.contains("success")){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DemographicSubmissionForm()));
        }
        if(response.body.contains("206")){
          APIManager.demographicCreate(int.parse(ageController.text),
              convertToNumber(genders, currentGenderSelected),
              convertToNumber(gradeYears, currentGradeYearSelected),
              convertToNumber(ethnicities, currentEthnicitySelected),
              convertToNumber(races, currentRaceSelected),
              majorController.text);
          Navigator.push(context, MaterialPageRoute(builder: (context) => DemographicSubmissionForm()));
        }
    });
  }

  ///Description: This function simply converts the selected value in the demographics to a number which is sent to the server
  convertToNumber(list, selectedWord){
    int number = 1;
    for(var word in list){
      if(word == selectedWord){
        return number;
      }
      number++;
    }
  }

  ///Description: This function is utilized upon opening and checks for demographics within the server
  ///If no demographics are available, then default values are placed instead.
  getDemographics(){
    APIManager.demographicSelect().then((response){
      if(response.body.contains("error")){
        ageController.text=("");
        currentGenderSelected = genders[0];
        currentGradeYearSelected = gradeYears[0];
        currentEthnicitySelected = ethnicities[0];
        currentRaceSelected = races[0];
        majorController.text=("");
      }

      else{
        setState(() {
          ageController.text=(response.body.split(":")[5].split(",")[0]);
          currentGenderSelected = genders[int.parse(response.body.split(":")[6].split(",")[0])-1];
          currentGradeYearSelected = gradeYears[int.parse(response.body.split(":")[7].split(",")[0])-1];
          currentEthnicitySelected = ethnicities[int.parse(response.body.split(":")[8].split(",")[0])-1];
          currentRaceSelected = races[int.parse(response.body.split(":")[9].split(",")[0])-1];
          majorController.text=(response.body.split(":")[10].replaceAll("}", "").replaceAll('"',"").substring(1));
        });

      }
      print(response.body);
      setState(() {
        isReady = true;
      });

    });
  }
}