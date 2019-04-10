import 'package:icbaversion2/StudentSurveyForm.dart';
import 'StudentMainView.dart';
import 'AppConsts.dart';
import 'APIManager.dart';
import 'package:flutter/material.dart';
import 'StudentSurveySelection.dart';
import 'dart:convert';

class SurveyMainWidget extends StatefulWidget {
  SurveyMainWidget({Key key, this.title}) : super(key: key);

  final String title;
  @override
  SurveyMainState createState() => SurveyMainState();
}

class SurveyMainState extends State<SurveyMainWidget> {
  Widget currentView;

  @override
  void initState() {
    super.initState();
    currentView = StudentSurveySelectionPage(chosenCallback: this.chosenSurveyCallback,);
  }

  @override
  Widget build(BuildContext context) {
    return currentView;

  }

  chosenSurveyCallback(id) {
    setState(() {
      APIManager.CLASS_ID = id.toString();
      currentView = StudentSurveyPage(returnCallback: this.comeBackCallback, title: "Survey");
    });
  }

  comeBackCallback() {
    setState(() {
      APIManager.CLASS_ID = null;
      currentView = StudentSurveySelectionPage(chosenCallback: this.chosenSurveyCallback,);
    });
  }

}