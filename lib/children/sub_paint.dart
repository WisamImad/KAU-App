import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/children/paint.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'dart:math' as math;

import 'main_paint.dart';

class SubPaint extends StatefulWidget {
  final int? indexMap;

  SubPaint({Key? key, this.indexMap}) : super(key: key);

  @override
  _SubPaintState createState() => _SubPaintState();
}

class _SubPaintState extends State<SubPaint> {
  static List<String> fruit = [
    "assets/children/paints/fruit/apple_paint.png",
    "assets/children/paints/fruit/banana_paint.png",
    "assets/children/paints/fruit/cherries_paint.png",
    "assets/children/paints/fruit/grape_paint.png",
    "assets/children/paints/fruit/kiwi_paint.png",
    "assets/children/paints/fruit/mango_paint.png",
    "assets/children/paints/fruit/orange_paint.png",
    "assets/children/paints/fruit/peache_paint.png",
    "assets/children/paints/fruit/pear_paint.png",
    "assets/children/paints/fruit/pomegranate_paint.png",
    "assets/children/paints/fruit/strawberrie_paint.png",
    "assets/children/paints/fruit/watermelon_paint.png",
  ];
  static List<String> veg = [
    "assets/children/paints/veg/mashrom_paint.png",
    "assets/children/paints/veg/ballPepper_paint.png",
    "assets/children/paints/veg/carrot_paint.png",
    "assets/children/paints/veg/corn_paint.png",
    "assets/children/paints/veg/garlic_paint.png",
    "assets/children/paints/veg/papper_paint.png",
    "assets/children/paints/veg/potato_paint.png",
    "assets/children/paints/veg/tomato_paint.png",
  ];
  static List<String> job = [
    "assets/children/paints/job/fishhing_paint.png",
    "assets/children/paints/job/computer_paint.png",
    "assets/children/paints/job/cooking_paint.png",
    "assets/children/paints/job/cyclistRide_paint.png",
    "assets/children/paints/job/design_paint.png",
    "assets/children/paints/job/farm_paint.png",
    "assets/children/paints/job/paint_paint.png",
    "assets/children/paints/job/playGame_paint.png",
    "assets/children/paints/job/riding_paint.png",
    "assets/children/paints/job/sewing_paint.png",
    "assets/children/paints/job/sport_paint.png",
    "assets/children/paints/job/surfing_paint.png",
  ];
  static List<String> letter = [
    "assets/children/paints/letter/a_paint.png",
    "assets/children/paints/letter/b_paint.png",
    "assets/children/paints/letter/c_paint.png",
    "assets/children/paints/letter/d_paint.png",
    "assets/children/paints/letter/e_paint.png",
    "assets/children/paints/letter/f_paint.png",
    "assets/children/paints/letter/g_paint.png",
    "assets/children/paints/letter/h_paint.png",
    "assets/children/paints/letter/i_paint.png",
    "assets/children/paints/letter/j_paint.png",
    "assets/children/paints/letter/k_paint.png",
    "assets/children/paints/letter/l_paint.png",
    "assets/children/paints/letter/m_paint.png",
    "assets/children/paints/letter/n_paint.png",
    "assets/children/paints/letter/o_paint.png",
    "assets/children/paints/letter/p_paint.png",
    "assets/children/paints/letter/q_paint.png",
    "assets/children/paints/letter/r_paint.png",
    "assets/children/paints/letter/s_paint.png",
    "assets/children/paints/letter/t_paint.png",
    "assets/children/paints/letter/u_paint.png",
    "assets/children/paints/letter/v_paint.png",
    "assets/children/paints/letter/w_paint.png",
    "assets/children/paints/letter/x_paint.png",
    "assets/children/paints/letter/y_paint.png",
    "assets/children/paints/letter/z_paint.png",
    "assets/children/paints/letter/z1_paint.png",
    "assets/children/paints/letter/z2_paint.png",
  ];
  static List<String> cupcake = [
    "assets/children/paints/cupcake/cherry_paint.png",
    "assets/children/paints/cupcake/blueBerry_paint.png",
    "assets/children/paints/cupcake/chocolate_paint.png",
    "assets/children/paints/cupcake/grape_paint.png",
    "assets/children/paints/cupcake/kiwi_paint.png",
    "assets/children/paints/cupcake/lemon_paint.png",
    "assets/children/paints/cupcake/strawberry_paint.png",
    "assets/children/paints/cupcake/vanilla_paint.png",
  ];

//  static List<String> tree=[
//    "assets/children/paints/tree/spring_paint.png",
//    "assets/children/paints/tree/fall_paint.png",
//    "assets/children/paints/tree/winter_paint.png",
//    "assets/children/paints/tree/summer_paint.png",
//
//
//  ];
  static List<String> color = [
    "assets/children/color_paint.png",
  ];

  Map<String, List<String>> pic = {
    "fuite": fruit,
    "veg": veg,
    "job": job,
    "letter": letter,
    "cupcake": cupcake,
    "color": color,
  };

  int? is_choose;
  int nextIndex = 0;
  AudioCache cache = AudioCache(); // you have this
  AudioPlayer player = AudioPlayer(); // create this

  //MediaPlayer mediaPlayer = new MediaPlayer();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    nextIndex = this.widget.indexMap!;
    nextIndex++;
    // print( nextIndex );
    print("111111111");
    print(nextIndex);
    player.pause();
    cache.play(
      'children/voices/paintVoice/${family}${(nextIndex)}.wav',
    );
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
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: SizeConfig.safeBlockHorizontal! * 12,
                    color: chOrange,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //  SizedBox( height: SizeConfig.safeBlockVertical * 2,),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Image.asset(
                            "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                            height: SizeConfig.safeBlockVertical! * 17,
                            width: SizeConfig.safeBlockHorizontal! * 10,
                          ),
                        ),
                        pic.values.elementAt(this.widget.indexMap!).length == 1
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  controller.animateTo((controller.offset) - 50,
                                      curve: Curves.linear,
                                      duration: Duration(milliseconds: 100));
                                },
                                child: Image.asset(
                                  "assets/children/arrow_left.png",
                                  //scale: 1.5,
                                  height: SizeConfig.safeBlockVertical! * 15,
                                ),
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
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        pic.values.elementAt(this.widget.indexMap!).length == 1
                            ? SizedBox(
                                height: SizeConfig.safeBlockVertical! * 70,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // print("nav to deatails of task");
                                      setState(() {
                                        is_choose = 1;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PaintPage(
                                                  image: pic.values.elementAt(
                                                      this.widget.indexMap!)[0],
                                                  indexMap: nextIndex,
                                                )),
                                      );
                                    },
                                    child: Container(
                                      width: SizeConfig.safeBlockVertical! * 70,
                                      padding: EdgeInsets.all(30),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            // color: is_choose==index?chYellow:chOrange,
                                            color: chOrange,
                                            //width: is_choose==index?SizeConfig.safeBlockHorizontal * 1.7:
                                            width: SizeConfig
                                                    .safeBlockHorizontal! *
                                                .6),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                SizeConfig.safeBlockVertical! *
                                                    32)),
                                      ),
                                      child: Image.asset(
                                        pic.values.elementAt(
                                            this.widget.indexMap!)[0],
                                        //fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: SizeConfig.safeBlockVertical! * 50,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ListView.builder(
                                    itemCount: pic.values
                                        .elementAt(this.widget.indexMap!)
                                        .length,
                                    controller: controller,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) =>
                                            Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // print("nav to deatails of task");
                                          setState(() {
                                            is_choose = index;
                                          });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PaintPage(
                                                      image: pic.values
                                                              .elementAt(this
                                                                  .widget
                                                                  .indexMap!)[
                                                          index],
                                                      indexMap: nextIndex,
                                                    )),
                                          );
                                        },
                                        child: Container(
                                          width: SizeConfig.safeBlockVertical! *
                                              60,
                                          padding: EdgeInsets.all(30),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: is_choose == index
                                                    ? chYellow
                                                    : chOrange,
                                                width: is_choose == index
                                                    ? SizeConfig
                                                            .safeBlockHorizontal! *
                                                        1.7
                                                    : SizeConfig
                                                            .safeBlockHorizontal! *
                                                        .8),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(SizeConfig
                                                        .safeBlockVertical! *
                                                    30)),
                                          ),
                                          child: Image.asset(
                                            pic.values.elementAt(
                                                this.widget.indexMap!)[index],
                                            //fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        pic.values.elementAt(this.widget.indexMap!).length == 1
                            ? SizedBox(
                                height: SizeConfig.safeBlockVertical! * 0.5,
                              )
                            : SizedBox(
                                height: SizeConfig.safeBlockVertical! * 3,
                              ),
                        GestureDetector(
                          onTap: () async {
                            print("111111111");
                            print(nextIndex);
                            player.pause();
                            player = await cache.play(
                              'children/voices/paintVoice/${family}${(nextIndex)}.wav',
                            );
                          },
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 15),
                            child: Image.asset(
                              "assets/children/voice_icon2.png",
                              height: SizeConfig.safeBlockVertical! * 15,
                              width: SizeConfig.safeBlockHorizontal! * 8,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 4,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: SizeConfig.safeBlockHorizontal! * 12,
                    color: chOrange,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => dialogWidget(context));
                            },
                            child: Image.asset(
                              "assets/children/close_btn_5.png",
                              height: SizeConfig.safeBlockVertical! * 17,
                              width: SizeConfig.safeBlockHorizontal! * 10,
                            )),
                        pic.values.elementAt(this.widget.indexMap!).length == 1
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  controller.animateTo((controller.offset) + 50,
                                      curve: Curves.linear,
                                      duration: Duration(milliseconds: 100));
                                },
                                child: Image.asset(
                                  "assets/children/arrow_right.png",

                                  // scale: 1.5,
                                  height: SizeConfig.safeBlockVertical! * 15,
                                ),
                              ),
                        Container(height: SizeConfig.safeBlockVertical! * 17)
                      ],
                    ),
                  )
                ],
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
