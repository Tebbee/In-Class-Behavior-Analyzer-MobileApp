import 'package:http/http.dart' as http;

class APIManager {
  static final String LOG_NAME = "API_Manager";
  static String SESSION_ID = "";
  static String CLASS_ID = "";
  static String SESSION_COOKIE = "";
  //static final String BASE_URL = "http://icba-env.nrvxnah2uj.us-east-1.elasticbeanstalk.com/api/";
  static final String BASE_URL = "http://192.168.0.70:8000/api/";
  //static final String BASE_URL = "http://10.2.224.19:8000/api/";
  static bool openSurvey = false;
  static bool isUserLoggedIn() {
    return SESSION_ID.isNotEmpty;
  }

  static void parseLoginResponse(http.Response res) {
    SESSION_ID=(res.body.split(" ")[4].replaceAll('"', '').replaceAll("}", ""));
    print(SESSION_ID);
  }

  static Future<http.Response> login(String username, String password) async {
    print(LOG_NAME + ': Making login request...');

    return await http.post(
      BASE_URL + "auth/login",
      body: {'username': username, 'password': password},
    );
  }

  static Future<http.Response> logout() async {
    print(LOG_NAME + ': Making logout request...');

    return await http.post(
      BASE_URL + "auth/logout?session_id="+SESSION_ID,
    );
  }

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

  static Future<http.Response> requestResetPassword(String username) async {
    print(LOG_NAME + ': Making request reset password request...');

    return await http.post(
      BASE_URL + 'request_password_reset/' + username,
    );
  }

  static Future<http.Response> resetPassword(String resetCode, String newPassword) async {
    print(LOG_NAME + ': Making request reset password request...');

    return await http.post(
      BASE_URL + 'reset_password/' + resetCode,
      body: {'new_password': newPassword},
    );
  }

  static Future<http.Response> demographicCreate(int age, int gender, int gradeYear, int ethnicity, int race, String major) async {
    print(LOG_NAME + ': Making demographic create request...');
    return await http.post(
      BASE_URL + 'demographic/create?session_id='+SESSION_ID,
      body: {'age': age.toString(), 'gender': gender.toString(), 'grade_year': gradeYear.toString(), 'ethnicity': ethnicity.toString(), 'race': race.toString(), 'major': major},
    );
  }

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

  static Future<http.Response> demographicSelect() async {
    print(LOG_NAME + ': Making demographic select request...');

    return await http.get(
      BASE_URL + 'demographic/select?session_id='+SESSION_ID,
    );
  }

  static Future<http.Response> demographicForm() async {
    print(LOG_NAME + ': Making demographic form request...');

    return await http.post(
      BASE_URL + 'demographic/form/create?'+SESSION_ID,
    );
  }

  static Future<http.Response> locationSubmission(double x,double y) async {
    print(LOG_NAME + ': Making location get request...');
    return await http.get(
        BASE_URL + 'position/create?session_id='+SESSION_ID.toString()+"&x="+x.toString()+'&y='+y.toString()
    );
  }

  static Future<http.Response> feedbackSubmission(String textBox) async{
    print(LOG_NAME + ': Making feedback submission...');
    Map<String, dynamic> bodyValues = {'feedback': textBox};
    return await http.post(BASE_URL + "feedback/submit",body: bodyValues);
  }

  static Future<http.Response> surveySubmission() async{
    print(LOG_NAME + ': Making survey submission...');
  }

  static Future<http.Response> surveyRequest() async{
    print(LOG_NAME + ': Making survey request...');

  }

  static Future<http.Response> classRequest() async{
    print(LOG_NAME + ': Making class search...');
    return await http.get(BASE_URL + "class/select/all?session_id="+SESSION_ID);
  }




}

