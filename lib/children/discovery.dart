import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kau_app/children/result_discovery.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/sizeConfig.dart';

import 'main_child.dart';

class Discovery extends StatefulWidget {
  final index;
  Discovery({Key? key, this.index}) : super(key: key);
  @override
  _DiscoveryState createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  int step = 1;

  //this list to store faces
  List<List<String>> faces = [
    [
      "sad_face.png",
      "scary_face.png",
      "tired_face.png",
      "happay_face.png",
    ],
    [
      "sad_face.png",
      "angry_face.png",
      "sick_face.png",
      "happay_face.png",
    ],
    [
      "sad_face.png",
      "angry_face.png",
      "sick_face.png",
      "happay_face.png",
    ],
    [
      "sad_face.png",
      "angry_face.png",
      "sick_face.png",
      "happay_face.png",
    ],
    [
      "sad_face.png",
      "angry_face.png",
      "tired_face.png",
      "happay_face.png",
    ],
    [
      "face_thinking.png",
      "angry_face.png",
      "sick_face.png",
      "happay_face.png",
    ],
    [
      "tired_face.png",
      "angry_face.png",
      "face_thinking.png",
      "happay_face.png",
    ],
    [
      "sad_face.png",
      "angry_face.png",
      "tired_face.png",
      "happay_face.png",
    ],
    [
      "sad_face.png",
      "angry_face.png",
      "sick_face.png",
      "happay_face.png",
    ],
    [
      "sad_face.png",
      "angry_face.png",
      "tired_face.png",
      "happay_face.png",
    ],
  ];

  //this list to store ans face
  List<String> ans_face = [
    "sad_face.png",
    "angry_face.png",
    "angry_face.png",
    "sad_face.png",
    "tired_face.png",
    "sick_face.png",
    "face_thinking.png",
    "tired_face.png",
    "sad_face.png",
    "happay_face.png"
  ];

  //this list to store qestion1
  List<String> qeastion1 = [
    "بماذا تشعر ماما؟",
    "بماذا تشعر ماما؟",
    "بماذا تشعر ماما؟",
    "بماذا تشعر أختك؟",
    "بماذا تشعر ماما؟",
    "بماذا يشعر بابا؟",
    "بماذا تشعر أختك؟",
    "بماذا تشعر ماما؟",
    "بماذا تشعر أختك؟",
    "بماذا تشعر ماما؟",
  ];

  //this list to store qestion2
  List<String> qeastion2 = [
    "لماذا تشعر ماما بالحزن؟",
    "لماذا تشعر ماما بالغضب؟",
    "لماذا تشعر ماما بالغضب؟",
    "لماذا تشعر أختك بالحزن؟",
    "لماذا تشعر ماما بالتعب؟",
    "لماذا يشعر بابا بالألم؟",
    "لماذا تشعر أختك بالحيرة؟",
    "لماذا تشعر ماما بالتعب؟",
    "لماذا تشعر أختك بالحزن؟",
    "لماذا تشعر ماما بالسعادة؟",
  ];

  //this list to store qestion3
  List<String> qeastion3 = [
    "كيف يمكنك مساعدة ماما؟",
    "كيف يمكنك مساعدة ماما؟",
    "كيف يمكنك مساعدة ماما؟",
    "كيف يمكنك مساعدة أختك؟",
    "كيف يمكنك مساعدة ماما؟",
    "كيف يمكنك مساعدة بابا؟",
    "كيف يمكنك مساعدة أختك؟",
    "كيف يمكنك مساعدة ماما؟",
    "كيف يمكنك مساعدة بابا؟",
    "كيف يمكنك مساعدة ماما؟",
  ];

  //this list to store helps
  List<List<String>> helps = [
    [
      "help_pic1.png",
      "help_pic2.png",
      "help_pic3.png",
      "help_pic4.png",
    ],
    [
      "help_pic1.png",
      "help_pic5.png",
      "help_pic3.png",
      "help_pic4.png",
    ],
    [
      "help_pic1.png",
      "help_pic5.png",
      "help_pic3.png",
      "help_pic4.png",
    ],
    [
      "help_pic1.png",
      "help_pic5.png",
      "help_pic3.png",
      "help_pic2.png",
    ],
    [
      "help_pic5.png",
      "help_pic6.png",
      "help_pic3.png",
      "help_pic2.png",
    ],
    [
      "help_pic6.png",
      "help_pic5.png",
      "help_pic3.png",
      "help_pic2.png",
    ],
    [
      "help_pic1.png",
      "help_pic5.png",
      "help_pic7.png",
      "help_pic2.png",
    ],
    [
      "help_pic11.png",
      "help_pic5.png",
      "help_pic8.png",
      "help_pic2.png",
    ],
    [
      "help_pic6.png",
      "help_pic5.png",
      "help_pic8.png",
      "help_pic2.png",
    ],
    [
      "help_pic10.png",
      "help_pic5.png",
      "help_pic8.png",
      "help_pic9.png",
    ],
  ];

  //this list to store ans help
  List<String> ans_help = [
    "help_pic1.png",
    "help_pic5.png",
    "help_pic4.png",
    "help_pic2.png",
    "help_pic6.png",
    "help_pic3.png",
    "help_pic7.png",
    "help_pic11.png",
    "help_pic8.png",
    "help_pic9.png",
  ];

  //this list to store final message
  List<String> message = [
    "ماما سعيدة أنت طفل رضي",
    "ماما سعيدة أنت طفل رضي",
    "ماما سعيدة أنت طفل رضي",
    "أختك سعيدة أنت أخ حنون",
    "ماما سعيدة أنت طفل رضي",
    "بابا يشعر بالتحسن ماأجملك أيتها الابنة الرضية",
    "أختك سعيدة أنت أخ حنون",
    "ماما سعيدة أنت طفل رضي",
    "أختك سعيدة أنت أخت حنونة",
    "ماما سعيدة أنتي طفلة رضية",
  ];

  //this for sounds
  AudioCache cache = AudioCache();
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
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
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              alignment:
                  step == 1 ? AlignmentDirectional.bottomEnd : AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image.asset(
                          "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                          height: SizeConfig.safeBlockVertical! * 17,
                          width: SizeConfig.safeBlockHorizontal! * 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            player.pause();
                            player = await cache.play(
                              'children/voices/discoveryVoice/${widget.index}_${(step)}.wav',
                            );
                          },
                          child: Image.asset(
                            "assets/children/voice_icon3.png",
                            height: SizeConfig.safeBlockVertical! * 17,
                            width: SizeConfig.safeBlockHorizontal! * 10,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Image.asset(
                            step == 5
                                ? "assets/children/discovery/images/discovery_ans_image${widget.index}.png"
                                : "assets/children/discovery/images/discovery_image${widget.index}.png",
                            height: SizeConfig.safeBlockVertical! * 95,
                            fit: BoxFit.fill,
                          ),
                          step == 3 ? answer()! : Container(),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "assets/children/close_btn_6.png",
                        height: SizeConfig.safeBlockVertical! * 17,
                        width: SizeConfig.safeBlockHorizontal! * 10,
                      ),
                    ),
                  ],
                ),
                stepWidget()!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? stepWidget() {
    if (step == 1) {
      player.stop();
      cache.play(
        'children/voices/discoveryVoice/${widget.index}_${(step)}.wav',
      );
      return Positioned(
        right: SizeConfig.safeBlockVertical! * 2,
        bottom: SizeConfig.safeBlockVertical! * 2,
        child: GestureDetector(
          onTap: () {
            setState(() {
              step = 2;
            });
          },
          child: Container(
            height: SizeConfig.safeBlockVertical! * 17,
            width: SizeConfig.safeBlockVertical! * 27,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: chBlue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 6))),
            child: Text(
              "ابدأ",
              style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical! * 9,
                  fontFamily: 'ge_ss',
                  fontWeight: FontWeight.bold,
                  color: chYellow),
            ),
          ),
        ),
      );
    } else if (step == 2) {
      player.stop();
      cache.play(
        'children/voices/discoveryVoice/${widget.index}_${(step)}.wav',
      );
      return Positioned(
        bottom: 10,
        child: Stack(
          children: <Widget>[
            Container(
              width: SizeConfig.safeBlockHorizontal! * 70,
              height: SizeConfig.safeBlockHorizontal! * 13,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 17)),
                border: Border.all(color: chBlue, width: SizeConfig.safeBlockHorizontal! * .3),
              ),
              //alignment: Alignment.centerRight,
            ),
            Container(
              width: SizeConfig.safeBlockHorizontal! * 50,
              height: SizeConfig.safeBlockHorizontal! * 13,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 15)),
                border: Border.all(color: chBlue, width: SizeConfig.safeBlockHorizontal! * .3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  for (int i = 0; i < faces[widget.index - 1].length; i++)
                    GestureDetector(
                      onTap: ans_face[widget.index - 1] == faces[widget.index - 1][i]
                          ? () {
                              setState(() {
                                // print("ans ${ans_face[widget.index - 1]}");
                                step = 3;
                              });
                            }
                          : null,
                      child: Image.asset(
                        "assets/children/discovery/faces/${faces[widget.index - 1][i]}",
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: SizeConfig.safeBlockVertical! * 5,
              child: Container(
                width: SizeConfig.safeBlockHorizontal! * 22,
                height: SizeConfig.safeBlockHorizontal! * 13,
                child: Text(
                  qeastion1[widget.index - 1],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockVertical! * 5.7,
                      fontFamily: 'ge_ss',
                      fontWeight: FontWeight.bold,
                      color: chBlue),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (step == 3) {
      player.stop();
      cache.play(
        'children/voices/discoveryVoice/${widget.index}_${(step)}.wav',
      );
      return Stack(
        children: <Widget>[
          Container(
            width: SizeConfig.safeBlockVertical! * 90,
            height: SizeConfig.safeBlockVertical! * 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 17)),
              border: Border.all(color: chBlue, width: SizeConfig.safeBlockHorizontal! * .3),
            ),
            //alignment: Alignment.centerRight,
          ),
          Container(
            width: SizeConfig.safeBlockVertical! * 40,
            height: SizeConfig.safeBlockVertical! * 20,
            padding: EdgeInsets.all(SizeConfig.safeBlockVertical! * 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 15)),
              border: Border.all(color: chBlue, width: SizeConfig.safeBlockHorizontal! * .3),
            ),
            child: Image.asset(
              "assets/children/finger_icon.png",
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: SizeConfig.safeBlockVertical! * 5,
            right: SizeConfig.safeBlockVertical! * 5,
            child: Container(
              width: SizeConfig.safeBlockHorizontal! * 25,
              height: SizeConfig.safeBlockVertical! * 20,
              child: Text(
                qeastion2[widget.index - 1],
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical! * 5,
                    fontFamily: 'ge_ss',
                    fontWeight: FontWeight.bold,
                    color: chBlue),
              ),
            ),
          ),
        ],
      );
    } else if (step == 4) {
      player.stop();
      cache.play(
        'children/voices/discoveryVoice/${widget.index}_${(step)}.wav',
      );
      return Positioned(
        bottom: 10,
        child: Stack(
          children: <Widget>[
            Container(
              width: SizeConfig.safeBlockHorizontal! * 70,
              height: SizeConfig.safeBlockHorizontal! * 13,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 17)),
                border: Border.all(color: chBlue, width: SizeConfig.safeBlockHorizontal! * .3),
              ),
            ),
            Container(
              width: SizeConfig.safeBlockHorizontal! * 50,
              height: SizeConfig.safeBlockHorizontal! * 13,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 15)),
                border: Border.all(color: chBlue, width: SizeConfig.safeBlockHorizontal! * .3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  for (int i = 0; i < helps[widget.index - 1].length; i++)
                    GestureDetector(
                      onTap: ans_help[widget.index - 1] == helps[widget.index - 1][i]
                          ? () {
                              setState(() {
                                // print("ans ${ans_help[widget.index - 1]}");
                                step = 5;
                              });
                            }
                          : null,
                      child: Image.asset(
                        "assets/children/discovery/help/${helps[widget.index - 1][i]}",
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: SizeConfig.safeBlockVertical! * 5.5,
              child: Container(
                width: SizeConfig.safeBlockHorizontal! * 20,
                height: SizeConfig.safeBlockHorizontal! * 13,
                child: Text(
                  qeastion3[widget.index - 1],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockVertical! * 4.5,
                      fontFamily: 'ge_ss',
                      fontWeight: FontWeight.bold,
                      color: chBlue),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (step == 5) {
      player.stop();
      cache.play(
        'children/voices/discoveryVoice/${widget.index}_${(step)}.wav',
      );
      return Positioned(
        bottom: 10,
        child: Stack(
          children: <Widget>[
            Container(
              width: SizeConfig.safeBlockVertical! * 90,
              height: SizeConfig.safeBlockVertical! * 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 17)),
                border: Border.all(color: chBlue, width: SizeConfig.safeBlockHorizontal! * .3),
              ),
            ),
            Container(
              width: SizeConfig.safeBlockVertical! * 40,
              height: SizeConfig.safeBlockVertical! * 20,
              padding: EdgeInsets.all(SizeConfig.safeBlockVertical! * 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 15)),
                border: Border.all(color: chBlue, width: SizeConfig.safeBlockHorizontal! * .3),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResultDiscovery(
                            imagePath:
                                'assets/children/discovery/images/discovery_ans_image${widget.index}.png')),
                  ).then((value) => null);
                },
                child: Image.asset(
                  "assets/children/star_icon.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: SizeConfig.safeBlockVertical! * 3,
              right: SizeConfig.safeBlockVertical! * 6,
              child: Container(
                width: SizeConfig.safeBlockVertical! * 40,
                height: SizeConfig.safeBlockVertical! * 20,
                child: Text(
                  message[widget.index - 1],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockVertical! * 4.4,
                      fontFamily: 'ge_ss',
                      fontWeight: FontWeight.bold,
                      color: chBlue),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return null;
  }

  Widget? answer() {
    if (widget.index == 1) {
      return Positioned(
        left: SizeConfig.safeBlockHorizontal! * 12,
        top: SizeConfig.safeBlockVertical! * 55,
        child: GestureDetector(
          onTap: () {
            setState(() {
              step = 4;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical! * 10,
            width: SizeConfig.safeBlockHorizontal! * 10,
          ),
        ),
      );
    } else if (widget.index == 2) {
      return Positioned(
        left: SizeConfig.safeBlockHorizontal! * 4,
        top: SizeConfig.safeBlockVertical! * 55,
        child: GestureDetector(
          onTap: () {
            setState(() {
              step = 4;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical! * 16,
            width: SizeConfig.safeBlockHorizontal! * 50,
          ),
        ),
      );
    } else if (widget.index == 3) {
      return Positioned(
        left: SizeConfig.safeBlockHorizontal! * 23,
        top: SizeConfig.safeBlockVertical! * 60,
        child: GestureDetector(
          onTap: () {
            setState(() {
              step = 4;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical! * 12,
            width: SizeConfig.safeBlockHorizontal! * 14,
          ),
        ),
      );
    } else if (widget.index == 4) {
      return Positioned(
        right: SizeConfig.safeBlockHorizontal! * 21,
        top: SizeConfig.safeBlockVertical! * 60,
        child: GestureDetector(
          onTap: () {
            setState(() {
              step = 4;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical! * 10,
            width: SizeConfig.safeBlockHorizontal! * 6,
          ),
        ),
      );
    } else if (widget.index == 5) {
      return Positioned(
        left: SizeConfig.safeBlockHorizontal! * 15,
        bottom: SizeConfig.safeBlockVertical! * 25,
        child: GestureDetector(
          onTap: () {
            setState(() {
              step = 4;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical! * 25,
            width: SizeConfig.safeBlockHorizontal! * 10,
          ),
        ),
      );
    } else if (widget.index == 6) {
      return Positioned(
        right: SizeConfig.safeBlockHorizontal! * 30,
        top: SizeConfig.safeBlockVertical! * 20,
        child: GestureDetector(
          onTap: () {
            setState(() {
              step = 4;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical! * 5,
            width: SizeConfig.safeBlockHorizontal! * 3,
          ),
        ),
      );
    } else if (widget.index == 7) {
      return Positioned(
        right: SizeConfig.safeBlockHorizontal! * 22,
        top: SizeConfig.safeBlockVertical! * 38,
        child: GestureDetector(
          onTap: () {
            setState(() {
              step = 4;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical! * 10,
            width: SizeConfig.safeBlockHorizontal! * 5,
          ),
        ),
      );
    } else if (widget.index == 8) {
      return Positioned(
        right: SizeConfig.safeBlockHorizontal! * 28,
        top: SizeConfig.safeBlockVertical! * 22,
        child: GestureDetector(
          onTap: () {
            setState(() {
              step = 4;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical! * 11,
            width: SizeConfig.safeBlockHorizontal! * 11,
          ),
        ),
      );
    } else if (widget.index == 9) {
      return Positioned(
        right: SizeConfig.safeBlockHorizontal! * 27,
        bottom: SizeConfig.safeBlockVertical! * 38,
        child: GestureDetector(
          onTap: () {
            setState(() {
              step = 4;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical! * 7,
            width: SizeConfig.safeBlockHorizontal! * 5,
          ),
        ),
      );
    } else if (widget.index == 10) {
      return Positioned(
        left: SizeConfig.safeBlockHorizontal! * 32,
        bottom: SizeConfig.safeBlockVertical! * 45,
        child: GestureDetector(
          onTap: () {
            setState(() {
              step = 4;
            });
          },
          child: Container(
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical! * 10,
            width: SizeConfig.safeBlockHorizontal! * 7,
          ),
        ),
      );
    }
    return null;
  }
}
