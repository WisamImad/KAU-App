// import 'dart:html';
// import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:kau_app/utils/connection.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestPermission();

      FirebaseMessaging.onMessage.listen((event) {
        print('reviced 2');
        NotificationService().showNotification(1, "title", "body", 10);
        // fetchRideInfo(getRideID(message), context);
        (Map<String, dynamic> message) async => (message);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('reviced3');
        // NotificationService().showNotification(1, "title", "body", 10);
        // fetchRideInfo(getRideID(message), context);
        (Map<String, dynamic> message) async => (message);
      });

      /*
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          // showOverlayNotification((context) {
          //   return Card(
          //     margin: const EdgeInsets.symmetric(horizontal: 4),
          //     child: SafeArea(
          //       child: ListTile(
          //         leading: SizedBox.fromSize(
          //             size: const Size(40, 40),
          //             child: ClipOval(
          //                 child: Container(
          //               color: Colors.black,
          //             ))),
          //         title: Text(message['notification']['title']),
          //         subtitle: Text(message['notification']['body']),
          //         trailing: IconButton(
          //             icon: Icon(Icons.close),
          //             onPressed: () {
          //               OverlaySupportEntry.of(context).dismiss();
          //             }),
          //       ),
          //     ),
          //   );
          // },
          //     duration: Duration(milliseconds: 4000)
          // );
          // _showItemDialog(message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          // _navigateToItemDetail(message);
        },
        onResume: (Map<String, dynamic> message) async {
          print('resume');
          print("onResume: $message");
          // _navigateToItemDetail(message);
        },
      );
*/
      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken() ?? "";
      // String token = await _firebaseMessaging.;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('NotificationToken', token);

      try {
        var request =
            MultipartRequest("POST", Uri.parse(Conn.setNotificationTokenURL));
        request.fields["push_notification_token"] = token;
        request.headers['Authorization'] = 'token ${Conn.token}';
        var response = await request.send();

        //Get the response from the server
        print('set token');
        if (response.statusCode == 200) {

        } else if (response.statusCode == 401) {
          Conn.logout();
        }
      } catch (e) {}

      print("FirebaseMessaging token: $token");
      print("server token: ${prefs.getString("token")}");
      // showOverlayNotification((context) {
      //   return Card(
      //     margin: const EdgeInsets.symmetric(horizontal: 4),
      //     child: SafeArea(
      //       child: ListTile(
      //         leading: SizedBox.fromSize(
      //             size: const Size(40, 40),
      //             child: ClipOval(
      //                 child: Container(
      //                   color: Colors.black,
      //                 ))),
      //         title: Text('token'),
      //         subtitle: SelectableText(token),
      //         trailing: IconButton(
      //             icon: Icon(Icons.close),
      //             onPressed: () {
      //               OverlaySupportEntry.of(context).dismiss();
      //             }),
      //       ),
      //     ),
      //   );
      // },
      //     duration: Duration(milliseconds: 14000)
      // );

      _initialized = true;
    }
  }
}
