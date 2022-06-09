import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:kau_app/routing/CupertinoPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' as inel;
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_data.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/my_widget.dart';
import 'memberProfile.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Future<String> isLoadData() async {
    if (Data.notificationList != null) {
      return 'done';
    } else
      return loadData();
  }

  //may be found null safety error
  Future<String> loadData() async {
    try {
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      var notificationResponse =
          await get(Uri.parse(Conn.notificationURL), headers: userHeader);
      var notificationMap =
          jsonDecode(utf8.decode(notificationResponse.bodyBytes));
      if (notificationResponse.statusCode == 200) {
        if (notificationMap.length == 0) {
          Data.notificationList = null;
        } else {
          setState(() {
            Data.notificationList = notificationMap;
          });
        }
        return 'done';
      } else if (notificationResponse.statusCode == 401) {
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
      return "UnknownError";
    }
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await loadData();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FutureBuilder(
        future: isLoadData(),
        builder: (BuildContext cotext, AsyncSnapshot<String> snapshot) {
          Widget body;
          if (snapshot.data == "done") {
            body = Scaffold(
              backgroundColor: myBackground,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: RefreshIndicator(
                      onRefresh: refreshList,
                      child: ListView(
                        children: Data.notificationList != null
                            ? Data.notificationList!.map((notification) {
                                DateTime dateTime =
                                    inel.DateFormat("yyyy-MM-DDTHH:mm:ss")
                                        .parse(notification['created_at']);

                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 0, 7),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (notification['navigate_to'] == "" ||
                                          notification['navigate_to'] ==
                                              'null') {
                                      } else {
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    MemberProfile(
                                                      username: notification[
                                                          'navigate_to'],
                                                      tab: 1,
                                                    )));
                                      }
                                    },
                                    child: MyCard(
                                      child: Row(
                                        children: <Widget>[
                                          // Icon(Icons.notifications_none,size: 35, color: myBink,),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              child: Center(
                                                  child: Image.network(
                                                      Conn.serverURL +
                                                          notification['type']
                                                              ['image'])),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '${notification['type']['name']}   ',
                                                  style: TextStyle(
                                                      color: myBlue,
                                                      fontFamily: fontHiding2,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  '${notification['body']}',
                                                  style: TextStyle(
                                                      color: myBink,
                                                      fontFamily: fontHiding2,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  '${inel.DateFormat.MMMEd().add_jm().format(dateTime)}',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: fontHiding2,
                                                      fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    bool? areYouSure;
                                                    await AwesomeDialog(
                                                      headerAnimationLoop:
                                                          false,
                                                      context: context,
                                                      dialogType:
                                                          DialogType.WARNING,
                                                      animType: AnimType.SCALE,
                                                      title: 'هل انت متاكد',
                                                      desc:
                                                          'هل ترغب بحذف الإشعار؟',
                                                      btnOkOnPress: () {
                                                        setState(() {
                                                          areYouSure = true;
                                                        });
                                                      },
                                                      btnOkText: 'موافق',
                                                      btnOkColor: myBlue,
                                                      btnCancelOnPress: () {
                                                        setState(() {
                                                          areYouSure = false;
                                                        });
                                                      },
                                                      btnCancelText: "الغاء",
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
                                                        "notification_id":
                                                            "${notification['id']}",
                                                      };
                                                      final uri = Uri.https(
                                                          Conn.url,
                                                          "/app/api/notifications");
                                                      final newUri =
                                                          uri.replace(
                                                              queryParameters:
                                                                  params);
                                                      // print(newUri);
                                                      Map<String, String>
                                                          userHeader = {
                                                        'Authorization':
                                                            'Token ${Conn.token}'
                                                      };

                                                      var deleteResponse =
                                                          await delete(
                                                        newUri,
                                                        headers: userHeader,
                                                      );
                                                      // print(deleteResponse.statusCode);
                                                      if (deleteResponse
                                                              .statusCode ==
                                                          200) {
                                                        Scaffold.of(context)
                                                            .showSnackBar(
                                                                new SnackBar(
                                                          backgroundColor:
                                                              myBlue,
                                                          content: new Text(
                                                              'تم حذف الإشعار'),
                                                        ));
                                                        await refreshList();
                                                      }
                                                    } on SocketException {
                                                      await AwesomeDialog(
                                                              context: context,
                                                              headerAnimationLoop:
                                                                  false,
                                                              dialogType:
                                                                  DialogType
                                                                      .ERROR,
                                                              animType: AnimType
                                                                  .SCALE,
                                                              title:
                                                                  'لا يوجد اتصال بالإنترنت',
                                                              desc:
                                                                  'تاكد من توصيل الجهاز باإنترنت',
                                                              btnOkOnPress:
                                                                  () {},
                                                              btnOkText: 'تم',
                                                              btnOkColor:
                                                                  Colors.red)
                                                          .show();
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()
                            : [
                                Column(
                                  children: <Widget>[
                                    Icon(Icons.notifications_paused),
                                    Text(
                                      'لا يوجد إشعارات',
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )
                              ],
                      ),
                    ),
                  ),
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
          } else {
            body = Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child: SpinKitPumpingHeart(
                        color: myBink,
                      ),
                      width: 60,
                      height: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('جاري التحميل'),
                    )
                  ]),
            );
          }
          return body;
        },
      ),
    );
  }
}
