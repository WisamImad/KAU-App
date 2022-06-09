import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_data.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/my_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart' as inel;
import '../User.dart';
import 'addModifyMember.dart';
import 'message.dart';

class MemberProfile extends StatefulWidget {
  String? username;
  int? tab;

  MemberProfile({this.username, this.tab});

  @override
  _MemberProfileState createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile>
    with TickerProviderStateMixin {
  TabController? _tabController;
  Member? member;
  List? messages;
  bool isPlaying = false;
  int playingID = 0;
  AudioPlayer player = AudioPlayer();
  bool _logoutAllBtnLoading = false;
  int tab = 0;

  Future<String?> isLoadData() async {
    if (messages != null) {
      return 'done';
    } else
      return loadData();
  }

  Future<String?> loadData() async {
    try {
      final params = {
        "member_username": widget.username,
      };
      final uri = Uri.https(Conn.url, "/app/api/member");
      final newUri = uri.replace(queryParameters: params);
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};

      var getResponse = await get(
        newUri,
        headers: userHeader,
      );
      var memberMap = jsonDecode(utf8.decode(getResponse.bodyBytes));

      if (getResponse.statusCode == 200) {
        print(memberMap['member']['permission']);
        setState(() {
          member = Member(
              id: memberMap['member']['id'],
              username: memberMap['member']['username'],
              name: memberMap['member']['name'],
              birthday: memberMap['member']['birthday'],
              role: memberMap['member']['role'],
              level: memberMap['member']['permission']['level'],
              pic: NetworkImage(Conn.serverURL + memberMap['member']['pic']),
              picURL: memberMap['member']['pic'],
              password: memberMap['new_password'],
              score: memberMap['member']['score']);
          messages = memberMap['messages'];
        });

        print(messages);
        return 'done';
      } else if (getResponse.statusCode == 401) {
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
      Navigator.pop(context);
    } catch (e) {
      print(e);
      return "UnknownError";
    }
  }

  _play(String voiceUrl, int voiceID) async {
    int result = await player.play(Conn.serverURL + voiceUrl, isLocal: false);

    print(result);
    setState(() {
      isPlaying = true;
      playingID = voiceID;
    });
    player.onPlayerCompletion.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  _stop() {
    player.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    if (widget.tab != null) {
      tab = widget.tab!;
    }
    _tabController!.index = tab;
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    // await Future.delayed(Duration(seconds: 5));
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder(
          future: isLoadData(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            Widget body;
            if (snapshot.data == "done") {
              body = Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  body: SafeArea(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return <Widget>[
                          // Add the app bar to the CustomScrollView.
                          SliverAppBar(
                            centerTitle: true,
                            title: Text(
                              "حساب العضو",
                              style: TextStyle(
                                fontFamily: fontHiding1,
                                fontSize: 25,
                                color: myBink,
                              ),
                            ),
                            iconTheme: IconThemeData(color: myBink),
                            actions: <Widget>[
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AddModifyMember(
                                            member: member,
                                            isEdit: true,
                                          )));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: myBink,
                                ),
                              )
                            ],
                            flexibleSpace: FlexibleSpaceBar(
                              background: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 60, 10, 0),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          Container(
                                            height: 100,
                                            width: 100,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 30.0,
                                              backgroundImage: member!.pic,
                                            ),
                                          ),
                                          Card(
                                            color: myBlue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(23))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      12, 2, 12, 2),
                                              child: Text(
                                                '${member!.score} نقطة',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: fontHiding2,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${member!.name}',
                                        style: TextStyle(
                                            fontFamily: fontHiding2,
                                            fontSize: 22,
                                            color: myBlue),
                                      ),
                                      Text(
                                        '${member!.role!['name']}',
                                        style: TextStyle(
                                            fontFamily: fontHiding2,
                                            fontSize: 16,
                                            color: myBink),
                                      ),
                                      Divider(),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(24))),
                                        height: 30,
                                        child: TabBar(
                                            controller: _tabController,
                                            unselectedLabelColor: myBlue,
                                            indicatorSize:
                                                TabBarIndicatorSize.label,
                                            indicator: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                color: myBink),
                                            tabs: [
                                              Tab(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "الباركود",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontHiding2,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Tab(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "الانشطة",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontHiding2,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            floating: true,
                            // Make the initial height of the SliverAppBar larger than normal.
                            expandedHeight: 270,
                            backgroundColor: myBackground,
                          ),
                          // Next, create a SliverList
                        ];
                      },
                      body: Container(
                        color: myBackground,
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView(
                                children: <Widget>[
                                  Text('رمز الـ QR الخاص بالعضو'),
                                  IconButton(
                                    onPressed: () {
                                      loadData();
                                    },
                                    icon: Icon(Icons.refresh),
                                  ),
                                  Center(
                                    child: QrImage(
                                      data:
                                          "${member!.username} ${member!.password}",
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),
                                  ),
                                  Text(
                                    'لتسجيل الدخول السريع على جهاز اطفالك او المشرف الثاني\n يمكنك استخدام الـ QR.',
                                    style: TextStyle(
                                        fontFamily: fontHiding2,
                                        color: myBlue,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.file_download),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "قم اولا بتنزيل برنامج الابن الرضي على جهاز الطفل",
                                          style: TextStyle(
                                              fontFamily: fontHiding2,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.exit_to_app),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "في الواجهة الترحبية، اضغط على 'الدخول كفرد' اسفل الشاشة",
                                          style: TextStyle(
                                              fontFamily: fontHiding2,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.center_focus_weak),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "وجه كاميرا جهاز الطفل الى الـ QR اعلاه",
                                        style: TextStyle(
                                            fontFamily: fontHiding2,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Data.user!['permission']['level'] == 0
                                      ? SizedBox(
                                          height: 48,
                                          width: double.infinity,
                                          child: RaisedButton(
                                            color: myBink,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                            ),
                                            onPressed: () async {
                                              bool? areYouSure;
                                              await AwesomeDialog(
                                                headerAnimationLoop: false,
                                                context: context,
                                                dialogType: DialogType.WARNING,
                                                animType: AnimType.SCALE,
                                                title: 'هل انت متاكد',
                                                desc:
                                                    'هل ترغب بتسجيل الخروج من جميع الاجهزة لهذا المستخدم؟',
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
                                                _logoutAll();
                                              }
                                            },
                                            child: _logoutAllBtnLoading
                                                ? SpinKitRipple(
                                                    color: Colors.white,
//                              type: SpinKitWaveType.start
                                                  )
                                                : Text(
                                                    'الإجبارعلى تسجيل الخروج',
                                                    style: fontButtonStyle),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RefreshIndicator(
                                onRefresh: refreshList,
                                child: ListView(
                                  children: messages != null
                                      ? messages!.map((message) {
                                          DateTime dateTime = inel.DateFormat(
                                                  "yyyy-MM-DDTHH:mm:ss")
                                              .parse(message['created_at']);
                                          var img;
                                          bool isImage = true;

                                          if (message['image_in_app'] != null) {
                                            img = Image.asset(
                                                message['image_in_app']);
                                            print("image in app");
                                            print(message['image_in_app']);
                                          } else if (message['voice'] != null) {
                                            // img = audiRecorder(message['voice']);
                                            isImage = false;
                                          } else if (message['image'] != null) {
                                            img = Image.network(Conn.serverURL +
                                                message['image']);
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 7, 0, 7),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (message['image'] != null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content:
                                                              Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            child: Container(
                                                              width: double
                                                                  .maxFinite,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  5,
                                                              child: img,
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                }
                                                if (message['voice'] != null) {
                                                  print("voice");
                                                  isPlaying
                                                      ? _stop()
                                                      : _play(message['voice'],
                                                          message['id']);
                                                }

                                                // Navigator.of(context).push(CupertinoPageRoute(
                                                //     builder: (context) => MemberProfile(
                                                //       username: member['username'],
                                                //     )));
                                              },
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: MyCard(
                                                  backgroundColor:
                                                      message['user'] ==
                                                              member!.id
                                                          ? Colors.blue[50]!
                                                          : Colors.white,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 30,
                                                              width: 30,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                radius: 30.0,
                                                                backgroundImage: message[
                                                                            'user'] ==
                                                                        member!
                                                                            .id
                                                                    ? Data.user![
                                                                        'pic']
                                                                    : member!
                                                                        .pic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 8,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  child: Center(
                                                                      child: isImage
                                                                          ? img
                                                                          : isPlaying && playingID == message['id']
                                                                              ? Icon(
                                                                                  Icons.pause,
                                                                                  size: 30,
                                                                                  color: myBink,
                                                                                )
                                                                              : Icon(
                                                                                  Icons.play_arrow,
                                                                                  size: 30,
                                                                                  color: myBink,
                                                                                )),
                                                                ),
                                                                // Text(
                                                                //   message['user']==member.id? 'مرسلة': 'مستقبلة',
                                                                //   style: TextStyle(color: myBlue, fontFamily: fontHiding2, fontSize: 8),
                                                                // ),
                                                                Flexible(
                                                                  child: Text(
                                                                    '${inel.DateFormat.MMMEd().add_jm().format(dateTime)}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontFamily:
                                                                            fontHiding2,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    '${message['text']}',
                                                                    style: TextStyle(
                                                                        color:
                                                                            myBink,
                                                                        fontFamily:
                                                                            fontHiding2,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // SizedBox(
                                                      //   width: 15,
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList()
                                      : [
                                          Center(
                                            child: Text(
                                                'لا يوجد انشطة حتى الأن...'),
                                          )
                                        ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.message),
                    backgroundColor: myBink,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SendMessage(
                                member: member!,
                              )));
                    },
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
              body = Scaffold(body: NoInternetPage());
            } else {
              body = Scaffold(body: LoadingPage());
            }
            return body;
          },
        ));
  }

  _logoutAll() async {
    try {
      final body = {
        "username": widget.username,
      };
      final uri = Uri.https(Conn.url, "/app/api/logout_member");
      // final newUri = uri.replace(queryParameters: params);
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};

      var response = await post(uri, headers: userHeader, body: body);
      var responseStr = jsonDecode(utf8.decode(response.bodyBytes));
      print(responseStr);
      if (response.statusCode == 200) {
        await AwesomeDialog(
                context: context,
                headerAnimationLoop: false,
                dialogType: DialogType.SUCCES,
                animType: AnimType.SCALE,
                title: 'تم تسجيل الخروج بنجاح',
                desc: 'يجب اعادة تسجيل الدخول من جديد للاستفادة من التطبيق',
                btnOkOnPress: () {},
                btnOkText: 'تم',
                btnOkColor: myBlue)
            .show();
      } else if (response.statusCode == 401) {
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
      } else {
        print(responseStr);
        await AwesomeDialog(
                context: context,
                headerAnimationLoop: false,
                dialogType: DialogType.ERROR,
                animType: AnimType.SCALE,
                title: 'حدث خطاء ما!',
                desc: responseStr.toString(),
                btnOkOnPress: () {},
                btnOkText: 'تم',
                btnOkColor: Colors.red)
            .show();
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
  }
}
