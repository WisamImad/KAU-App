import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/children_app_theme.dart';

class PaintMePage extends StatefulWidget {
  @override
  _PaintMePageState createState() => _PaintMePageState();
}

class _PaintMePageState extends State<PaintMePage> {
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/children/paint_me_background.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: height! / 10,
                        width: height! / 10,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/children/child_default_avatar.png'),
                        ),
                      ),
                      Container(
                        width: width! / 2.5,
                        height: height! / 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            width: 2,
                            color: Colors.red[700]!,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[700]!.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(6, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                            child: Text(
                          'إختر الشخصية المفضلة',
                          style: TextStyle(
                              fontFamily: fontHiding2,
                              color: chBlue,
                              fontSize: height! / 20),
                        )),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Image(
                          image: AssetImage('assets/children/close_btn_3.png'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height! / 8,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2.3,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        CircleAvatar(
                          radius: height! / 5,
                          backgroundColor: Colors.orange,
                          child: CircleAvatar(
                            radius: height! / 5 - height! / 50,
                            backgroundColor: Colors.white,
                            child: Image(
                              image: AssetImage(
                                  'assets/children/father_paint.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: height! / 30,
                        ),
                        CircleAvatar(
                          radius: height! / 5,
                          backgroundColor: Colors.orange,
                          child: CircleAvatar(
                            radius: height! / 5 - height! / 50,
                            backgroundColor: Colors.white,
                            child: Image(
                              image: AssetImage(
                                  'assets/children/mother_paint.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: height! / 30,
                        ),
                        CircleAvatar(
                          radius: height! / 5,
                          backgroundColor: Colors.orange,
                          child: CircleAvatar(
                            radius: height! / 5 - height! / 50,
                            backgroundColor: Colors.white,
                            child: Image(
                              image: AssetImage(
                                  'assets/children/grand_mother_paint.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: height! / 30,
                        ),
                        CircleAvatar(
                          radius: height! / 5,
                          backgroundColor: Colors.orange,
                          child: CircleAvatar(
                            radius: height! / 5 - height! / 50,
                            backgroundColor: Colors.white,
                            child: Image(
                              image: AssetImage(
                                  'assets/children/grand_father_patin.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: height! / 30,
                        ),
                        CircleAvatar(
                          radius: height! / 5,
                          backgroundColor: Colors.orange,
                          child: CircleAvatar(
                            radius: height! / 5 - height! / 50,
                            backgroundColor: Colors.white,
                            child: Image(
                              image:
                                  AssetImage('assets/children/girl_paint.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: height! / 30,
                        ),
                        CircleAvatar(
                          radius: height! / 5,
                          backgroundColor: Colors.orange,
                          child: CircleAvatar(
                            radius: height! / 5 - height! / 50,
                            backgroundColor: Colors.white,
                            child: Image(
                              image:
                                  AssetImage('assets/children/boy_paint.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: height! / 30,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
