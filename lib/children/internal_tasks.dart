import 'package:flutter/material.dart';
import 'package:kau_app/children/details_task.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/sizeConfig.dart';

import 'main_child.dart';
import 'main_tasks.dart';

class InternalTasks extends StatefulWidget {
  final String? type_task;

  const InternalTasks({Key? key, this.type_task}) : super(key: key);

  @override
  _InternalTasksState createState() => _InternalTasksState();
}

class _InternalTasksState extends State<InternalTasks> {
  String image = "";

  @override
  void dispose() {
    TasksData.loadData();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // print(widget.type_task);
    switch (widget.type_task) {
      case 'مهام اخرى':
        image = "assets/children/other_task.png";
        break;
      case 'مهام منزلية':
        image = "assets/children/home_task.png";
        break;
      case 'مهام سلوكية':
        image = "assets/children/behavior_task.png";
        break;
      case 'مهام صحية':
        image = "assets/children/health_task.png";
        break;
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                      height: SizeConfig.safeBlockVertical! * 17,
                      width: SizeConfig.safeBlockHorizontal! * 10,
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 1,
                    ),
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
                              "assets/children/title_pic.png",
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20, top: 5),
                              child: Text(
                                'مهام الإبن الرضي',
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
                        Navigator.pop(context, true);
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
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 40,
                  width: SizeConfig.safeBlockHorizontal! * 100,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView.builder(
                      itemCount:
                          TasksData.tasks[widget.type_task]['tasks'].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            onTap: () {
                              // print("nav to deatails of task");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailTask(
                                          title: widget.type_task,
                                          index: index,
                                        )),
                              ).then((value) async {
                                await TasksData.loadData();
                                setState(() {});
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig.safeBlockVertical! * 8)),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    image,
                                    height: SizeConfig.safeBlockVertical! * 20,
                                    width: SizeConfig.safeBlockHorizontal! * 20,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.safeBlockVertical! * 1,
                                  ),
                                  Text(
                                    "مهمة ${index + 1} ",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.safeBlockVertical! * 5,
                                        fontFamily: 'ge_ss',
                                        fontWeight: FontWeight.bold,
                                        color: chBlue),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
}
