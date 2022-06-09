import 'package:flutter/material.dart';
import 'package:kau_app/children/internal_tasks.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'library_videos.dart';
import 'library_stories.dart';

class MainLibrary extends StatefulWidget {
  @override
  _MainLibraryState createState() => _MainLibraryState();
}

class _MainLibraryState extends State<MainLibrary> {
  int? health;
  int? behavior;
  int? home;
  int? other;

  @override
  void initState() {
    health = 0;
    behavior = 0;
    home = 0;
    other = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 10,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: <Widget>[
                            Image.asset(
                              "assets/children/lib_title.png",
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20, top: 5),
                              child: Text(
                                'المكتبة',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal! * 3,
                                    fontFamily: 'ge_ss',
                                    fontWeight: FontWeight.bold,
                                    color: chBlue),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        "assets/children/back_icon.png",
                        height: SizeConfig.safeBlockVertical! * 10,
                        width: SizeConfig.safeBlockHorizontal! * 7,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return MainVideos();
                          }),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        height: SizeConfig.safeBlockVertical! * 45,
                        width: SizeConfig.safeBlockHorizontal! * 23,
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  "assets/children/lib_video_icon.png",
                                  fit: BoxFit.fill,
                                  height: SizeConfig.safeBlockVertical! * 29,
                                  width: SizeConfig.safeBlockHorizontal! * 17,
                                ),
                                SizedBox(
                                  height: SizeConfig.safeBlockVertical! * 2,
                                ),
                                Text(
                                  'الفيديو',
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.safeBlockVertical! * 4,
                                      fontFamily: 'ge_ss',
                                      fontWeight: FontWeight.bold,
                                      color: chBlue),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return MainStories();
                          }),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        height: SizeConfig.safeBlockVertical! * 45,
                        width: SizeConfig.safeBlockHorizontal! * 23,
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  "assets/children/lib_story_icon.png",
                                  fit: BoxFit.fill,
                                  height: SizeConfig.safeBlockVertical! * 29,
                                  width: SizeConfig.safeBlockHorizontal! * 17,
                                ),
                                SizedBox(
                                  height: SizeConfig.safeBlockVertical! * 2,
                                ),
                                Text(
                                  'القصص',
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.safeBlockVertical! * 4,
                                      fontFamily: 'ge_ss',
                                      fontWeight: FontWeight.bold,
                                      color: chBlue),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget taskWidgets(String title, String image, String notification) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topRight,
      children: <Widget>[
        InkWell(
          onTap: () {
            // print(TasksData.tasks[title]);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InternalTasks(
                        type_task: title,
                      )),
            ).then((value) {
              setState(() {});
            });
          },
          child: Container(
            height: SizeConfig.safeBlockVertical! * 45,
            width: SizeConfig.safeBlockHorizontal! * 23,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      image,
                      fit: BoxFit.fill,
                      height: SizeConfig.safeBlockVertical! * 29,
                      width: SizeConfig.safeBlockHorizontal! * 17,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 2,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical! * 4,
                          fontFamily: 'ge_ss',
                          fontWeight: FontWeight.bold,
                          color: chBlue),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        notification != '0'
            ? Positioned(
                top: -SizeConfig.safeBlockVertical! * 2,
                right: -SizeConfig.safeBlockHorizontal! * .5,
                child: Container(
                  height: SizeConfig.safeBlockVertical! * 8,
                  width: SizeConfig.safeBlockHorizontal! * 6,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: chYellow,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    notification,
                    style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical! * 5,
                        fontFamily: 'ge_ss',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
