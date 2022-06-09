//import 'package:audioplayer/audioplayer.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/children/send_message.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:path_provider/path_provider.dart';

class displayMessage extends StatefulWidget {
  final String? type;
  final Map? message;

  displayMessage({Key? key, this.type, this.message}) : super(key: key);

  @override
  _displayMessageState createState() => _displayMessageState();
}

class _displayMessageState extends State<displayMessage> with TickerProviderStateMixin {
  String status = "details";
  late String typeMessage; //the type of message image or voice
  bool is_playing = false;
  AudioCache cache = AudioCache(); // you have this
  AudioPlayer player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER); // create this
  // AudioPlayer audioPlugin = AudioPlayer();
  Future<File> urlToFile(String voiceUri) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath/' + (rng.nextInt(100)).toString() + '.m4a');
    Response response = await get(Uri.parse(voiceUri));
    await file.writeAsBytes(response.bodyBytes);
    voice = file;
    return file;
  }

  _seen() async {
    try {
      //create multipart request for POST or PATCH method
      var request = MultipartRequest("PUT", Uri.parse(Conn.messagingURL));
      request.fields["message_id"] = "${widget.message!['id']}";
      request.headers['Authorization'] = 'token ${Conn.token}';
      print('********************************************************************');
      var response = await request.send();
      print('********************************************************************');

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = utf8.decode(responseData);
      print(responseString);
      if (response.statusCode == 200) {
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
        await AwesomeDialog(
                context: context,
                headerAnimationLoop: false,
                dialogType: DialogType.ERROR,
                animType: AnimType.SCALE,
                title: 'يوجد مشكلة',
                desc: responseString.toString(),
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
      return 'done';
    } catch (e) {
      print(e);
    }
  }

  late File voice;

  @override
  void initState() {
    _seen();
    super.initState();
    typeMessage = widget.type!;
    // urlToFile(Conn.serverURL + widget.message['voice']);
  }

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
                                height: SizeConfig.safeBlockVertical! * 80,
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
                                              right: 20, top: SizeConfig.safeBlockVertical! * 1),
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
                                      height: SizeConfig.safeBlockVertical! * 55,
                                      width: SizeConfig.safeBlockHorizontal! * 35,
                                      alignment: Alignment.center,
                                      child: typeMessage == 'camera'
                                          ? Image.network(
                                              Conn.serverURL + widget.message!['image'],
                                              fit: BoxFit.contain,
                                              height: SizeConfig.safeBlockVertical! * 30,
                                              width: SizeConfig.safeBlockHorizontal! * 20,
                                            )
                                          : GestureDetector(
                                              onTap: () async {
                                                if (is_playing == true) {
                                                  player.stop();
                                                  setState(() {
                                                    is_playing = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    is_playing = true;
                                                  });

                                                  await player.play(
                                                      Conn.serverURL + widget.message!['voice'],
                                                      isLocal: false);
                                                  // player.getDuration().then((value) async {
                                                  //   print("value ********************************************");
                                                  //   print( (value / 100000).ceil());
                                                  //   await Future.delayed(Duration(seconds: (value / 100000).ceil() + 1));
                                                  //   setState(() {
                                                  //     is_playing = false;
                                                  //   });
                                                  // });
                                                }
                                              },
                                              child: is_playing
                                                  ? Image.asset(
                                                      "assets/children/message_voice2.png",
                                                      fit: BoxFit.contain,
                                                      height: SizeConfig.safeBlockVertical! * 30,
                                                    )
                                                  : Image.asset(
                                                      "assets/children/message_voice1.png",
                                                      fit: BoxFit.contain,
                                                      height: SizeConfig.safeBlockVertical! * 30,
                                                    ),
                                            ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Positioned(
                          bottom: SizeConfig.safeBlockVertical! * 12,
                          left: -SizeConfig.safeBlockHorizontal! * 5,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
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
                              width: SizeConfig.safeBlockHorizontal! * 16,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal! * 2),
                              child: Text(
                                'ارسال رد',
                                style: TextStyle(
                                    fontSize: SizeConfig.safeBlockVertical! * 5.5,
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
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/children/back_icon.png",
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
  }

  Widget messageWidget(String title, String image) {
    return Container(
      height: SizeConfig.safeBlockVertical! * 10.5,
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: SizeConfig.safeBlockVertical! * 6,
                fontFamily: 'ge_ss',
                fontWeight: FontWeight.bold,
                color: chBlue),
          ),
          SizedBox(
            width: SizeConfig.safeBlockHorizontal! * 4,
          ),
          Container(
            width: SizeConfig.safeBlockHorizontal! * 5,
            alignment: Alignment.center,
            child: Image.asset(
              "assets/children/${image}_icon.png",
              height: SizeConfig.safeBlockVertical! * 8,
            ),
          ),
          SizedBox(
            width: SizeConfig.safeBlockHorizontal! * 2,
          ),
        ],
      ),
    );
  }
}
