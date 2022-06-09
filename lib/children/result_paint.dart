import 'dart:io';

import 'package:async/async.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kau_app/children/main_bonus.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class ResultPaint extends StatefulWidget {
  final dynamic finalImage;

  const ResultPaint({Key? key, this.finalImage}) : super(key: key);

  @override
  _ResultPaintState createState() => _ResultPaintState();
}

class _ResultPaintState extends State<ResultPaint> {
  late VideoPlayerController _controller;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(widget.finalImage);
    _controller = VideoPlayerController.asset("assets/children/videos/resultPaint.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(false);
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });
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
                right: SizeConfig.safeBlockHorizontal! * 2,
                child: Container(
                  alignment: Alignment.topRight,
                  // height: SizeConfig.safeBlockVertical * 75,
                  //width: SizeConfig.safeBlockHorizontal *5,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => MainChild()));
                    },
                    child: Image.asset(
                      "assets/children/close_btn_5.png",
                      height: SizeConfig.safeBlockVertical! * 15,
                      width: SizeConfig.safeBlockHorizontal! * 10,
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: SizeConfig.safeBlockVertical! * 10,
                  left: SizeConfig.safeBlockVertical! * 10,
                  child: GestureDetector(
                    onTap: () {
                      sendImage();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => MainChild()));
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => MainBonus()));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      //padding: EdgeInsets.symmetric(vertical:12,horizontal: 20),
                      height: SizeConfig.safeBlockVertical! * 17,
                      width: SizeConfig.safeBlockHorizontal! * 20.5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(color: chBink, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              // offset: Offset(15,5),
                              offset: Offset(0, 5),
                              blurRadius: 5,
                              spreadRadius: 1,
                            )
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.safeBlockVertical! * 5),
                          )),
                      child: Text(
                        "ارسال للوالدين  ",
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal! * 3,
                            fontFamily: 'ge_ss',
                            fontWeight: FontWeight.bold,
                            color: chBlue),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  sendImage() async {
    try {
      // File file;
      final file = File('${(await getTemporaryDirectory()).path}/final_image.png');
      await file.writeAsBytes(widget.finalImage);

      var stream = new ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      //create multipart request for POST or PATCH method
      var request = MultipartRequest("POST", Uri.parse(Conn.childActivityURL));

      request.fields["title"] = 'نشاط تعرف عل';
      request.fields["text"] = 'تم انجاز نشاط تعرف على';
      request.headers['Authorization'] = 'token ${Conn.token}';

      //create multipart using filepath, string or bytes
      var pic = MultipartFile("image", stream, length, filename: "${DateTime.now()}.png");
      //add multipart to request
      request.files.add(pic);
      var response = await request.send();

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
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
