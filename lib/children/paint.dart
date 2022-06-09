import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:painter/painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/children/main_paint.dart';
import 'package:kau_app/children/result_paint.dart';
import 'package:kau_app/children/sub_paint.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'dart:math' as math;

List<dynamic> images = List<dynamic>.filled(7, null, growable: false);
String family = "dad";

class PaintPage extends StatefulWidget {
  final String? image;
  final int? indexMap;

  PaintPage({
    Key? key,
    this.image,
    this.indexMap,
  }) : super(key: key);

  @override
  _PaintPageState createState() => new _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  GlobalKey _globalKey = new GlobalKey();
  var finalImage;

  bool? _finished;
  String state = "pen";
  PainterController? _controller;

  int nextIndex = 0;
  String step = "draw";

  @override
  void initState() {
    super.initState();
    _finished = false;
    _controller = _newController();
    nextIndex = (this.widget.indexMap == null ? 0 : this.widget.indexMap)!;
    nextIndex == 6 ? step = "finish" : step = "draw";
    if (widget.image == "assets/children/father_paint.png") {
      family = "dad";
    } else if (widget.image == "assets/children/mother_paint.png") {
      family = "mom";
    } else if (widget.image == "assets/children/grand_father_paint.png") {
      family = "gfather";
    } else if (widget.image == "assets/children/grand_mother_paint.png") {
      family = "gmother";
    } else if (widget.image == "assets/children/boy_paint.png") {
      family = "boy";
    } else if (widget.image == "assets/children/girl_paint.png") {
      family = "girl";
    }
  }

  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      if (step == "result") {
        finalImage = pngBytes;
        print("the final image");
      } else {
        images[nextIndex] = pngBytes;
        print("not final image");
      }
      setState(() {});
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new SafeArea(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage("assets/children/paint_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Row(
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: Image.asset(
                                  "assets/children/back_icon1.png",
                                  height: SizeConfig.safeBlockVertical! * 17,
                                  width: SizeConfig.safeBlockHorizontal! * 10,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 1,
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                //height: SizeConfig.safeBlockVertical * 95,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/children/board.png"),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              step == "result"
                                  ? Container(
                                      ////
                                      height:
                                          SizeConfig.safeBlockHorizontal! * 90,
                                      width:
                                          SizeConfig.safeBlockHorizontal! * 65,
                                      alignment: Alignment.center,
                                      child: RepaintBoundary(
                                        key: _globalKey,
                                        child: GridView.count(
                                            shrinkWrap: true,
                                            crossAxisCount: 4,
                                            mainAxisSpacing: 25,
                                            children: <Widget>[
                                              for (int i = 0;
                                                  i < images.length;
                                                  i++)
                                                Image.memory(images[i],
                                                    fit: BoxFit.cover)
                                            ]),
                                      ),
                                    )
                                  : Positioned(
                                      top: SizeConfig.safeBlockVertical! * 1,
                                      right:
                                          SizeConfig.safeBlockHorizontal! * 11,
                                      child: RepaintBoundary(
                                        key: _globalKey,
                                        child: Container(
                                          height:
                                              SizeConfig.safeBlockVertical! *
                                                  74,
                                          width:
                                              SizeConfig.safeBlockHorizontal! *
                                                  57,
                                          child: new AspectRatio(
                                              aspectRatio: 1,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  Image.asset(
                                                    widget.image!,
                                                    height: SizeConfig
                                                            .safeBlockVertical! *
                                                        45,
//                                                    width:
//                                                    SizeConfig.safeBlockHorizontal * 25,

                                                    fit: BoxFit.fill,
                                                  ),
                                                  Painter(_controller!),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          step == "result"
                              ? Container()
                              : Positioned(
                                  bottom: SizeConfig.safeBlockVertical! * 1.5,
                                  right: SizeConfig.safeBlockVertical! * 2.5,
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    width: SizeConfig.safeBlockHorizontal! * 69,
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: <Widget>[
                                        SizedBox(
                                          width:
                                              SizeConfig.safeBlockHorizontal! *
                                                  68,
                                          height:
                                              SizeConfig.safeBlockVertical! *
                                                  22,
                                          child: Row(
                                            children: <Widget>[
                                              for (int i = 1;
                                                  i <= paint_color.length;
                                                  i++)
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // print(i);
                                                      setState(() {
                                                        if (state == "pen") {
                                                          _controller
                                                                  ?.drawColor =
                                                              paint_color[
                                                                  i - 1];
                                                        } else {
                                                          _controller
                                                                  ?.drawColor =
                                                              paint_color[i - 1]
                                                                  .withOpacity(
                                                                      0.5);
                                                        }
                                                      });
                                                    },
                                                    child: Image.asset(
                                                      "assets/children/colors/color${i}.png",
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(
                                                  width: SizeConfig
                                                          .safeBlockVertical! *
                                                      2),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            height:
                                                SizeConfig.safeBlockVertical! *
                                                    10,
                                            //padding: EdgeInsets.only(bottom: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(SizeConfig
                                                            .safeBlockVertical! *
                                                        2))))
                                      ],
                                    ),
                                  ),
                                ),
                          step == "result"
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _controller!.undo();
                                          });
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: SizeConfig
                                                      .safeBlockVertical! *
                                                  10,
                                            ),
                                            Image.asset(
                                              "assets/children/undo_icon.png",
                                              height: SizeConfig
                                                      .safeBlockVertical! *
                                                  17,
                                              width: SizeConfig
                                                      .safeBlockHorizontal! *
                                                  10,
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                          step == "result"
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height:
                                              SizeConfig.safeBlockVertical! * 5,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                state = "erase";
                                                _controller!.eraseMode == false
                                                    ? _controller!.eraseMode =
                                                        !_controller!.eraseMode
                                                    : _controller!.eraseMode =
                                                        _controller!.eraseMode;
                                                _controller!.thickness = 11;
                                              });
                                            },
                                            child: Image.asset(
                                              "assets/children/eraser_icon.png",
                                              height: SizeConfig
                                                      .safeBlockVertical! *
                                                  17,
                                              width: SizeConfig
                                                      .safeBlockHorizontal! *
                                                  10,
                                            )),
                                        SizedBox(
                                          height:
                                              SizeConfig.safeBlockVertical! * 2,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                state = "marker";

                                                _controller!.eraseMode == true
                                                    ? _controller!.eraseMode =
                                                        !_controller!.eraseMode
                                                    : _controller!.eraseMode =
                                                        _controller!.eraseMode;

                                                _controller!.thickness = 11;
                                                _controller!.drawColor =
                                                    _controller!.drawColor
                                                        .withOpacity(0.5);
                                              });
                                            },
                                            child: Image.asset(
                                              "assets/children/pen_icon1.png",
                                              height: SizeConfig
                                                      .safeBlockVertical! *
                                                  17,
                                              width: SizeConfig
                                                      .safeBlockHorizontal! *
                                                  10,
                                            )),
                                        SizedBox(
                                          height:
                                              SizeConfig.safeBlockVertical! * 2,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                state = "pen";
                                                _controller!.eraseMode == true
                                                    ? _controller!.eraseMode =
                                                        !_controller!.eraseMode
                                                    : _controller!.eraseMode =
                                                        _controller!.eraseMode;
                                                _controller!.thickness = 5;
                                                _controller!.drawColor =
                                                    _controller!.drawColor
                                                        .withOpacity(1);
                                              });
                                            },
                                            child: Image.asset(
                                              "assets/children/pen_icon.png",
                                              height: SizeConfig
                                                      .safeBlockVertical! *
                                                  17,
                                              width: SizeConfig
                                                      .safeBlockHorizontal! *
                                                  10,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => dialogWidget(context));
                            },
                            child: Image.asset(
                              "assets/children/close_btn_5.png",
                              height: SizeConfig.safeBlockVertical! * 17,
                              width: SizeConfig.safeBlockHorizontal! * 10,
                            )),
                        step == "result"
                            ? InkWell(
                                onTap: () {
                                  _capturePng().then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResultPaint(
                                              finalImage: finalImage)),
                                    );
                                  });
                                },
                                child: Image.asset(
                                  "assets/children/star_icon1.png",
                                  height: SizeConfig.safeBlockVertical! * 17,
                                  width: SizeConfig.safeBlockHorizontal! * 10,
                                ))
                            : InkWell(
                                onTap: () {
                                  _capturePng().then((value) {
                                    setState(() {
                                      step == "finish"
                                          ? step = "result"
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SubPaint(
                                                  indexMap: nextIndex,
                                                ),
                                              ),
                                            );
                                    });
                                  });
                                },
                                child: Image.asset(
                                  "assets/children/back_icon1.png",
                                  height: SizeConfig.safeBlockVertical! * 17,
                                  width: SizeConfig.safeBlockHorizontal! * 10,
                                )),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }

  Widget dialogWidget(BuildContext context) {
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
                        borderRadius: BorderRadius.circular(
                            SizeConfig.safeBlockVertical! * 10),
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
                      borderRadius: BorderRadius.circular(
                          SizeConfig.safeBlockVertical! * 10),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MainPaint()));
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
  }
}
