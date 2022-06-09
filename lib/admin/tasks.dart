import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_data.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/my_widget.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'addModifyTask.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TickerProviderStateMixin {
  Future<String> isLoadData() async {
    if (Data.dailyTasksList != null) {
      return 'done';
    } else
      return loadData();
  }

  Future<String> loadData() async {
    try {
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      final dailyParams = {
        "task_id": "all",
      };

      final uri = Uri.https(Conn.url, "/app/api/task");
      final dailyUri = uri.replace(queryParameters: dailyParams);
      var dailyTaskResponse = await get(dailyUri, headers: userHeader);
      var dailyTasksMap = jsonDecode(utf8.decode(dailyTaskResponse.bodyBytes));

      if (dailyTaskResponse.statusCode == 200) {
        if (dailyTasksMap.length == 0) {
          Data.dailyTasksList = null;
        } else {
          setState(() {
            Data.dailyTasksList = dailyTasksMap;
          });
        }

        return 'done';
      } else if (dailyTaskResponse.statusCode == 401) {
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
        return 'done';
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
    }
    return "ConnectionError";
  }

  late TabController _tabController;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await loadData();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isLoadData(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget body;
        if (snapshot.data == "done") {
          body = Scaffold(
            backgroundColor: myBackground,
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 30,
              ),
              backgroundColor: myBink,
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddModifyTask(
                          isEdit: false,
                          task: {},
                        )));
                refreshList();
              },
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: RefreshIndicator(
                        onRefresh: refreshList,
                        child: ListView(
                          children: Data.dailyTasksList != null
                              ? Data.dailyTasksList!.map((dailyTask) {
                                  List users = dailyTask['users'];
                                  List days = dailyTask['days'];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 7, 0, 7),
                                    child: MyCard(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Text(
                                                        '${dailyTask['name'] + ' - ${dailyTask['task_category']['name']}'}',
                                                        style: TextStyle(
                                                            color: myBlue,
                                                            fontFamily:
                                                                fontHiding2,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        IconButton(
                                                          onPressed: () async {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AddModifyTask(
                                                                              isEdit: true,
                                                                              task: dailyTask,
                                                                            )));
                                                          },
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () async {
                                                            bool? areYouSure;
                                                            await AwesomeDialog(
                                                              headerAnimationLoop:
                                                                  false,
                                                              context: context,
                                                              dialogType:
                                                                  DialogType
                                                                      .WARNING,
                                                              animType: AnimType
                                                                  .SCALE,
                                                              title:
                                                                  'هل انت متاكد',
                                                              desc:
                                                                  'هل ترغب بحذف المهمة؟',
                                                              btnOkOnPress: () {
                                                                setState(() {
                                                                  areYouSure =
                                                                      true;
                                                                });
                                                              },
                                                              btnOkText:
                                                                  'موافق',
                                                              btnOkColor:
                                                                  myBlue,
                                                              btnCancelOnPress:
                                                                  () {
                                                                setState(() {
                                                                  areYouSure =
                                                                      false;
                                                                });
                                                              },
                                                              btnCancelText:
                                                                  "الغاء",
                                                              btnCancelColor:
                                                                  Colors.red,
                                                              dismissOnTouchOutside:
                                                                  false,
                                                            ).show();
                                                            if (areYouSure!) {
                                                              return;
                                                            }

                                                            try {
                                                              final params = {
                                                                "task_id":
                                                                    "${dailyTask['id']}",
                                                              };
                                                              final uri = Uri.https(
                                                                  Conn.url,
                                                                  "/app/api/task");
                                                              final newUri =
                                                                  uri.replace(
                                                                      queryParameters:
                                                                          params);
                                                              (uri);
                                                              Map<String,
                                                                      String>
                                                                  userHeader = {
                                                                'Authorization':
                                                                    'Token ${Conn.token}'
                                                              };

                                                              var deleteResponse =
                                                                  await delete(
                                                                newUri,
                                                                headers:
                                                                    userHeader,
                                                              );
                                                              // print(deleteResponse.statusCode);
                                                              if (deleteResponse
                                                                      .statusCode ==
                                                                  200) {
                                                                Scaffold.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        new SnackBar(
                                                                  backgroundColor:
                                                                      myBlue,
                                                                  content: new Text(
                                                                      'تم حذف المهمة'),
                                                                ));
                                                                await refreshList();
                                                              }
                                                            } on SocketException {
                                                              await AwesomeDialog(
                                                                      context:
                                                                          context,
                                                                      headerAnimationLoop:
                                                                          false,
                                                                      dialogType:
                                                                          DialogType
                                                                              .ERROR,
                                                                      animType:
                                                                          AnimType
                                                                              .SCALE,
                                                                      title:
                                                                          'لا يوجد اتصال بالإنترنت',
                                                                      desc:
                                                                          'تاكد من توصيل الجهاز باإنترنت',
                                                                      btnOkOnPress:
                                                                          () {},
                                                                      btnOkText:
                                                                          'تم',
                                                                      btnOkColor:
                                                                          Colors
                                                                              .red)
                                                                  .show();
                                                            } catch (e) {
                                                              print(e);
                                                            }
                                                          },
                                                          icon: Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '${dailyTask['score']} نقطة ',
                                                  style: TextStyle(
                                                      color: myBlue,
                                                      fontFamily: fontHiding2,
                                                      fontSize: 14),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                      children: days.map((day) {
                                                    return Text(
                                                      '${day['day']['name']} ',
                                                      style: TextStyle(
                                                          color: myBink,
                                                          fontFamily:
                                                              fontHiding2,
                                                          fontSize: 12),
                                                    );
                                                  }).toList()),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  height: 60,
                                                  child: ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children:
                                                          users.map((user) {
                                                        Icon? statIcon;
                                                        if (user['status']
                                                                ['id'] ==
                                                            1) {
                                                          statIcon = Icon(
                                                            Icons.timelapse,
                                                            color: Colors
                                                                .orangeAccent,
                                                            size: 20,
                                                          );
                                                        } else if (user[
                                                                    'status']
                                                                ['id'] ==
                                                            2) {
                                                          statIcon = Icon(
                                                            Icons.cached,
                                                            color: myBlue,
                                                            size: 20,
                                                          );
                                                        } else if (user[
                                                                    'status']
                                                                ['id'] ==
                                                            3) {
                                                          statIcon = Icon(
                                                            Icons.done,
                                                            color: Colors
                                                                .lightGreen,
                                                            size: 20,
                                                          );
                                                        } else if (user[
                                                                    'status']
                                                                ['id'] ==
                                                            4) {
                                                          statIcon = Icon(
                                                            Icons.cancel,
                                                            color: Colors
                                                                .redAccent,
                                                            size: 20,
                                                          );
                                                        }

                                                        GlobalKey userTooltip =
                                                            GlobalKey();
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              final dynamic
                                                                  tooltip =
                                                                  userTooltip
                                                                      .currentState;
                                                              tooltip
                                                                  .ensureTooltipVisible();
                                                            },
                                                            child: Tooltip(
                                                              key: userTooltip,
                                                              message:
                                                                  '${user['name']} \n${user['status']['name']}',
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width: 30,
                                                                    height: 30,
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      backgroundImage:
                                                                          NetworkImage(Conn.serverURL +
                                                                              user['pic']),
                                                                    ),
                                                                  ),
                                                                  statIcon!,
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList()),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()
                              : [
                                  Column(
                                    children: <Widget>[
                                      Icon(Icons.history),
                                      Text(
                                        'لا يوجد مهام\nالضغط على زر + لإضافة مهمة جديدة',
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )
                                ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.data == "UnAuthorized") {
          body = Container(
            child: Text('UnAuthorized'),
          );
        } else if (snapshot.data == "UnknownError" || snapshot.hasError) {
          body = Container(
            child: Text("${snapshot.error}"),
          );
        } else if (snapshot.data == "ConnectionError") {
          body = NoInternetPage();
        } else {
          body = LoadingPage();
        }
        return body;
      },
    );
  }
}
