import 'package:flutter/material.dart';
import 'package:kau_app/children/main_bonus.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/children/details_task.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:video_player/video_player.dart';

class ResultTasks extends StatefulWidget {
  int? score;
  ResultTasks({this.score});
  @override
  _ResultTasksState createState() => _ResultTasksState();
}

class _ResultTasksState extends State<ResultTasks> {
  late VideoPlayerController _controller;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    print('enterd result tasks');
    super.initState();
    _controller = VideoPlayerController.asset("assets/children/videos/resultTask.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        print('play');
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/children/tasks_background.png"),
            fit: BoxFit.cover,
          ),
        ),
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
                  //height: SizeConfig.safeBlockVertical * 75,
                  //width: SizeConfig.safeBlockHorizontal *5,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/children/close.png",
                      height: SizeConfig.safeBlockVertical! * 10,
                      width: SizeConfig.safeBlockHorizontal! * 5,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainBonus()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                  child: Stack(
                    //alignment: AlignmentDirectional.center,

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
                          '${widget.score}',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical! * 8,
                              fontFamily: 'a-massir-ballpoint',
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
