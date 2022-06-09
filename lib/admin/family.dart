import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/routing/CupertinoPageRoute.dart';
import 'package:kau_app/utils/app_data.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/my_widget.dart';
import 'addModifyMember.dart';
import 'memberProfile.dart';

class FamilyPage extends StatefulWidget {
  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  Future<String?> isLoadData() async {
    if (Data.familyMemberList != null) {
      return 'done';
    } else
      return loadData();
  }

  bool _retryLoading = false;

  Future<String?> loadData() async {
    try {
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      var familyResponse = await get(Uri.parse(Conn.memberURL), headers: userHeader);
      var familyMap = jsonDecode(utf8.decode(familyResponse.bodyBytes));
      if (familyResponse.statusCode == 200) {
        if (familyMap['members'].length == 0) {
          Data.familyMemberList = null;
        } else {
          setState(() {
            Data.familyMemberList = familyMap['members'];
          });
        }
        return Conn.showDialog(familyResponse.statusCode, context, "description");
      } else {
        Conn.showDialog(familyResponse.statusCode, context, "description");
      }
    } on SocketException {
      Conn.showDialog(0, context, "description");
      return 'done';
    } catch (e) {
      print(e);
      return "UnknownError";
    }
    return null;
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    // await Future.delayed(Duration(seconds: 5));
    await loadData();
  }

  @override
  void initState() {
    // Data.familyMemberList = Data.familyMemberList ?? null;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FutureBuilder(
        future: isLoadData(),
        builder: (BuildContext cotext, AsyncSnapshot<String?> snapshot) {
          Widget body;
          if (snapshot.data == "done") {
            body = Scaffold(
              backgroundColor: myBackground,
              floatingActionButton: FloatingActionButton(
                backgroundColor: myBink,
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddModifyMember(
                            isEdit: false,
                          )));
                  await refreshList();
                },
                child: Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: RefreshIndicator(
                      onRefresh: refreshList,
                      child: ListView(
                        children: Data.familyMemberList != null
                            ? Data.familyMemberList!.map((member) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(CupertinoPageRoute(
                                          builder: (context) => MemberProfile(
                                                username: member['username'],
                                              )));
                                    },
                                    child: MyCard(
                                      backgroundColor: member['permission']['level'] < 2
                                          ? Colors.blue[50]!
                                          : Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 60,
                                            width: 60,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.transparent,
                                              radius: 30.0,
                                              backgroundImage:
                                                  NetworkImage(Conn.serverURL + member['pic']),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '${member['name']}',
                                                  style: TextStyle(
                                                      color: myBlue,
                                                      fontFamily: fontHiding2,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  member['permission']['level'] < 2
                                                      ? "مشرف"
                                                      : '${member['score']} نقطة',
                                                  style: TextStyle(
                                                      color: myBink,
                                                      fontFamily: fontHiding2,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Data.user!["permission"]['level'] == 0
                                              ? IconButton(
                                                  onPressed: () async {
                                                    bool? areYouSure;
                                                    await AwesomeDialog(
                                                      headerAnimationLoop: false,
                                                      context: context,
                                                      dialogType: DialogType.WARNING,
                                                      animType: AnimType.SCALE,
                                                      title: 'هل انت متاكد',
                                                      desc: 'هل ترغب بحذف العضو؟',
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
                                                      btnCancelColor: Colors.red,
                                                      dismissOnTouchOutside: false,
                                                    ).show();
                                                    if (areYouSure!) {
                                                      // return;
                                                    }
                                                    try {
                                                      // print(member['username']);
                                                      final params = {
                                                        "member_username": member['username'],
                                                      };
                                                      final uri =
                                                          Uri.https(Conn.url, "/app/api/member");
                                                      final newUri =
                                                          uri.replace(queryParameters: params);
                                                      // print(newUri);
                                                      Map<String, String> userHeader = {
                                                        'Authorization': 'Token ${Conn.token}'
                                                      };

                                                      var deleteResponse = await delete(
                                                        newUri,
                                                        headers: userHeader,
                                                      );
                                                      // print(deleteResponse.statusCode);
                                                      if (deleteResponse.statusCode == 200) {
                                                        setState(() {
                                                          Scaffold.of(context)
                                                              .showSnackBar(new SnackBar(
                                                            duration: Duration(),
                                                            backgroundColor: myBlue,
                                                            content: new Text('تم حذف العضو'),
                                                          ));
                                                          loadData();
                                                        });
                                                      }
                                                    } on SocketException {
                                                      await AwesomeDialog(
                                                        headerAnimationLoop: false,
                                                        context: context,
                                                        dialogType: DialogType.ERROR,
                                                        animType: AnimType.SCALE,
                                                        title: 'لا يوجد اتصال بالانترنت',
                                                        desc:
                                                            'الرجاء التاكد من تشغيل واي فاي او البيانات',
                                                        btnOkText: 'موافق',
                                                        btnOkColor: myBlue,
                                                        btnOkOnPress: () {},
                                                        dismissOnTouchOutside: true,
                                                      ).show();
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()
                            : [
                                Column(
                                  children: <Widget>[
                                    Icon(Icons.history),
                                    Text(
                                      'لا يوجد اعضاء في عائلتك\nالضغط على زر + لإضافة عضو جديد',
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
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
