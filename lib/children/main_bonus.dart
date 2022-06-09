import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kau_app/children/bonus.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:video_player/video_player.dart';

import 'main_child.dart';

class MainBonus extends StatefulWidget {
  @override
  _MainBonusState createState() => _MainBonusState();
}

class _MainBonusState extends State<MainBonus> {
  List? rewards;

  Future<String?> loadData() async {
    print('enter method');
    try {
      final params = {
        "type": "all",
      };
      final uri = Uri.https(Conn.url, "/app/api/userreward");
      final newUri = uri.replace(queryParameters: params);
      // print(newUri);
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      print('before request');
      var rewardResponse = await get(
        newUri,
        headers: userHeader,
      );

      var rewardsMap = jsonDecode(utf8.decode(rewardResponse.bodyBytes));
      // print(rewardsMap);
      if (rewardResponse.statusCode == 200) {
        cost = rewardsMap['score'];
        print('after request');
        rewards = rewardsMap['reward'];
        if (rewards!.length == 0) {
          rewards;
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

  ScrollController controller = ScrollController();

  int cost = 12;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // cost = ChildUserInfo.child['score'];
    _controller = VideoPlayerController.asset("assets/children/loading_child.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(true);
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
        print(snapshot.data);
        if (snapshot.data == 'done') {
          _controller.pause();
          returnWidget = SafeArea(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.asset(
                            "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                            height: SizeConfig.safeBlockVertical! * 15,
                            width: SizeConfig.safeBlockHorizontal! * 10,
                          ),
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal! * 1,
                          ),
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: SizeConfig.safeBlockVertical! * 8,
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
                                      'اختار مكافئاتي',
                                      style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal! * 3,
                                          fontFamily: 'ge_ss',
                                          fontWeight: FontWeight.bold,
                                          color: chBlue),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/children/score_icon_green.png",
                                    height: SizeConfig.safeBlockVertical! * 12.5,
                                    width: SizeConfig.safeBlockHorizontal! * 19,
                                  ),
                                  Positioned(
                                    top: -SizeConfig.safeBlockVertical! * 4,
                                    right: SizeConfig.safeBlockVertical! * 10,
                                    child: Text(
                                      '${cost}',
                                      style: TextStyle(
                                          fontSize: SizeConfig.safeBlockVertical! * 8,
                                          fontFamily: 'a-massir-ballpoint',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
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
                        height: SizeConfig.safeBlockVertical! * 2,
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                controller.animateTo((controller.offset) + 50,
                                    curve: Curves.linear, duration: Duration(milliseconds: 80));
                              },
                              child: Container(
                                height: SizeConfig.safeBlockVertical! * 55,
                                width: SizeConfig.safeBlockHorizontal! * 4,
                                decoration: BoxDecoration(
                                    color: chBink,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(SizeConfig.safeBlockVertical! * 2),
                                        bottomLeft:
                                            Radius.circular(SizeConfig.safeBlockVertical! * 2))),
                                child: Image.asset(
                                  "assets/children/left_arrow_icon.png",
                                  scale: 1.5,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: SizeConfig.safeBlockVertical! * 50,
                                color: Colors.white,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ListView.builder(
                                    itemCount: rewards == null ? 0 : rewards!.length,
                                    scrollDirection: Axis.horizontal,
                                    controller: controller,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: InkWell(
                                          onTap: () {
                                            if (!(cost <= rewards![index]['score'])) {
                                              getReward(rewards![index]['id']);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Bonus()),
                                              );
                                            }
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: SizeConfig.safeBlockVertical! * 2,
                                              ),
                                              Stack(
                                                alignment: AlignmentDirectional.topStart,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Stack(
                                                        children: <Widget>[
                                                          Container(
                                                            height:
                                                                SizeConfig.safeBlockVertical! * 31,
                                                            width: SizeConfig.safeBlockHorizontal! *
                                                                14,
                                                            decoration: BoxDecoration(
                                                              color: chBink1,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            padding: EdgeInsets.all(5),
                                                            child: CircleAvatar(
                                                              radius: 50.0,
                                                              backgroundImage: NetworkImage(
                                                                Conn.serverURL +
                                                                    rewards![index]['picture'],
                                                              ),
                                                            ),
                                                          ),
                                                          cost <= rewards![index]['score']
                                                              ? Container(
                                                                  //اذا كانت تكلفة المكافأة أعلى من السكور تبع الطفل راح يكون باللون الرصاصي
                                                                  height: SizeConfig
                                                                          .safeBlockVertical! *
                                                                      31,
                                                                  width: SizeConfig
                                                                          .safeBlockHorizontal! *
                                                                      14,
                                                                  decoration: BoxDecoration(
                                                                    color: chgray1,
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                      Stack(
                                                        children: <Widget>[
                                                          Container(
                                                            height:
                                                                SizeConfig.safeBlockVertical! * 15,
                                                            width: SizeConfig.safeBlockHorizontal! *
                                                                12,
                                                            decoration: BoxDecoration(
                                                                color: chBink,
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(SizeConfig
                                                                            .safeBlockVertical! *
                                                                        3))),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.center,
                                                              children: <Widget>[
                                                                Text(
                                                                  '${rewards![index]['score']}',
                                                                  style: TextStyle(
                                                                      fontSize: SizeConfig
                                                                              .safeBlockVertical! *
                                                                          10,
                                                                      fontFamily: 'ge_ss',
                                                                      fontWeight: FontWeight.bold,
                                                                      height: 1,
                                                                      color: Colors.white),
                                                                ),
                                                                SizedBox(
                                                                  width: SizeConfig
                                                                          .safeBlockHorizontal! *
                                                                      .5,
                                                                ),
                                                                Image.asset(
                                                                  "assets/children/star_icon.png",
                                                                  height: SizeConfig
                                                                          .safeBlockVertical! *
                                                                      15,
                                                                  width: SizeConfig
                                                                          .safeBlockHorizontal! *
                                                                      5,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          cost <= rewards![index]['score']
                                                              ? Container(
                                                                  height: SizeConfig
                                                                          .safeBlockVertical! *
                                                                      15,
                                                                  width: SizeConfig
                                                                          .safeBlockHorizontal! *
                                                                      12,
                                                                  decoration: BoxDecoration(
                                                                      color: chgray,
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(SizeConfig
                                                                                  .safeBlockVertical! *
                                                                              3))),
                                                                )
                                                              : Container(),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  cost <= rewards![index]['score']
                                                      ? Positioned(
                                                          top: 5,
                                                          right: -10,
                                                          child: Image.asset(
                                                            "assets/children/lock_icon.png",
                                                            height:
                                                                SizeConfig.safeBlockVertical! * 7,
                                                            width:
                                                                SizeConfig.safeBlockHorizontal! * 7,
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.animateTo((controller.offset) - 50,
                                    curve: Curves.linear, duration: Duration(milliseconds: 80));
                              },
                              child: Container(
                                height: SizeConfig.safeBlockVertical! * 55,
                                width: SizeConfig.safeBlockHorizontal! * 4,
                                decoration: BoxDecoration(
                                    color: chBink,
                                    borderRadius: BorderRadius.only(
                                        topRight:
                                            Radius.circular(SizeConfig.safeBlockVertical! * 2),
                                        bottomRight:
                                            Radius.circular(SizeConfig.safeBlockVertical! * 2))),
                                child: Image.asset(
                                  "assets/children/right_arrow_icon.png",
                                  scale: 1.5,
                                ),
                              ),
                            ),
                          ],
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

  getReward(int id) async {
    try {
      var request = MultipartRequest("POST", Uri.parse(Conn.childRewordURL));

      request.fields["reward"] = "$id";
      request.headers['Authorization'] = 'token ${Conn.token}';
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      // print(responseString);

      if (response.statusCode == 200) {
        // print('done');
        return;
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
        return;
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
