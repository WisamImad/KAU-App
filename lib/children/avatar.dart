import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';

class Avatar extends StatefulWidget {
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  int avatarNum = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      height: SizeConfig.safeBlockVertical! * 100,
                      width: SizeConfig.safeBlockHorizontal! * 75,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/children/border_pink.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: SizeConfig.safeBlockVertical! * 7,
                          ),
                          Container(
                            height: SizeConfig.safeBlockVertical! * 15,
                            width: SizeConfig.safeBlockHorizontal! * 78,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/children/title_pic2.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "الصورة الشخصية",
                              style: TextStyle(fontSize: SizeConfig.safeBlockVertical! * 6, height: .2, fontFamily: 'ge_ss', fontWeight: FontWeight.bold, color: chBlue),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal! * 60,
                            child: GridView.count(
                              shrinkWrap: true,
                              mainAxisSpacing: SizeConfig.safeBlockVertical! * 5,
                              crossAxisCount: 4,
                              crossAxisSpacing: SizeConfig.safeBlockHorizontal! * 3,
                              children: <Widget>[
                                for (int j = 0; j < 8; j++) //display the num of bonus inside the jar
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        avatarNum = j;
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: SizeConfig.safeBlockVertical! * 4,
                                      backgroundColor: avatarNum == j ? Colors.black87 : Colors.transparent,
                                      child: Container(
                                        padding: EdgeInsets.all(SizeConfig.safeBlockVertical! * 0.5),
                                        child: Image.asset(
                                          "assets/children/child_avatar${j}.png",
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical! * 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              "assets/children/close.png",
                              height: SizeConfig.safeBlockVertical! * 10,
                              width: SizeConfig.safeBlockHorizontal! * 8,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                              onTap: () async {
                                bool? areYouSure;
                                await AwesomeDialog(
                                  headerAnimationLoop: false,
                                  context: context,
                                  dialogType: DialogType.WARNING,
                                  animType: AnimType.SCALE,
                                  title: 'هل انت متاكد',
                                  desc: 'هل ترغب بتسجيل الخروج؟',
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
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WelcomePage()), ModalRoute.withName('/'));
                                  Conn.logout();
                                }
                              },
                              child: Icon(Icons.exit_to_app)),
                        ),
                        GestureDetector(
                          onTap: () {
                            setAvatar();
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/children/button_green1.png",
                                  height: SizeConfig.safeBlockVertical! * 11,
                                  width: SizeConfig.safeBlockHorizontal! * 17,
                                ),
                                Text(
                                  "اختيار",
                                  style: TextStyle(fontSize: SizeConfig.safeBlockVertical! * 5.5, fontFamily: 'ge_ss', fontWeight: FontWeight.bold, color: chBlue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> setAvatar() async {
    ChildUserInfo.child!['image_in_app'] = avatarNum;
    try {
      final data = jsonEncode({"avatar_image_in_app": '$avatarNum'});
      // print(data);
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}', 'Content-Type': 'application/json'};
      var userResponse = await post(Uri.parse(Conn.childAvatarURL), headers: userHeader, body: data);
      var userMap = jsonDecode(utf8.decode(userResponse.bodyBytes));
      // print(userMap);
      if (userResponse.statusCode == 200) {
        ChildUserInfo.child!['image_in_app'] = avatarNum;
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
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WelcomePage()), ModalRoute.withName('/'));
        return '';
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
