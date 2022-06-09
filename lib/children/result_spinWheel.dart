import 'package:flutter/material.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/connection.dart';

class ResultSpinWheel extends StatefulWidget {
  int? score;
  String? message;
  ResultSpinWheel({this.score, this.message});
  @override
  _ResultSpinWheelState createState() => _ResultSpinWheelState();
}

class _ResultSpinWheelState extends State<ResultSpinWheel> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/children/videos/resultSpain.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(false);
        // Ensure the first frame is shown after the video is initialized.
        // setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Container(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  height: SizeConfig.safeBlockVertical! * 100,
                  width: SizeConfig.safeBlockHorizontal! * 100,
                  child: VideoPlayer(_controller)),
              Positioned(
                top: SizeConfig.safeBlockVertical! * 6,
                left: SizeConfig.safeBlockHorizontal! * 2,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Container(
                    width: SizeConfig.safeBlockHorizontal! * 8,
                    height: SizeConfig.safeBlockVertical! * 10,
                    child: Image.asset(
                      "assets/children/home_icon1.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: SizeConfig.safeBlockVertical! * 6,
                left: SizeConfig.safeBlockHorizontal! * 90,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: SizeConfig.safeBlockHorizontal! * 8,
                    height: SizeConfig.safeBlockVertical! * 10,
                    child: Image.asset(
                      "assets/children/back_icon.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: SizeConfig.safeBlockVertical! * 10,
                left: SizeConfig.safeBlockVertical! * 10,
                child: GestureDetector(
                  onTap: () {
                    _sendResult();
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) => MainChild()), (route) => false);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    //padding: EdgeInsets.symmetric(vertical:12,horizontal: 20),
                    height: SizeConfig.safeBlockVertical! * 17,
                    width: SizeConfig.safeBlockHorizontal! * 20.5,
                    decoration: BoxDecoration(
                        color: chYellow,
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeConfig.safeBlockVertical! * 5),
                        )),
                    child: Text(
                      "مشاركة",
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal! * 3,
                          fontFamily: 'ge_ss',
                          fontWeight: FontWeight.bold,
                          color: chBlue),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendResult() async {
    try {
      var request = MultipartRequest("POST", Uri.parse(Conn.childActivityURL));
      request.fields["title"] = 'نشاط العجلة الدوارة';
      request.fields["text"] = widget.message ?? '';
      request.fields["image_in_app"] = "assets/children/wheel_image.png";
      request.headers['Authorization'] = 'token ${Conn.token}';

      var response = await request.send();

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      // print(responseString);
      if (response.statusCode == 401) {
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
  }
}
