import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kau_app/children/send_message.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:video_player/video_player.dart';

class ChildUserInfo {
  static Map? child;
}

class StoryPlayer extends StatefulWidget {
  Map? story;

  StoryPlayer({this.story});

  @override
  _StoryPlayerState createState() => _StoryPlayerState();
}

class _StoryPlayerState extends State<StoryPlayer> {
  List<Map>? filesList;
  List<Map>? stickerList;
  int index = 0;
  bool isPlaying = false;

  Future<String> loadData() async {
    // await Future.delayed(Duration(seconds: 5));
    try {
      filesList = [];
      stickerList = [];
      // filesLest = widget.story['files'];
      for (int i = 0; i < widget.story!['files'].length; i++) {
        if (widget.story!['files'][i]["type"] == "Page") {
          filesList!.add(widget.story!['files'][i]);
        } else if (widget.story!['files'][i]["type"] == "Sticker") {
          stickerList!.add(widget.story!['files'][i]);
        }
      }
      print(filesList!.length);

      return "done";
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
      return '';
    } catch (e) {
      print(e);
    }
    return "ConnectionError";
  }

  VideoPlayerController? _controller;
  AudioPlayer audioPlayer = AudioPlayer();

  _playOutput(url) async {
    if (!url.toString().contains("/")) {
      return 0;
    }
    print(Conn.serverURL + url);
    audioPlayer.stop();
    int result = await audioPlayer.play(Conn.serverURL + url);
    while (audioPlayer.state == PlayerState.PLAYING) {
      await Future.delayed(Duration(seconds: 1));
      print(
          "audioPlayer.state***************************************************************************************************** ${audioPlayer.state}");
    }
    return result;
  }

  _playStory() async {
    for (index; index < filesList!.length - 1 && isPlaying; index++) {
      int isAudio = await _playOutput(filesList![index]['voice']);
      if (isAudio == 0) {
        isPlaying = false;
        index--;
        break;
      }
      setState(() {});
    }
  }

  _pauseOutput() async {
    await audioPlayer.pause();
  }

  _resumeOutput() async {
    await audioPlayer.resume();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.asset("assets/children/loading_child.mp4")
          ..initialize().then((_) {
            // Once the video has been loaded we play the video and set looping to true.
            _controller!.play();
            _controller!.setLooping(true);
            // Ensure the first frame is shown after the video is initialized.
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return FutureBuilder(
      future: loadData(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget returnWidget;

        if (snapshot.data == 'done') {
          returnWidget = Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Color(0xff345995),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                "assets/children/story/story_close_btn.png",
                                height: SizeConfig.safeBlockVertical! * 15,
                                width: SizeConfig.safeBlockHorizontal! * 15,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _playOutput(filesList![index]['voice']);
                              },
                              child: Image.asset(
                                "assets/children/story/story_voice_btn.png",
                                height: SizeConfig.safeBlockVertical! * 15,
                                width: SizeConfig.safeBlockHorizontal! * 15,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                index++;
                                _playOutput(filesList![index]['voice']);
                                setState(() {
                                  index = index % filesList!.length;
                                });
                              },
                              child: Image.asset(
                                "assets/children/story/story_next_btn.png",
                                height: SizeConfig.safeBlockVertical! * 15,
                                width: SizeConfig.safeBlockHorizontal! * 15,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                isPlaying = true;
                                _playStory();
                              },
                              child: Image.asset(
                                "assets/children/story/story_play_btn.png",
                                height: SizeConfig.safeBlockVertical! * 15,
                                width: SizeConfig.safeBlockHorizontal! * 15,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                audioPlayer.stop();
                                isPlaying = false;
                              },
                              child: Image.asset(
                                "assets/children/story/story_pause_btn.png",
                                height: SizeConfig.safeBlockVertical! * 15,
                                width: SizeConfig.safeBlockHorizontal! * 15,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                index--;
                                _playOutput(filesList![index]['voice']);
                                setState(() {
                                  index = index % filesList!.length;
                                });
                              },
                              child: Image.asset(
                                "assets/children/story/story_back_btn.png",
                                height: SizeConfig.safeBlockVertical! * 15,
                                width: SizeConfig.safeBlockHorizontal! * 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 90,
                          child: Stack(
                            children: <Widget>[
                              // CachedNetworkImage(
                              //   imageUrl: Conn.serverURL + filesList[index]["image"],
                              //   placeholder: (context, url) => CircularProgressIndicator(),
                              //   errorWidget: (context, url, error) => Icon(Icons.error),
                              // ),
                              Image.network(
                                Conn.serverURL + filesList![index]["image"],
                              ),
                              filesList![index]["is_send_page"]
                                  ? Positioned(
                                      top: SizeConfig.safeBlockVertical! * 25,
                                      left: SizeConfig.safeBlockVertical! * 50,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/children/story/story_end_bg.png",
                                            height: 250,
                                            width: 500,
                                          ),
                                          cardWidget(
                                              chBlue,
                                              chOrange,
                                              "assets/children/message_icon.png",
                                              "ارسال للوالدين", () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      sendMessage(
                                                        stickers: stickerList!,
                                                        isFromStory: true,
                                                      )),
                                            );
                                          }),
                                        ],
                                      ))
                                  : Container(),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          returnWidget = Scaffold(
            body: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          );
        }
        return returnWidget;
      },
    );
  }

  Widget cardWidget(firstColor, secColor, image, title, onTap, {notfication}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: <Widget>[
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: SizeConfig.safeBlockVertical! * 46,
              width: SizeConfig.safeBlockHorizontal! * 20.5,
              child: Card(
                color: firstColor,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset(
                      image,
                      fit: BoxFit.fill,
                      height: SizeConfig.safeBlockVertical! * 40,
                      width: SizeConfig.safeBlockHorizontal! * 18,
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(child: SizedBox()),
                        Container(
                          height: SizeConfig.safeBlockVertical! * 8,
                          width: SizeConfig.safeBlockHorizontal! * 12,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: secColor,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SizeConfig.safeBlockVertical! * 20))),
                          child: Text(
                            "${title}",
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical! * 3.5,
                                fontFamily: 'ge_ss',
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 4,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          notfication?.isEmpty ?? true
              ? Container()
              : Positioned(
                  right: -SizeConfig.safeBlockHorizontal! * .5,
                  child: Container(
                    height: SizeConfig.safeBlockVertical! * 10,
                    width: SizeConfig.safeBlockHorizontal! * 7,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: chBink,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${notfication}',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical! * 6,
                          fontFamily: 'ge_ss',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
