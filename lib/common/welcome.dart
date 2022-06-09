import 'package:flutter/material.dart';
import 'package:kau_app/common/login.dart';
import 'package:kau_app/common/login_qr.dart';
import 'package:kau_app/common/signup.dart';
import 'package:kau_app/routing/CupertinoPageRoute.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  List<bool> _dotList = [true, false, false];

  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  AnimationController? controller;

  _changePage(int x) {
    _dotList = [false, false, false];
    _dotList[x] = true;
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: myBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 300,
                        child: Image(
                          image: AssetImage("assets/loglo.png"),
                        )),
                    Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          child: PageView(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'قيم سلوك طفلك',
                                    style: TextStyle(
                                        fontFamily: "a-massir-ballpoint",
                                        fontSize: 36,
                                        color: myBink),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 0.0, 20.0, 0.0),
                                    child: Text(
                                      ' في كل يوم قم بتقييم اطفالك بناء على سلوكياتهم سواء كانت ايجابية أو سلبية ',
                                      style: TextStyle(
                                          fontFamily: "Tajawal",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              50,
                                          color: myBlue),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'مكافأة !!',
                                    style: TextStyle(
                                        fontFamily: "a-massir-ballpoint",
                                        fontSize: 36,
                                        color: myBink),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 0.0, 20.0, 0.0),
                                    child: Text(
                                      ' أعط أطفالك مكافئات يستحقونها لسلوكهم الجيد وحفزهم على المزيد ',
                                      style: TextStyle(
                                          fontFamily: "Tajawal",
                                          fontSize: 18,
                                          color: myBlue),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'أنشطة وألعاب',
                                    style: TextStyle(
                                        fontFamily: "a-massir-ballpoint",
                                        fontSize: 36,
                                        color: myBink),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 0.0, 20.0, 0.0),
                                    child: Text(
                                      'قم بتحفيز أطفالك على إكمال الأنشطة ومعرفة مدى قدرتهم واستيعابهم',
                                      style: TextStyle(
                                          fontFamily: "Tajawal",
                                          fontSize: 18,
                                          color: myBlue),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ],
                            controller: _pageController,
                            onPageChanged: (number) {
                              setState(() {
                                _changePage(number);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                              width: 40,
                              child: RaisedButton(
                                onPressed: () {
                                  _pageController.animateToPage(0,
                                      curve: Curves.ease,
                                      duration: Duration(milliseconds: 300));
                                },
                                color: _dotList[0] ? myBlue : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side: BorderSide(color: myBlue)),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 10,
                              width: 40,
                              child: RaisedButton(
                                onPressed: () {
                                  _pageController.animateToPage(1,
                                      curve: Curves.ease,
                                      duration: Duration(milliseconds: 300));
                                },
                                color: _dotList[1] ? myBlue : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side: BorderSide(color: myBlue)),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 10,
                              width: 40,
                              child: RaisedButton(
                                onPressed: () {
                                  _pageController.animateToPage(2,
                                      curve: Curves.easeIn,
                                      duration: Duration(milliseconds: 300));
                                },
                                color: _dotList[2] ? myBlue : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side: BorderSide(color: myBlue)),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: RaisedButton(
                            color: myBink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => SignUpPage()));
                            },
                            child: Text(
                              'إنشاء عائلة جديدة',
                              style: fontButtonStyle,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: RaisedButton(
                            color: myBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => LoginPage()));
                            },
                            child: Text('تسجيل الدخول', style: fontButtonStyle),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => LoginQRPage()));
                            },
                            child: Text(
                              'الدخول كفرد',
                              style: TextStyle(
                                  color: myBink,
                                  fontSize: 20,
                                  fontFamily: fontHiding1),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                            onTap: () {
                              launch('https://sononkau.xyz');
                            },
                            child: Text(
                              'عن التطبيق',
                              style: TextStyle(
                                color: myBlue,
                                fontSize: 20,
                                fontFamily: fontHiding1,
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
