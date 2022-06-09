import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';

class Bonus extends StatefulWidget {
  @override
  _BonusState createState() => _BonusState();
}

class _BonusState extends State<Bonus> {
  List bonus = [];

  Future<String?> loadData() async {
    try {
      final params = {
        "type": "owned",
      };
      final uri = Uri.https(Conn.url, "/app/api/userreward");
      final newUri = uri.replace(queryParameters: params);
      // print(newUri);
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      var rewardResponse = await get(
        newUri,
        headers: userHeader,
      );

      var rewardsMap = jsonDecode(utf8.decode(rewardResponse.bodyBytes));
      // print(rewardsMap);
      if (rewardResponse.statusCode == 200) {
        bonus = rewardsMap['reward'];
        print('after request');
        setState(() {});

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
  }

  @override
  void initState() {
    super.initState();
    loadData();
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
              child: Stack(
                children: <Widget>[
                  bonusWidget(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset(
                            "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                            height: SizeConfig.safeBlockVertical! * 17,
                            width: SizeConfig.safeBlockHorizontal! * 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              "assets/children/back_icon.png",
                              height: SizeConfig.safeBlockVertical! * 10,
                              width: SizeConfig.safeBlockHorizontal! * 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget bonusWidget() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        for (int i = 0; i < bonus.length / 6; i++) // to display the num of jar
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.safeBlockVertical! * 2, horizontal: 20),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 85,
                  width: SizeConfig.safeBlockHorizontal! * 50,
                  child: Image.asset(
                    "assets/children/bonus_jar.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 18,
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal! * 25,
                          child: Image.asset(
                            "assets/children/title_yallow_pic.png",
                            fit: BoxFit.fill,
                            // scale: SizeConfig.safeBlockVertical * .6,
                          ),
                        ),
                        Text(
                          'مكافئاتي',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical! * 6,
                              fontFamily: 'ge_ss',
                              fontWeight: FontWeight.bold,
                              color: chBlue),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 37,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: SizeConfig.safeBlockVertical! * 5,
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: <Widget>[
                              for (int j = 0, b = 0;
                                  j < 6 && bonus.length - i * 6 > b;
                                  b++,
                                  j++) //display the num of bonus inside the jar
                                CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: NetworkImage(
                                    Conn.serverURL + bonus[b]['picture'],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
      ]),
    );
  }
}
