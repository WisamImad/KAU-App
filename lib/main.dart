import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kau_app/common/signup.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:kau_app/admin/BasePageAdmin.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/children/main_paint.dart';
import 'package:kau_app/common/login.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FirbaseMessaging.dart';
import 'notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  PushNotificationsManager().init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogin = prefs.getBool('isLogin') ?? false;
  bool isAdmin = prefs.getBool('isAdmin') ?? false;
  Conn.token = prefs.getString('token') ?? "";
  var landscape = [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ];
  var portrait = [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
  if (isLogin) {
    SystemChrome.setPreferredOrientations(isAdmin ? portrait : landscape);
  } else {
    SystemChrome.setPreferredOrientations(portrait);
  }

  runApp(
    OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        routes: {
          '/': (context) => isLogin
              ? isAdmin
              ? BasePageAdmin()
              : MainChild()
              : WelcomePage(),
          '/login': (context) => LoginPage(),
          '/child': (context) => Directionality(
              textDirection: TextDirection.rtl, child: MainChild()),
          '/admin': (context) => Directionality(
              textDirection: TextDirection.rtl, child: BasePageAdmin()),
          '/sign_up': (context) => SignUpPage(),
          '/main_paint': (context) => MainPaint(),
        },
      ),
    ),
  );
}
