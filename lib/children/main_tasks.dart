import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kau_app/children/internal_tasks.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';

import 'main_child.dart';

class TasksData {
  static Map tasks = {
    "مهام صحية": {"count": 0, "tasks": []},
    "مهام سلوكية": {"count": 0, "tasks": []},
    "مهام منزلية": {"count": 0, "tasks": []},
    "مهام اخرى": {"count": 0, "tasks": []}
  };

  static Future<void> loadData() async {
    try {
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      var taskResponse = await get(Uri.parse(Conn.tasksChildURL), headers: userHeader);
      var taskMap = jsonDecode(utf8.decode(taskResponse.bodyBytes));
      if (taskResponse.statusCode == 200) tasks = taskMap;
    } catch (e) {
      print(e);
    }
  }
}

class MainTasks extends StatefulWidget {
  @override
  _MainTasksState createState() => _MainTasksState();
}

class _MainTasksState extends State<MainTasks> {
  function() async {
    setState(() {});
  }

  int? health;
  int? behavior;
  int? home;
  int? other;

  Future<String?> loadData() async {
    try {
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      var taskResponse = await get(Uri.parse(Conn.tasksChildURL), headers: userHeader);
      var taskMap = jsonDecode(utf8.decode(taskResponse.bodyBytes));
      if (taskResponse.statusCode == 200) {
        TasksData.tasks = taskMap;
        // print(TasksData.tasks);

        other = TasksData.tasks['مهام اخرى']['count'];
        home = TasksData.tasks['مهام منزلية']['count'];
        behavior = TasksData.tasks['مهام سلوكية']['count'];
        health = TasksData.tasks['مهام صحية']['count'];
        setState(() {});
        return 'done';
      } else if (taskResponse.statusCode == 401) {
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
      } else {
        return "UnknownError";
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
      return 'done';
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  void initState() {
    health = 0;
    behavior = 0;
    home = 0;
    other = 0;
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/children/tasks_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                      height: SizeConfig.safeBlockVertical! * 17,
                      width: SizeConfig.safeBlockHorizontal! * 10,
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 1,
                    ),
                    Expanded(
                        child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 10,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: <Widget>[
                            Image.asset(
                              "assets/children/title_pic.png",
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20, top: 5),
                              child: Text(
                                'مهام الإبن الرضي',
                                style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal! * 3,
                                    fontFamily: 'ge_ss',
                                    fontWeight: FontWeight.bold,
                                    color: chBlue),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: Image.asset(
                        "assets/children/home_icon.png",
                        height: SizeConfig.safeBlockVertical! * 10,
                        width: SizeConfig.safeBlockHorizontal! * 7,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    taskWidgets('مهام اخرى', "assets/children/other_task.png", '$other'),
                    taskWidgets('مهام منزلية', "assets/children/home_task.png", '$home'),
                    taskWidgets('مهام سلوكية', "assets/children/behavior_task.png", '$behavior'),
                    taskWidgets('مهام صحية', "assets/children/health_task.png", '$health'),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget taskWidgets(String title, String image, String notification) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topRight,
      children: <Widget>[
        InkWell(
          onTap: () async {
            // print(TasksData.tasks[title]);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InternalTasks(
                        type_task: title,
                      )),
            );
            await loadData();
            setState(() {});
          },
          child: Container(
            height: SizeConfig.safeBlockVertical! * 45,
            width: SizeConfig.safeBlockHorizontal! * 23,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      image,
                      fit: BoxFit.fill,
                      height: SizeConfig.safeBlockVertical! * 29,
                      width: SizeConfig.safeBlockHorizontal! * 17,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 2,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical! * 4,
                          fontFamily: 'ge_ss',
                          fontWeight: FontWeight.bold,
                          color: chBlue),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        notification != '0'
            ? Positioned(
                top: -SizeConfig.safeBlockVertical! * 2,
                right: -SizeConfig.safeBlockHorizontal! * .5,
                child: Container(
                  height: SizeConfig.safeBlockVertical! * 8,
                  width: SizeConfig.safeBlockHorizontal! * 6,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: chYellow,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    notification,
                    style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical! * 5,
                        fontFamily: 'ge_ss',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
