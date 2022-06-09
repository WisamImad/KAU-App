import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kau_app/children/board_view.dart';
import 'package:kau_app/children/model.dart';
import 'package:kau_app/children/result_spinWheel.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:audioplayers/audioplayers.dart';

import 'main_child.dart';

class SpainWheel extends StatefulWidget {
  @override
  _SpainWheelState createState() => _SpainWheelState();
}

class _SpainWheelState extends State<SpainWheel> with SingleTickerProviderStateMixin {
  double angle = 0;
  double current = 0;
  AnimationController? controller;
  Animation? animation;
  int? index;
  int? random;
  String? voice;
  //this for sounds
  AudioCache cache = AudioCache();
  AudioPlayer player = AudioPlayer();
  bool is_playing = false;
  var _duration;

  List<Luck> _items = [
    Luck("1", Color(0xffFFFEDC)),
    Luck("7", Color(0xffF4B333)),
    Luck("6", Color(0xff345995)),
    Luck("5", Color(0xff05CDA2)),
    Luck("4", Color(0xffFB4D3D)),
    Luck("3", Color(0xffFFFEDC)),
    Luck("2", Color(0xffE40066)),
  ];

  List<String> text0 = [
    "قبل يد ماما وقل لها (شكرا يا ماما.. أنت تتعبين كثيرا من أجلنا)",
    "ارسم الأشياء التي تحبها ماما",
    "اطلب من بابا أو أحد إخوتك مساعدتك لتكتب رسالة لماما وضعها على سريرها",
    "ارسل لماما رسالة بصوتك وأخبرها بأنك تحبها وتشتاق لها",
    "قل لماما أنا محظوظ لأنك أمي",
  ];
  List<String> text1 = [
    "قبل ماما ١٠ قبلت",
    "قبل بابا ١٠ قبلت",
    "ااحضن ماما وقل لها أحبك بعدد كل ورود الدنيا",
    "احضن بابا وقل له أحبك بعدد قطرات المطر",
    "صور مقطع فيديو لماما أو بابا وأخبرهم أنك تحبهم كثيرا كثيرا كثيرا",
    "ما هو أكثر شيء تستمتع بعمله مع ماما فكر؟ ثم أخبرها",
    "ما هو أكثر شيء تستمتع بعمله مع بابا فكر؟ ثم أخبره",
    "اذهب مع إخوتك لماما وقل لها نحبك كثيرا يا سوبر ماما",
    "اذهب مع إخوتك لبابا وقل له نحبك كثيرا يا سوبر بابا",
  ];
  List<String> text2 = [
    "ارسم قلبا لماما وضعه بجوار سريرها",
    "ارسم قلبا لبابا وضعه على سريره",
    " ارسم رسمة جميلة لبابا وضعها في جيبه",
    "ارسم الأشياء التي تحبها ماما",
    "ارسم الأشياء التي يحبها بابا",
    "ارسم لوحة واهديها لماما وبابا",
    "ارسم وردة لماما وقل لها أنت أجمل من كل ورود الدنيا",
  ];
  List<String> text3 = [
    "احفظ أنشودة عن الأم أو الأب وأنشدها لماما وبابا أو سجلها وأرسلها لهما",
    "لو كانت لديك الكثير من النقود ماذا ستشتري لماما وبابا؟ فكر ثم أخبر والديك بذلك",
    "لو كانت لديك طائرة إلى أين ستأخذ ماما وبابا؟ فكر وأخبرهم بذلك",
    "ادعي لماما وبابا في صلتك ثم أخبرهم بذلك",
    "بعد أن تسمع الآذان ادعي لماما وبابا",
    "اسأل ماما: ما هو أكثر شيء يجعلها تشعر بالسعادة؟",
    "اسأل بابا: ما هو أكثر شيء يجعله سعيدا؟",
  ];
  List<String> text4 = [
    "احضن بابا وقل له أحبك بعدد نجوم السماء",
    "قبل يد بابا وقل له (شكرا يا بابا.. أنت تتعب كثيرا من أجلنا)",
    "اطلب من ماما أو أحد إخوتك مساعدتك لتكتب رسالة لبابا وخبئها في محفظته أو جيبه",
    "عندما يعود بابا من العمل قل له (أحبك يا بابا الله يعطيك العافية)",
    "ارسل لبابا رسالة بصوتك وأخبره أنك تحبه وتشتاق إليه",
    "قل لبابا أنا محظوظ لأنك أبي",
  ];

  List<String> text5 = [
    "اطلب من ماما أن تحكي لك قصة مضحكة من طفولتها",
    "اطلب من بابا أن يحكي لك قصة مضحكة عن طفولته",
    "اسأل ماما كيف كانت تجعل والديها سعيدان عندما كانت طفلة صغيرة",
    "اسأل بابا كيف كان يجعل والديه سعيدان عندما كان طفل صغيرا",
    "ماهي أجمل قصة تتذكرها ماما عنك وأنت طفل صغير؟",
    "ماهي أجمل قصة يتذكرها بابا عنك وأنت طفل صغير؟",
  ];

  List<String> text6 = [
    "اطلب من أحد الكبار مساعدتك لتعد كعكة لتفاجأ ماما أو بابا ",
    "فاجئ ماما بترتيب ألعابك دون أن تطلب منك ذلك",
    "أخبر ماما بأنك ستكون مساعدها اليوم ونفذ طلباتها",
    "أخبر بابا بأنك ستكون مساعده اليوم ونفذ طلباته",
    "رتب سريرك بدون أن تطلب ماما منك ذلك",
  ];

  List<List<String>> texts = [
    [
      "قبل يد ماما وقل لها (شكرا يا ماما.. أنت تتعبين كثيرا من أجلنا)",
      "ارسم الأشياء التي تحبها ماما",
      "اطلب من بابا أو أحد إخوتك مساعدتك لتكتب رسالة لماما وضعها على سريرها",
      "ارسل لماما رسالة بصوتك وأخبرها بأنك تحبها وتشتاق لها",
      "قل لماما أنا محظوظ لأنك أمي",
    ],
    [
      "قبل ماما ١٠ قبلت",
      "قبل بابا ١٠ قبلت",
      "ااحضن ماما وقل لها أحبك بعدد كل ورود الدنيا",
      "احضن بابا وقل له أحبك بعدد قطرات المطر",
      "صور مقطع فيديو لماما أو بابا وأخبرهم أنك تحبهم كثيرا كثيرا كثيرا",
      "ما هو أكثر شيء تستمتع بعمله مع ماما فكر؟ ثم أخبرها",
      "ما هو أكثر شيء تستمتع بعمله مع بابا فكر؟ ثم أخبره",
      "اذهب مع إخوتك لماما وقل لها نحبك كثيرا يا سوبر ماما",
      "اذهب مع إخوتك لبابا وقل له نحبك كثيرا يا سوبر بابا",
    ],
    [
      "ارسم قلبا لماما وضعه بجوار سريرها",
      "ارسم قلبا لبابا وضعه على سريره",
      " ارسم رسمة جميلة لبابا وضعها في جيبه",
      "ارسم الأشياء التي تحبها ماما",
      "ارسم الأشياء التي يحبها بابا",
      "ارسم لوحة واهديها لماما وبابا",
      "ما هو أكثر شيء تستمتع بعمله مع بابا فكر؟ ثم أخبره",
      "ارسم وردة لماما وقل لها أنت أجمل من كل ورود الدنيا",
    ],
    [
      "احفظ أنشودة عن الأم أو الأب وأنشدها لماما وبابا أو سجلها وأرسلها لهما",
      "لو كانت لديك الكثير من النقود ماذا ستشتري لماما وبابا؟ فكر ثم أخبر والديك بذلك",
      "لو كانت لديك طائرة إلى أين ستأخذ ماما وبابا؟ فكر وأخبرهم بذلك",
      "ادعي لماما وبابا في صلتك ثم أخبرهم بذلك",
      "بعد أن تسمع الآذان ادعي لماما وبابا",
      "اسأل ماما: ما هو أكثر شيء يجعلها تشعر بالسعادة؟",
      "اسأل بابا: ما هو أكثر شيء يجعله سعيدا؟",
    ],
    [
      "احضن بابا وقل له أحبك بعدد نجوم السماء",
      "قبل يد بابا وقل له (شكرا يا بابا.. أنت تتعب كثيرا من أجلنا)",
      "اطلب من ماما أو أحد إخوتك مساعدتك لتكتب رسالة لبابا وخبئها في محفظته أو جيبه",
      "عندما يعود بابا من العمل قل له (أحبك يا بابا الله يعطيك العافية)",
      "ارسل لبابا رسالة بصوتك وأخبره أنك تحبه وتشتاق إليه",
      "قل لبابا أنا محظوظ لأنك أبي",
    ],
    [
      "اطلب من ماما أن تحكي لك قصة مضحكة من طفولتها",
      "اطلب من بابا أن يحكي لك قصة مضحكة عن طفولته",
      "اسأل ماما كيف كانت تجعل والديها سعيدان عندما كانت طفلة صغيرة",
      "اسأل بابا كيف كان يجعل والديه سعيدان عندما كان طفل صغيرا",
      "ماهي أجمل قصة تتذكرها ماما عنك وأنت طفل صغير؟",
      "ماهي أجمل قصة يتذكرها بابا عنك وأنت طفل صغير؟",
    ],
    [
      "اطلب من أحد الكبار مساعدتك لتعد كعكة لتفاجأ ماما أو بابا ",
      "فاجئ ماما بترتيب ألعابك دون أن تطلب منك ذلك",
      "أخبر ماما بأنك ستكون مساعدها اليوم ونفذ طلباتها",
      "أخبر بابا بأنك ستكون مساعده اليوم ونفذ طلباته",
      "رتب سريرك بدون أن تطلب ماما منك ذلك",
    ]
  ];

  @override
  void initState() {
    super.initState();
    _duration = Duration(seconds: 5);
    controller = AnimationController(vsync: this, duration: _duration);
    animation = CurvedAnimation(parent: controller!, curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/children/wheel_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  animationWidget(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset(
                            "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                            height: SizeConfig.safeBlockVertical! * 17,
                            width: SizeConfig.safeBlockHorizontal! * 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                            child: Image.asset(
                              "assets/children/home_icon1.png",
                              height: SizeConfig.safeBlockVertical! * 13,
                              width: SizeConfig.safeBlockHorizontal! * 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget animationWidget() {
    return SizedBox(
      height: SizeConfig.safeBlockVertical! * 95,
      child: AnimatedBuilder(
          animation: animation!,
          builder: (context, child) {
            final _value = animation!.value;
            var _angle = _value * this.angle;
            buildResult(_value);
            //print(index); //the index of image
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 77,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          BoardView(items: _items, current: current, angle: _angle),
                          _buildGo(),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        "assets/children/spin_frame.png",
                        height: SizeConfig.safeBlockVertical! * 90,
                        //height: SizeConfig.safeBlockVertical*90.5,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: _animation,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              is_playing
                                  ? "assets/children/button_blue.png"
                                  : "assets/children/button_yallow.png",
                              height: SizeConfig.safeBlockVertical! * 15,
                              width: SizeConfig.safeBlockHorizontal! * 25,
                            ),
                          ),
                          Text(
                            is_playing ? "توقف" : "ابدأ",
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical! * 7,
                                fontFamily: 'ge_ss',
                                fontWeight: FontWeight.bold,
                                height: 1,
                                color: is_playing ? chGreen : chBlue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  _buildGo() {
    return Container(
      height: SizeConfig.safeBlockVertical! * 12,
      width: SizeConfig.safeBlockHorizontal! * 10,
      child: Image.asset(
        "assets/children/circle.png",
      ),
    );
  }

  _animation() {
    var _random = Random().nextDouble();

    if (!is_playing) {
      is_playing = true;
      angle = 20 + Random().nextInt(5) + _random;
      controller!.duration = Duration(seconds: 5);
      controller!.forward(from: 0.0).then((_) {
        current = (current + _random);
        current = current - current ~/ 1;
        controller!.reset();
        setState(() {
          showDialog(context: context, barrierDismissible: false, builder: (_) => dialogWidget());
          is_playing = false;
        });
      });
    } else {
      is_playing = false;
      angle = (Random().nextInt(5) + _random) - 5;
      controller!.duration = Duration(seconds: 1);
      controller!.forward(from: 0.0).then((_) {
        current = (current + _random);
        current = current - current ~/ 1;

        controller!.reset();
        setState(() {
          showDialog(context: context, barrierDismissible: false, builder: (_) => dialogWidget());
        });
      });
    }
  }

  int _calIndex(value) {
    var _base = ((2 * pi / _items.length / 3) / (2 * pi)) + 0.51;
    return ((((_base + value) % 1) * _items.length).floor());
  }

  buildResult(_value) {
    var _index = _calIndex(_value * angle + current);
    index = _index;
    return "${_index}";
  }

  String message() {
    String? message;
    int random;
    switch (index) {
      case 0:
        random = Random().nextInt(text0.length - 0);
        message = text0[random];
        voice = 'children/voices/spinVoice/0_${(random)}.wav';
        break;
      case 1:
        random = Random().nextInt(text1.length - 0);
        message = text1[random];
        voice = 'children/voices/spinVoice/1_${(random)}.wav';
        break;
      case 2:
        random = Random().nextInt(text2.length - 0);
        message = text2[random];
        voice = 'children/voices/spinVoice/2_${(random)}.wav';
        break;
      case 3:
        random = Random().nextInt(text3.length - 0);
        message = text3[random];
        voice = 'children/voices/spinVoice/3_${(random)}.wav';
        break;
      case 4:
        random = Random().nextInt(text4.length - 0);
        message = text4[random];
        voice = 'children/voices/spinVoice/4_${(random)}.wav';
        break;
      case 5:
        random = Random().nextInt(text5.length - 0);
        message = text5[random];
        voice = 'children/voices/spinVoice/5_${(random)}.wav';
        break;
      case 6:
        random = Random().nextInt(text6.length - 0);
        message = text6[random];
        voice = 'children/voices/spinVoice/6_${(random)}.wav';
        break;
    }
    return message!;
  }

  Widget dialogWidget() {
    String _message = message();
    player.pause();
    cache.play(
      voice ?? "",
    );
    return Dialog(
      backgroundColor: chYellow1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical! * 20),
      ),
      child: Container(
        padding: EdgeInsets.all(0),
        height: SizeConfig.safeBlockVertical! * 75,
        width: SizeConfig.safeBlockHorizontal! * 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.safeBlockVertical! * 2,
            ),
            Container(
              width: SizeConfig.safeBlockHorizontal! * 52,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      player.pause();
                      player = await cache.play(
                        voice ?? "",
                      );
                    },
                    child: Container(
                      width: SizeConfig.safeBlockHorizontal! * 8,
                      height: SizeConfig.safeBlockVertical! * 10,
                      child: Image.asset(
                        "assets/children/voice_icon1.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: SizeConfig.safeBlockHorizontal! * 8,
                      height: SizeConfig.safeBlockVertical! * 10,
                      child: Image.asset(
                        "assets/children/close_btn_4.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: SizeConfig.safeBlockHorizontal! * 55,
              height: SizeConfig.safeBlockVertical! * 40,
              alignment: Alignment.center,
              child: Text(
                "$_message",
                // '${map[index][index][2]}',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical! * 7,
                    fontFamily: 'ge_ss',
                    fontWeight: FontWeight.bold,
                    color: chBlue,
                    height: 1.5),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical! * 1,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: SizeConfig.safeBlockHorizontal! * 22,
                    height: SizeConfig.safeBlockVertical! * 13,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/children/button_blue.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "مهمة اخرى",
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical! * 6,
                          fontFamily: 'ge_ss',
                          fontWeight: FontWeight.bold,
                          color: chGreen),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => dialogWidget1(_message));
                    });
                    // Navigator.pop(context);
                  },
                  child: Container(
                    width: SizeConfig.safeBlockHorizontal! * 22,
                    height: SizeConfig.safeBlockVertical! * 13,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/children/button_green.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "موافق",
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical! * 6,
                          fontFamily: 'ge_ss',
                          fontWeight: FontWeight.bold,
                          color: chBlue),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical! * 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget dialogWidget1(String message) {
    return Dialog(
      backgroundColor: chYellow1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical! * 20),
      ),
      child: Container(
        padding: EdgeInsets.all(0),
        height: SizeConfig.safeBlockVertical! * 75,
        width: SizeConfig.safeBlockHorizontal! * 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.safeBlockVertical! * 2,
            ),
            Container(
              width: SizeConfig.safeBlockHorizontal! * 55,
              height: SizeConfig.safeBlockVertical! * 40,
              alignment: Alignment.center,
              child: Text(
                'اتممت المهمة',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical! * 11,
                    fontFamily: 'ge_ss',
                    fontWeight: FontWeight.bold,
                    color: chBlue,
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical! * 1,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultSpinWheel(message: message)),
                  );
                });
              },
              child: Container(
                width: SizeConfig.safeBlockHorizontal! * 22,
                height: SizeConfig.safeBlockVertical! * 13,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/children/button_green.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "تم",
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockVertical! * 6.5,
                      fontFamily: 'ge_ss',
                      fontWeight: FontWeight.bold,
                      color: chBlue),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical! * 5,
            ),
          ],
        ),
      ),
    );
  }
}
