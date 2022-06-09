import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kau_app/children/display_message.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/children/send_message.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:video_player/video_player.dart';
import 'main_child.dart';

class MainMessage extends StatefulWidget {
  @override
  _MainMessageState createState() => _MainMessageState();
}

class _MainMessageState extends State<MainMessage> with TickerProviderStateMixin {
  // String status = "details";

  List? messages;

  Future<String?> loadData() async {
    try {
      final uri = Uri.https(Conn.url, "/app/api/messgaging");
      // print(newUri);
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      print('before request');
      var rewardResponse = await get(
        uri,
        headers: userHeader,
      );

      var messagesMap = jsonDecode(utf8.decode(rewardResponse.bodyBytes));
      // print(rewardsMap);
      if (rewardResponse.statusCode == 200) {
        print('after request');
        messages = messagesMap;
        if (messages!.length == 0) {
          messages = null;
        }
        print(messages);
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
    } catch (e) {
      print(e);
    }
    return null;
  }

  ScrollController controller = ScrollController();

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
                color: Colors.white,
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                            height: SizeConfig.safeBlockVertical! * 17,
                            width: SizeConfig.safeBlockHorizontal! * 10,
                          ),
                          Stack(
                            // overflow: Overflow.visible,
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: SizeConfig.safeBlockVertical! * 4,
                                  ),
                                  Container(
                                      height: SizeConfig.safeBlockVertical! * 85,
                                      width: SizeConfig.safeBlockHorizontal! * 75,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/children/message_border.png",
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      padding: EdgeInsets.only(
                                          top: SizeConfig.safeBlockVertical! * 5, right: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Stack(
                                            alignment: AlignmentDirectional.topCenter,
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/children/title_pic1.png",
                                                height: SizeConfig.safeBlockVertical! * 15,
                                                width: SizeConfig.safeBlockHorizontal! * 80,
                                                fit: BoxFit.fill,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 20,
                                                    top: SizeConfig.safeBlockVertical! * 1),
                                                child: Text(
                                                  'الرسائل',
                                                  style: TextStyle(
                                                      fontSize: SizeConfig.safeBlockVertical! * 6.5,
                                                      fontFamily: 'ge_ss',
                                                      fontWeight: FontWeight.bold,
                                                      color: chBlue),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/children/border.png",
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            height: SizeConfig.safeBlockVertical! * 60,
                                            width: SizeConfig.safeBlockVertical! * 80,
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: SizeConfig.safeBlockVertical! * 2,
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.safeBlockVertical! * 50,
                                                  width: SizeConfig.safeBlockHorizontal! * 37,
                                                  child: ListView.builder(
                                                    itemCount:
                                                        messages == null ? 0 : messages!.length,
                                                    scrollDirection: Axis.vertical,
                                                    controller: controller,
                                                    itemBuilder: (context, index) {
                                                      return Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: messageWidget(
                                                            "رسالة ${index + 1}",
                                                            messages![index]['image'] == null
                                                                ? "voice"
                                                                : 'camera',
                                                            messages![index]),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              Positioned(
                                bottom: SizeConfig.safeBlockVertical! * 12,
                                //left: - SizeConfig.safeBlockHorizontal * 5,
                                left: -SizeConfig.safeBlockHorizontal! * 5,

                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => sendMessage()),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "assets/children/button_green1.png",
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    height: SizeConfig.safeBlockVertical! * 15,
                                    width: SizeConfig.safeBlockVertical! * 27,
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.only(right: SizeConfig.safeBlockHorizontal! * 2),
                                    child: Text(
                                      'ارسال رسالة',
                                      style: TextStyle(
                                          fontSize: SizeConfig.safeBlockVertical! * 4,
                                          fontFamily: 'ge_ss',
                                          fontWeight: FontWeight.bold,
                                          color: chBlue),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: Image.asset(
                            "assets/children/home_icon.png",
                            height: SizeConfig.safeBlockVertical! * 10,
                            width: SizeConfig.safeBlockHorizontal! * 10,
                          ),
                        ),
                      ),
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

  Widget messageWidget(String title, String image, Map message) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => displayMessage(
                    type: image,
                    message: message,
                  )),
        );
      },
      child: Container(
        height: SizeConfig.safeBlockVertical! * 10.5,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 3))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.brightness_1,
                  size: 15, color: message['seen'] ? Colors.white : myBlue),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical! * 6,
                  fontFamily: 'ge_ss',
                  fontWeight: FontWeight.bold,
                  color: chBlue),
            ),
            Container(
              width: SizeConfig.safeBlockHorizontal! * 5,
              alignment: Alignment.center,
              child: Image.asset(
                "assets/children/${image}_icon.png",
                height: SizeConfig.safeBlockVertical! * 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
