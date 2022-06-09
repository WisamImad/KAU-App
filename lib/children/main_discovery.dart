import 'package:flutter/material.dart';
import 'package:kau_app/children/discovery.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/sizeConfig.dart';

import 'main_child.dart';

class MainDiscovery extends StatefulWidget {
  @override
  _MainDiscoveryState createState() => _MainDiscoveryState();
}

class _MainDiscoveryState extends State<MainDiscovery> {
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                      height: SizeConfig.safeBlockVertical! * 17,
                      width: SizeConfig.safeBlockHorizontal! * 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Image.asset(
                        "assets/children/home_icon3.png",
                        height: SizeConfig.safeBlockVertical! * 17,
                        width: SizeConfig.safeBlockHorizontal! * 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 10,
                ),
                Container(
                  height: SizeConfig.safeBlockVertical! * 60,
                  width: SizeConfig.safeBlockHorizontal! * 80,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 5,
                      crossAxisSpacing: SizeConfig.safeBlockHorizontal! * 3,
                      mainAxisSpacing: SizeConfig.safeBlockVertical! * 2.5,
                      children: <Widget>[
                        for (int i = 1;
                            i <= 10;
                            i++) //display the num of bonus inside the jar
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Discovery(
                                          index: i,
                                        )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/children/paint_box.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${i}',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockVertical! * 20,
                                    fontFamily: 'ge_ss',
                                    height: 1,
                                    color: chBlue),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
