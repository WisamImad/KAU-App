import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kau_app/admin/BasePageAdmin.dart';
import 'package:kau_app/common/welcome.dart';

import 'app_theme.dart';

class MyCard extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;

  MyCard({this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 3.0),
            color: Colors.grey[400]!,
            spreadRadius: 0,
            blurRadius: 4,
          ),
        ],
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: this.child,
      ),
    );
  }
}

class NoInternetPage extends StatefulWidget {
  BuildContext? context;

  NoInternetPage({this.context});

  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool _retryLoading = false;
  bool _retryEnable = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.portable_wifi_off,
              size: 180,
              color: Colors.red,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "لا يوجد اتصال بالانترنت\n يرجى التاكد من الاتصال ثم اعد المحاولة",
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: ButtonTheme(
                minWidth: double.infinity,
                child: SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: RaisedButton(
                    color: myBink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    onPressed: _retryEnable
                        ? () async {
                            setState(() {
                              _retryLoading = true;
                              _retryEnable = false;
                            });
                            Navigator.pop(widget.context!);
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BasePageAdmin()));
                          }
                        : null,
                    child: _retryLoading
                        ? SpinKitRipple(
                            color: Colors.white,
//                              type: SpinKitWaveType.start
                          )
                        : Text('حاول مجددا', style: fontButtonStyle),
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: SpinKitPumpingHeart(
                color: myBink,
              ),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('جاري التحميل'),
            )
          ]),
    );
  }
}

class UnAuthAccountPage extends StatefulWidget {
  @override
  _UnAuthAccountPageState createState() => _UnAuthAccountPageState();
}

class _UnAuthAccountPageState extends State<UnAuthAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cancel,
                size: 180,
                color: Colors.red,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'لا يمكن الوصول الى حسابك\n يبدو انه تم ايقاف الحساب من قبل الادارة\n الرجاء التواصل مع الادارة او حاول التسجيل مره اخرى',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(80.0),
                child: ButtonTheme(
                  minWidth: double.infinity,
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: myBink,
                      height: 50,
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => WelcomePage()),
                            (Route<dynamic> route) => false);
                      },
                      child: Text(
                        "حاول مجددا",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontSize: 17),
                      )),
                ),
              ),
            ]),
      ),
    );
    ;
  }
}
