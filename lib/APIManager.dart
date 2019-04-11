import 'package:http/http.dart' as http;
import 'dart:convert';

  ///Description: API manager is the primary connection between the Server and the mobile application.
  ///Any and all calls to and from the server are located within this file.
  ///
  ///Primary Uses:
  ///   - Login Requests
  ///   - Register Requests
  ///   - Demographics Requests and submissions
  ///   - Survey Requests and submissions
  ///   - Checking if all IDs (Class, session, user) are all legitimate
  ///
  ///Primary objects:
  ///   - SESSION_ID: Checks if a user is logged in
  ///   - CLASS_ID: Checks the class a student is registered for, and pulls questions from is when requested
  ///   - BASE_URL: The IP address and port to the server that is running the backend of the application
  ///       format: "http://IP_ADDRESS:PORT_NUMBER/api/"
  ///
  ///
  /// Primary Author: Ben Lawson
  /// Secondary Author: Cody Tebbe
  ///
  /// Date last updated: 4/1/2019
class APIManager {
  static final String LOG_NAME = "API_Manager";
  static String SESSION_ID = "";
  static String CLASS_ID = "";
  static final String BASE_URL = "http://icba.us-east-2.elasticbeanstalk.com/api/";
  static bool openSurvey = false;

  ///Description: Tests if the user has a SESSION_ID, sending a true/false value to where it is called.
  ///Location of its use: LoginForm, RegistrationForm, SessionStartForm, ForgotPasswordForm,
  static bool isUserLoggedIn() {
    return SESSION_ID.isNotEmpty;}

  ///Description: ParseLoginResponse function sets the Session_ID located within the APIManager
  ///that is checked be the isUserLoggedIn function.
  ///
  ///Location of its use: LoginForm
  static void parseLoginResponse(http.Response res) {
    var jsonObj = json.decode(res.body);
    SESSION_ID = jsonObj['data']['session_id'].toString();
    print(SESSION_ID);
  }

  ///Description: Sends the login request to the server to create the SESSION_ID
  ///
  ///Parameters: Username, Password
  ///
  ///Location: LoginForm
  static Future<http.Response> login(String username, String password) async {
    print(LOG_NAME + ': Making login request...');

    return await http.post(
      BASE_URL + "auth/login",
      body: {'username': username, 'password': password},
    );
  }

  ///Description: Clears the SESSION_ID from its designated field and removes the user from access
  ///
  ///Location: StudentMainView Logout button
  static Future<http.Response> logout() async {
    print(LOG_NAME + ': Making logout request...');
    SESSION_ID = "";

    return await http.post(
      BASE_URL + "auth/logout?session_id="+SESSION_ID,
    );
  }

  ///Description:Sends a register request to the server
  ///
  ///Parameters: Username, Password, Email, First_name, Last_name
  ///
  ///Location: RegisterForm
  static Future<http.Response> register(String username, String password, String email, String firstName, String lastName) async {
    print(LOG_NAME + ': Making register request...');

    Map<String, dynamic> bodyValues = {'username': username, 'password': password, 'email': email, 'first_name':firstName, 'last_name': lastName};

    if (firstName != null) {
      bodyValues['first_name'] = firstName;
    }

    if (lastName != null) {
      bodyValues['last_name'] = lastName;
    }
    return await http.post(BASE_URL+'auth/register',
      body: bodyValues
    );
  }

  ///Description: Sends a request form to the server which will then send an email to the requested email
  ///
  ///Parameters: Username
  ///
  ///Location: ForgotPasswordForm
  static Future<http.Response> requestResetPassword(String username) async {
    print(LOG_NAME + ': Making request reset password request...');
    return await http.post(
      BASE_URL + 'request_password_reset/' + username,
    );
  }

  ///Description: Requests the resetCode that was sent to the email, and then requests a new password
  ///
  ///Parameters: resetCode, newPassword
  ///
  ///Location: ForgotPasswordPage
  static Future<http.Response> resetPassword(String resetCode, String newPassword) async {
    print(LOG_NAME + ': Making request reset password request...');

    return await http.post(
      BASE_URL + 'reset_password/' + resetCode,
      body: {'new_password': newPassword},
    );
  }

  ///Description: Checks if a demographic page was created for the user, if one was already created,
  ///a failure is returned, otherwise it creates a new page
  ///
  ///Parameters: Age, Gender, GradeYear, Ethnicity, Race, Major
  ///
  ///Location: DemographicForm
  static Future<http.Response> demographicCreate(int age, int gender, int gradeYear, int ethnicity, int race, String major) async {
    print(LOG_NAME + ': Making demographic create request...');
    return await http.post(
      BASE_URL + 'demographic/create?session_id='+SESSION_ID,
      body: {'age': age.toString(), 'gender': gender.toString(), 'grade_year': gradeYear.toString(), 'ethnicity': ethnicity.toString(), 'race': race.toString(), 'major': major},
    );
  }

  ///Description: Checks if a demographic page was created for the user, if one was already created,
  ///updates the existing form
  ///
  ///Parameters: Age, Gender, GradeYear, Ethnicity, Race, Major
  ///
  ///Location: DemographicForm
  static Future<http.Response> demographicUpdate(int age, int gender, int gradeYear, int ethnicity, int race, String major) async {
    print(LOG_NAME + ': Making demographic update request...');
    Map<String, dynamic> bodyValues = {};

    if (age != null) {
      bodyValues['age'] = age.toString();
    }

    if (gender != null) {
      bodyValues['gender'] = gender.toString();
    }

    if (gradeYear != null) {
      bodyValues['grade_year'] = gradeYear.toString();
    }

    if (ethnicity != null) {
      bodyValues['ethnicity'] = ethnicity.toString();
    }

    if (race != null) {
      bodyValues['race'] = race.toString();
    }

    if (major != null) {
      bodyValues['major'] = major;
    }

    return await http.post(
      BASE_URL + 'demographic/update?session_id='+SESSION_ID,
      body: bodyValues,
    );
  }

  ///Description: Pulls the demographic information from the server, upon failure of finding an existing
  ///form, a demographic form is created instead
  ///
  /// Location: DemographicForm
  static Future<http.Response> demographicSelect() async {
    print(LOG_NAME + ': Making demographic select request...');

    return await http.get(
      BASE_URL + 'demographic/select?session_id='+SESSION_ID,
    );
  }

  ///Description: Sends the x and y value from the mobile app to the server upon change of location.
  ///
  ///Parameters: x, y
  ///
  ///Location: StudentMainView
  static Future<http.Response> locationSubmission(double x,double y) async {
    print(LOG_NAME + ': Making location get request...');
    return await http.get(
        BASE_URL + 'position/create?session_id='+SESSION_ID.toString()+"&x="+x.toString()+'&y='+y.toString()
    );
  }

  ///Description: Submits the data from the submission textbox to the server
  ///
  ///Parameters: textbox
  ///
  ///Location: FeedbackView
  static Future<http.Response> feedbackSubmission(String textBox) async{
    print(LOG_NAME + ': Making feedback submission...');
    Map<String, dynamic> bodyValues = {'feedback': textBox};
    return await http.post(BASE_URL + "feedback/submit",body: bodyValues);
  }

  ///Description: Submits the survey information submitted by the user
  ///
  ///Location: StudentSurveyForm
  static Future<http.Response> surveySubmission(Map responses) async{
    print(LOG_NAME + ': Making survey submission...');
    return await http.post(BASE_URL+"survey/respond?session_id="+SESSION_ID,
      body: responses);
  }

  ///Description: Requests survey information from the server and populates the StudentSurveyForm from
  ///the results
  ///
  ///Location: StudentSurveyForm
  static Future<http.Response> surveyRequest() async{
    print(LOG_NAME + ': Making survey request...');
    return await http.post(BASE_URL+ "survey/get?session_id="+SESSION_ID,
        body: {'survey_id' : CLASS_ID});
  }

  ///Description: Scans the server for all classes a user is signed up for,
  ///If a failure occurs and the user never had any classes, they are notified
  ///
  ///Location: SessionStartForm
  static Future<http.Response> classRequest() async{
    print(LOG_NAME + ': Making class search...');
    return await http.get(BASE_URL + "class/select/all?session_id="+SESSION_ID);
  }

  ///Description: Requests survey information from the server and populates the StudentSurveyForm from
  ///the results
  ///
  ///Location: StudentSurveyForm
  static Future<http.Response> allOpenSurveyRequest() async{
    print(LOG_NAME + ': Making open survey request...');
    return await http.post(BASE_URL+ "survey/open_surveys?session_id="+SESSION_ID);
  }


}

