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
import 'addModifyReward.dart';

class RewardPage extends StatefulWidget {
  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  Future<String?> isLoadData() async {
    if (Data.rewardList != null)
      return 'done';
    else
      return loadData();
  }

  // bool _retryLoading = false;

  Future<String?> loadData() async {
    try {
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      var rewardResponse =
          await get(Uri.parse(Conn.rewardURL), headers: userHeader);
      var rewardMap = jsonDecode(utf8.decode(rewardResponse.bodyBytes));
      if (rewardResponse.statusCode == 200) {
        if (rewardMap.length == 0) {
          Data.rewardList = null;
        } else {
          setState(() {
            Data.rewardList = rewardMap;
          });
        }

        return 'done';
      } else if (rewardResponse.statusCode == 401) {
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
    return null;
    //null;
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
        builder: (BuildContext cotext, AsyncSnapshot<String?> snapshot) {
          Widget body;
          if (snapshot.data == "done") {
            body = Scaffold(
              backgroundColor: myBackground,
              floatingActionButton: FloatingActionButton(
                backgroundColor: myBink,
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddModifyReward(
                            isEdit: false,
                            reward: {},
                          )));
                  refreshList();
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
                        children: Data.rewardList != null
                            ? Data.rewardList!.map((reward) {
                                print(reward);
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 0, 7),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddModifyReward(
                                                    isEdit: true,
                                                    reward: reward,
                                                  )));
                                      refreshList();
                                    },
                                    child: MyCard(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 60,
                                            width: 60,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 30.0,
                                              backgroundImage: NetworkImage(
                                                  Conn.serverURL +
                                                      (reward['picture'] ??
                                                          reward['icon'])),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '${reward['name']}',
                                                  style: TextStyle(
                                                      color: myBlue,
                                                      fontFamily: fontHiding2,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  '${reward['score']} نقطة',
                                                  style: TextStyle(
                                                      color: myBink,
                                                      fontFamily: fontHiding2,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddModifyReward(
                                                            isEdit: true,
                                                            reward: reward,
                                                          )));
                                              print('errorr');
                                              refreshList();
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
                                                headerAnimationLoop: false,
                                                context: context,
                                                dialogType: DialogType.WARNING,
                                                animType: AnimType.SCALE,
                                                title: 'هل انت متاكد',
                                                desc: 'هل ترغب بحذف المكافئة؟',
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
                                                return;
                                              }
                                              try {
                                                final params = {
                                                  "reward_id":
                                                      "${reward['id']}",
                                                };
                                                final uri = Uri.https(Conn.url,
                                                    "/app/api/reward");
                                                final newUri = uri.replace(
                                                    queryParameters: params);
                                                // print(newUri);
                                                Map<String, String> userHeader =
                                                    {
                                                  'Authorization':
                                                      'Token ${Conn.token}'
                                                };

                                                var deleteResponse =
                                                    await delete(
                                                  newUri,
                                                  headers: userHeader,
                                                );
                                                // print(deleteResponse.statusCode);
                                                if (deleteResponse.statusCode ==
                                                    200) {
                                                  Scaffold.of(context)
                                                      .showSnackBar(
                                                          new SnackBar(
                                                    backgroundColor: myBlue,
                                                    content: new Text(
                                                        'تم حذف المكافئة'),
                                                  ));
                                                  await refreshList();
                                                }
                                              } on SocketException {
                                                await AwesomeDialog(
                                                        context: context,
                                                        headerAnimationLoop:
                                                            false,
                                                        dialogType:
                                                            DialogType.ERROR,
                                                        animType:
                                                            AnimType.SCALE,
                                                        title:
                                                            'لا يوجد اتصال بالإنترنت',
                                                        desc:
                                                            'تاكد من توصيل الجهاز باإنترنت',
                                                        btnOkOnPress: () {},
                                                        btnOkText: 'تم',
                                                        btnOkColor: Colors.red)
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
                                    ),
                                  ),
                                );
                              }).toList()
                            : [
                                Column(
                                  children: <Widget>[
                                    Icon(Icons.history),
                                    Text(
                                      'لا يوجد مكافئات\nالضغط على زر + لإضافة مكافئة جديدة',
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
