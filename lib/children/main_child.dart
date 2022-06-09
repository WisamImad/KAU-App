import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kau_app/children/avatar.dart';
import 'package:kau_app/children/main_discovery.dart';
import 'package:kau_app/children/main_bonus.dart';
import 'package:kau_app/children/main_message.dart';
import 'package:kau_app/children/main_paint.dart';
import 'package:kau_app/children/main_tasks.dart';
import 'package:kau_app/children/spain_wheel.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:video_player/video_player.dart';
import 'main_library.dart';

// import 'child_info.dart';

class ChildUserInfo {
  static Map? child;
}

class MainChild extends StatefulWidget {
  @override
  _MainChildState createState() => _MainChildState();
}

class _MainChildState extends State<MainChild> {
  Map? user;
  bool vidEnd = false;
  int taskNotifications = 0;

  Future<String?> loadData() async {
    if (ChildUserInfo.child != null) return "done";
    await TasksData.loadData();
    Map tasks = TasksData.tasks;
    print(
        "tasks*******************************************************************");
    print(tasks);
    taskNotifications = tasks["مهام صحية"]["count"] +
        tasks["مهام سلوكية"]["count"] +
        tasks["مهام منزلية"]["count"] +
        tasks["مهام اخرى"]["count"];
    try {
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      var userResponse =
          await get(Uri.parse(Conn.userInfoURL), headers: userHeader);
      var userMap = jsonDecode(utf8.decode(userResponse.bodyBytes));
      // print(userMap);
      if (userResponse.statusCode == 200) {
        print(userMap);
        ChildUserInfo.child = userMap['user'];

        setState(() {});
        return 'done';
      } else if (userResponse.statusCode == 401) {
        Conn.logout();
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
        return 'UnAuthorized';
      }
    } on SocketException {
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
    } catch (e) {
      print(e);
    }
    return null;
  }

  late VideoPlayerController _controller;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset("assets/children/logo.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(false);
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return FutureBuilder(
      future: loadData(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        Widget returnWidget;

        if (snapshot.data == 'done') {
          returnWidget = SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/children/main_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Avatar()),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Image.asset(
                            // "assets/children/child_avatar${ChildInfo.imageNumber}.png",
                            "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                            height: SizeConfig.safeBlockVertical! * 17,
                            width: SizeConfig.safeBlockHorizontal! * 10,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 15,
                      ),
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              cardWidget(
                                  chYellow,
                                  chBlue,
                                  "assets/children/tasks_icon.png",
                                  "مهامي", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainTasks()),
                                );
                              }, notification: "$taskNotifications"),
                              cardWidget(
                                  chOrange,
                                  chGreen,
                                  "assets/children/discover_icon.png",
                                  "المكتشف", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainDiscovery()),
                                );
                              }),
                              cardWidget(
                                  chGreen,
                                  chBink,
                                  "assets/children/wheel_icon.png",
                                  "العجلة", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SpainWheel()),
                                );
                              }),
                              cardWidget(
                                  chBink,
                                  chBlue,
                                  "assets/children/know_icon.png",
                                  "تعرف على", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPaint()),
                                );
                              }),
                              cardWidget(
                                chBlue,
                                chOrange,
                                "assets/children/message_icon.png",
                                "الرسائل",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainMessage()),
                                  );
                                },
                              ),
                              cardWidget(
                                  chYellow,
                                  chGreen,
                                  "assets/children/bouns_icon.png",
                                  "المكافئات", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainBonus()),
                                );
                              }),
                              cardWidget(
                                  chGreen,
                                  chColor_blue1,
                                  "assets/children/library_icon.png",
                                  "المكتبة", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainLibrary()),
                                );
                              }),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          returnWidget = Scaffold(
            body: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          );
        }
        return returnWidget;
      },
    );
  }

  Widget cardWidget(firstColor, secColor, image, title, onTap, {notification}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: <Widget>[
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: SizeConfig.safeBlockVertical! * 46,
              width: SizeConfig.safeBlockHorizontal! * 20.5,
              child: Card(
                color: firstColor,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset(
                      image,
                      fit: BoxFit.fill,
                      height: SizeConfig.safeBlockVertical! * 40,
                      width: SizeConfig.safeBlockHorizontal! * 18,
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(child: SizedBox()),
                        Container(
                          height: SizeConfig.safeBlockVertical! * 8,
                          width: SizeConfig.safeBlockHorizontal! * 12,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: secColor,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SizeConfig.safeBlockVertical! * 20))),
                          child: Text(
                            "${title}",
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical! * 3.5,
                                fontFamily: 'ge_ss',
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 4,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          notification?.isEmpty ?? true
              ? Container()
              : Positioned(
                  right: -SizeConfig.safeBlockHorizontal! * .5,
                  child: Container(
                    height: SizeConfig.safeBlockVertical! * 10,
                    width: SizeConfig.safeBlockHorizontal! * 7,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: chBink,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${notification}',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical! * 6,
                          fontFamily: 'ge_ss',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
