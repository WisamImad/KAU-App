import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_data.dart';
import 'app_theme.dart';

class Conn {
  static String? token;
  static String url = 'www.sononkau.xyz';
  static String serverURL = "https://www.sononkau.xyz";
  // static String url = '192.168.1.38:8000';
  // static String serverURL = "http://192.168.1.38:8000";
  // static String url = '10.0.2.2:8000';
  // static String serverURL = "http://10.0.2.2:8000";
  static String loginULR = serverURL + "/app/api/login";
  static String signUpURL = serverURL + "/app/api/register";
  static String userInfoURL = serverURL + "/app/api/user_info";
  static String changPasswordURL = serverURL + "/app/api/changepassword";
  static String restorePasswordURL = serverURL + "/app/api/restore_password";
  static String messageURL = serverURL + "/app/api/message";
  static String blogURL = serverURL + "/app/api/blog";
  static String memberURL = serverURL + "/app/api/member";
  static String logoutMemberURL = serverURL + "/app/api/logout_member";
  static String tasksURL = serverURL + "/app/api/task";
  static String tasksChildURL = serverURL + "/app/api/task_child";
  static String rewardURL = serverURL + "/app/api/reward";
  static String notificationURL = serverURL + "/app/api/notifications";
  static String messagingURL = serverURL + "/app/api/messgaging";
  static String childActivityURL = serverURL + "/app/api/child_activity";
  static String childAvatarURL = serverURL + "/app/api/child_avatar";
  static String childRewordURL = serverURL + "/app/api/userreward";
  static String emailValidationURL = serverURL + "/app/api/request_email_validation";
  static String setNotificationTokenURL = serverURL + "/app/api/user_set_pus_notification_token";
  static String childVideosURL = serverURL + "/app/api/children_videos";

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
    prefs.remove('isAdmin');
    prefs.remove('token');
    Data.clearData();
    var portrait = [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
    SystemChrome.setPreferredOrientations(portrait);

  }

  static Future<String> showDialog(int statusCode, BuildContext context, String description) async {
    if (statusCode == 200) {
      Scaffold.of(context).hideCurrentSnackBar();
      print("hide");
      return 'done';
    } else if (statusCode == 401) {
      await AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.ERROR,
              animType: AnimType.SCALE,
              title: 'لا يمكن الوصول الى حسابك',
              desc: 'تم تسجيل الخروج',
              btnOkOnPress: () {},
              btnOkText: 'تم',
              btnOkColor: Colors.red)
          .show();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
          ModalRoute.withName('/'));
      return "logout";
    } else if (statusCode == 0) {
      Scaffold.of(context).hideCurrentSnackBar();
      print("hide");
      Scaffold.of(context).showSnackBar(new SnackBar(
        duration: Duration(),
        backgroundColor: myBlue,
        content: new Text('لا يوجد اتصال بالانترنت'),
      ));
      print("show");
      await AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.ERROR,
              animType: AnimType.SCALE,
              title: 'لا يوجد اتصال بالإنترنت',
              desc: 'تاكد من توصيل الجهاز باإنترنت',
              btnOkOnPress: () {},
              btnOkText: 'تم',
              btnOkColor: Colors.red)
          .show();

      return 'ConnectionError';
    } else {
      await AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.ERROR,
              animType: AnimType.SCALE,
              title: 'يوجد خطاء!',
              desc: description,
              btnOkOnPress: () {},
              btnOkText: 'تم',
              btnOkColor: Colors.red)
          .show();

      return 'UnknownError';
    }
  }
}
