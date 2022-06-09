import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kau_app/children/paint.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/sizeConfig.dart';

import 'main_child.dart';

class MainPaint extends StatefulWidget {
  static const routeName = "/main_paint";
  @override
  _MainPaintState createState() => _MainPaintState();
}

class _MainPaintState extends State<MainPaint> {
  List<String> family_image = [
    "assets/children/father_paint.png",
    "assets/children/mother_paint.png",
    "assets/children/grand_father_paint.png",
    "assets/children/grand_mother_paint.png",
    "assets/children/boy_paint.png",
    "assets/children/girl_paint.png",
  ];

  int? is_choose;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: chOrange,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Image.asset(
                      "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                      height: SizeConfig.safeBlockVertical! * 17,
                      width: SizeConfig.safeBlockHorizontal! * 10,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    //padding: EdgeInsets.symmetric(vertical:12,horizontal: 20),
                    height: SizeConfig.safeBlockVertical! * 15,
                    width: SizeConfig.safeBlockHorizontal! * 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: chBink, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(10, 5),
                            blurRadius: 7,
                            spreadRadius: 2,
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeConfig.safeBlockVertical! * 6),
                        )),
                    child: Text(
                      "اختار الشخصية المفضلة",
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical! * 6.5,
                          fontFamily: 'ge_ss',
                          fontWeight: FontWeight.bold,
                          color: chBlue),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Image.asset(
                      "assets/children/home_icon2.png",
                      height: SizeConfig.safeBlockVertical! * 17,
                      width: SizeConfig.safeBlockHorizontal! * 10,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 12,
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 40,
                width: SizeConfig.safeBlockHorizontal! * 100,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView.builder(
                    itemCount: family_image.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctxt, int index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            is_choose = index;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PaintPage(image: family_image[index])),
                          );
                        },
                        child: Container(
                          height: SizeConfig.safeBlockVertical! * 40,
                          width: SizeConfig.safeBlockVertical! * 42,
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: is_choose == index ? chBink : chYellow,
                                width: SizeConfig.safeBlockHorizontal! * 1.3),
                            borderRadius: BorderRadius.all(Radius.circular(
                                SizeConfig.safeBlockVertical! * 19)),
                          ),
                          child: Image.asset(
                            family_image[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
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
}
