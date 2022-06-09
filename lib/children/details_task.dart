import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kau_app/children/result_tasks.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:video_player/video_player.dart';

import 'main_tasks.dart';

class DetailTask extends StatefulWidget {
  String? title;
  int? index;

  DetailTask({this.title, this.index});

  @override
  _DetailTaskState createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> with TickerProviderStateMixin {
  String status = "details";
  // String status  = 'finish_timer';
  late double percentage;
  late Animation<double> animation;
  double _progress = 0.0;
  var controller;
  late Duration duration1;
  late VideoPlayerController _controller;
  @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.asset("assets/children/videos/endTime.mp4")
  //     ..initialize().then((_) {
  //       // Once the video has been loaded we play the video and set looping to true.
  //       _controller.play();
  //       _controller.setLooping(false);
  //       // Ensure the first frame is shown after the video is initialized.
  //       setState(() {});
  //     });
  // }

  @override
  void dispose() {
    if (status == 'start_timer') {
      controller.stop();
      controller.dispose();
    }
    _controller.dispose();

    super.dispose();
  }

  void startTimer() {
    controller = AnimationController(
      duration: duration1,
      vsync: this,
    );

    animation = Tween(begin: percentage, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
        if (animation.isCompleted) {
          status = "finish_timer";
        }

        _progress = animation.value;
      });
    controller.forward();
  }

  String get timerString {
    Duration duration = (controller.duration * controller.value);
    return '${duration1.inMinutes - duration.inMinutes}:${(((duration1.inSeconds % 60) - (duration.inSeconds % 60)).toString().padLeft(2, '0'))}';
  }

  @override
  void initState() {
    _controller = VideoPlayerController.asset("assets/children/videos/endTime.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        status == 'finish_timer' ? _controller.play() : _controller.pause();
        _controller.setLooping(false);
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });
    final DateTime now = DateTime.now();
    final intl.DateFormat dateFormatter = intl.DateFormat('yyyy-MM-dd');
    String startTimeString = TasksData.tasks[widget.title]['tasks'][widget.index]['time'];
    List endTimeList = TasksData.tasks[widget.title]['tasks'][widget.index]['duration'].split(':');
    Duration endDuration = Duration(
        hours: int.parse(endTimeList[0]),
        minutes: int.parse(endTimeList[1]),
        seconds: int.parse(endTimeList[2]));
    DateTime startDateTime = DateTime.parse('${dateFormatter.format(now)} ' + startTimeString);
    DateTime endDateTime = startDateTime.add(endDuration);
    duration1 = endDuration - now.difference(startDateTime);
    percentage = ((endDuration.inSeconds - now.difference(startDateTime).inSeconds) /
            endDuration.inSeconds *
            100) /
        100;

    print(percentage);

    super.initState();
    if (duration1.inSeconds <= 0) {
      status = 'finish_timer';
    } else if (TasksData.tasks[widget.title]['tasks'][widget.index]['status'] == 2) {
      status = "start_timer";
      startTimer();
    }
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
          body: status == "finish_timer"
              ? Stack(
                  children: <Widget>[
                    SizedBox(
                        height: SizeConfig.safeBlockVertical! * 100,
                        width: SizeConfig.safeBlockHorizontal! * 100,
                        child: VideoPlayer(_controller)),
                    Positioned(
                      top: SizeConfig.safeBlockVertical! * 5,
                      left: SizeConfig.safeBlockHorizontal! * 1,
                      child: Image.asset(
                        //"assets/children/child_avatar${ChildUserInfo.child['image_in_app']}.png",
                        "assets/children/child_avatar1.png",
                        height: SizeConfig.safeBlockVertical! * 17,
                        width: SizeConfig.safeBlockHorizontal! * 10,
                      ),
                    ),
                    Positioned(
                      top: SizeConfig.safeBlockVertical! * 7,
                      right: SizeConfig.safeBlockHorizontal! * 4,
                      child: InkWell(
                        onTap: () {
                          dialogWidget(context);
                        },
                        child: Image.asset(
                          "assets/children/close.png",
                          height: SizeConfig.safeBlockVertical! * 10,
                          width: SizeConfig.safeBlockHorizontal! * 4,
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            //"assets/children/child_avatar${ChildUserInfo.child['image_in_app']}.png",
                            "assets/children/child_avatar1.png",
                            height: SizeConfig.safeBlockVertical! * 17,
                            width: SizeConfig.safeBlockHorizontal! * 10,
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: SizeConfig.safeBlockVertical! * 4,
                              ),
                              Container(
                                  height: SizeConfig.safeBlockVertical! * 80,
                                  width: SizeConfig.safeBlockHorizontal! * 76,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/children/details_task_border.png"),
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
                                              'مهامي',
                                              style: TextStyle(
                                                  fontSize: SizeConfig.safeBlockVertical! * 6,
                                                  fontFamily: 'ge_ss',
                                                  fontWeight: FontWeight.bold,
                                                  color: chBlue),
                                            ),
                                          )
                                        ],
                                      ),
                                      statusWidget(),
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: SizeConfig.safeBlockHorizontal! * 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                dialogWidget(context);
                              },
                              child: Image.asset(
                                "assets/children/close.png",
                                height: SizeConfig.safeBlockVertical! * 10,
                                width: SizeConfig.safeBlockHorizontal! * 4,
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
    );
  }

  void dialogWidget(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical! * 10),
            ),
            child: Container(
              height: SizeConfig.safeBlockVertical! * 55,
              width: SizeConfig.safeBlockHorizontal! * 55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "تأكيد اغلاق الصفحة؟",
                    style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical! * 8,
                        fontFamily: 'ge_ss',
                        fontWeight: FontWeight.bold,
                        color: chBlue),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical! * 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal! * 16,
                        height: SizeConfig.safeBlockVertical! * 11.5,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.safeBlockVertical! * 10),
                              side: BorderSide(color: Colors.black)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "الغاء",
                            style: TextStyle(
                              color: chBlue,
                              fontFamily: 'ge_ss',
                              fontSize: SizeConfig.safeBlockVertical! * 6,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.safeBlockVertical! * 5,
                      ),
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal! * 16,
                        height: SizeConfig.safeBlockVertical! * 11.5,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical! * 10),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "موافق",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'ge_ss',
                              fontSize: SizeConfig.safeBlockVertical! * 6,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: chYellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void changeStatus() async {
    // print(status);
    try {
      String? toStatus;
      if (status == 'details') {
        toStatus = '1';
      } else if (status == 'start_timer') {
        toStatus = '2';
      } else if (status == 'done') {
        toStatus = '3';
      }
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      Map<String, String> data = {
        'task_id': "${TasksData.tasks[widget.title]['tasks'][widget.index]['id']}",
        'status_id': toStatus!
      };
      var taskResponse = await put(Uri.parse(Conn.tasksChildURL), headers: userHeader, body: data);
      if (taskResponse.statusCode == 200) {
        // print('done');
      } else if (taskResponse.statusCode == 401) {
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

  Widget statusWidget() {
    if (status == "details") {
      return SizedBox(
        height: SizeConfig.safeBlockVertical! * 55,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Container(
                height: SizeConfig.safeBlockVertical! * 9,
                width: SizeConfig.safeBlockHorizontal! * 12,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 5)),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  'ابدأ',
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockVertical! * 5,
                      fontFamily: 'ge_ss',
                      fontWeight: FontWeight.bold,
                      color: chBlue),
                ),
              ),
              onTap: () {
                setState(() {
                  status = "start_timer";
                  startTimer();
                });
                changeStatus();
              },
            ),
            SizedBox(
              width: SizeConfig.safeBlockHorizontal! * .5,
            ),
            Column(
              children: <Widget>[
                Container(
                  height: SizeConfig.safeBlockVertical! * 50,
                  width: SizeConfig.safeBlockHorizontal! * 35,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/children/border.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 12,
                      ),
                      Text(
                        '${TasksData.tasks[widget.title]['tasks'][widget.index]['name']}',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical! * 5,
                            fontFamily: 'ge_ss',
                            fontWeight: FontWeight.bold,
                            color: chDarkBink),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 5,
                      ),
                      Text(
                        'الوقت: ${TasksData.tasks[widget.title]['tasks'][widget.index]['time']}  صباحاً',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical! * 4.7,
                            fontFamily: 'ge_ss',
                            fontWeight: FontWeight.bold,
                            color: chBlue),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 1,
                      ),
                      Text(
                        'المدة: ${TasksData.tasks[widget.title]['tasks'][widget.index]['duration']} دقيقة',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical! * 4.7,
                            fontFamily: 'ge_ss',
                            fontWeight: FontWeight.bold,
                            color: chBlue),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Image.asset(
                          "assets/children/voice_icon.png",
                          height: SizeConfig.safeBlockVertical! * 7,
                          width: SizeConfig.safeBlockHorizontal! * 7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: SizeConfig.safeBlockHorizontal! * 3,
            ),
            Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 5)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: Image.asset(
                    "assets/children/other_task.png",
                    height: SizeConfig.safeBlockVertical! * 27,
                    width: SizeConfig.safeBlockHorizontal! * 17,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 2,
                ),
                Stack(
                  children: <Widget>[
                    Image.asset(
                      "assets/children/score_icon.png",
                      height: SizeConfig.safeBlockVertical! * 12.5,
                      width: SizeConfig.safeBlockHorizontal! * 19,
                    ),
                    Positioned(
                      top: -SizeConfig.safeBlockVertical! * 4,
                      right: SizeConfig.safeBlockVertical! * 8,
                      child: Text(
                        '${TasksData.tasks[widget.title]['tasks'][widget.index]['score']}',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical! * 8,
                            fontFamily: 'a-massir-ballpoint',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 3,
                ),
              ],
            ),
            SizedBox(width: SizeConfig.safeBlockVertical! * 8),
          ],
        ),
      );
    } else if (status == "start_timer") {
      return SizedBox(
        height: SizeConfig.safeBlockVertical! * 55,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Container(
                height: SizeConfig.safeBlockVertical! * 9,
                width: SizeConfig.safeBlockHorizontal! * 12,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(SizeConfig.safeBlockVertical! * 5)),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  'تم',
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockVertical! * 5,
                      fontFamily: 'ge_ss',
                      fontWeight: FontWeight.bold,
                      color: chBlue),
                ),
              ),
              onTap: () {
                status = 'done';
                changeStatus();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ResultTasks(
                          score: TasksData.tasks[widget.title]['tasks'][widget.index]['score'],
                        )));
              },
            ),
            SizedBox(
              width: SizeConfig.safeBlockHorizontal! * 7,
            ),
            Column(
              children: <Widget>[
                Container(
                  height: SizeConfig.safeBlockVertical! * 50,
                  width: SizeConfig.safeBlockHorizontal! * 35,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/children/border.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: chBink,
                          border: Border.all(color: Colors.black87),
                        ),
                        height: SizeConfig.safeBlockVertical! * 7.5,
                        width: SizeConfig.safeBlockHorizontal! * 30,
                        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical! * 3.6),
                        child: CustomPaint(painter: LinePainter(_progress)),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 3,
                      ),
                      Container(
                        height: SizeConfig.safeBlockVertical! * 18,
                        width: SizeConfig.safeBlockHorizontal! * 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  SizeConfig.safeBlockVertical! *
                                      5) //                 <--- border radius here
                              ),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${timerString}',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical! * 19,
                              fontFamily: 'a-massir-ballpoint',
                              height: 1,
                              fontWeight: FontWeight.bold,
                              color: chBlue),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 4,
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: SizeConfig.safeBlockHorizontal! * 16,
            ),
          ],
        ),
      );
    } else
      return Container();
  }
}

class LinePainter extends CustomPainter {
  Paint? _paint;
  double? _progress;

  LinePainter(this._progress) {
    _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = SizeConfig.safeBlockVertical! * 7.3;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
        Offset(0.0, 0.0), Offset(size.width - size.width * _progress!, 0 * _progress!), _paint!);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate._progress != _progress;
  }
}
