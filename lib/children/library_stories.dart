import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kau_app/children/story.dart';
import 'package:kau_app/children/video_player.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_data.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:video_player/video_player.dart';

class ChildUserInfo {
  static Map? child;
}

class MainStories extends StatefulWidget {
  @override
  _MainStoriesState createState() => _MainStoriesState();
}

class _MainStoriesState extends State<MainStories> {
  List? storyList;

  Future<String> loadData() async {
    try {
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      final dailyParams = {
        "task_id": "all",
      };
      final uri = Uri.https(Conn.url, "/app/api/children_stories");
      final uarReplaced = uri.replace(queryParameters: dailyParams);
      var videosResponse = await get(uarReplaced, headers: userHeader);
      // print(dailyTaskResponse.body);
      var videosMap = jsonDecode(utf8.decode(videosResponse.bodyBytes));
      // print('entered');
      // print(dailyTasksMap);
      if (videosResponse.statusCode == 200) {
        storyList = videosMap;

        if (storyList!.length == 0) {
          storyList;
        }
        Data.videosList = storyList;
        // setState(() {});
        return 'done';
      } else if (videosResponse.statusCode == 401) {
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
        return 'done';
      } else {
        return "UnknownError";
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
    }
    return "ConnectionError";
  }

  late VideoPlayerController _controller;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset("assets/children/loading_child.mp4")
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
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget returnWidget;

        if (snapshot.data == 'done') {
          returnWidget = SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/children/library_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            "assets/children/back_icon.png",
                            height: SizeConfig.safeBlockVertical! * 10,
                            width: SizeConfig.safeBlockHorizontal! * 7,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 15,
                      ),
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: storyList != null
                                ? storyList!.map((story) {
                                    return cardWidget(story);
                                  }).toList()
                                : [],
                          ),
                        ),
                      )
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

  Widget cardWidget(story) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(
        // overflow: Overflow.visible,
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (story['files'].length > 0)
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StoryPlayer(story: story)));
            },
            child: Container(
              height: SizeConfig.safeBlockVertical! * 46,
              width: SizeConfig.safeBlockHorizontal! * 20.5,
              child: Column(
                children: <Widget>[
                  Container(
                    height: SizeConfig.safeBlockVertical! * 40,
                    width: SizeConfig.safeBlockHorizontal! * 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.network(
                        Conn.serverURL + story['icon_image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "${story["name"]}",
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical! * 4.5,
                          fontFamily: 'ge_ss',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
