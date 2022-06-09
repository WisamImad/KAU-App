import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kau_app/common/reset_passwor.dart';
import 'package:kau_app/routing/CupertinoPageRoute.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _emailFocus = FocusNode();

  bool _passwordValid = false;
  bool _emailValid = false;
  bool _loginBtnEnable = true;
  bool _loginBtnLoading = false;

  bool _passwordNotVisible = true;

  String _loginErrorMessage = '';

  GlobalKey _emailToolTipKey = GlobalKey();

  bool validateLogin() {
    return _passwordValid && _emailValid && _loginBtnEnable;
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: myBackground,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        backgroundColor: myBackground,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 30, 15, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/login_icon.svg",
                      ),
                      Text(
                        'تسجيل دخول',
                        style: TextStyle(fontFamily: fontHiding1, color: myBlue, fontSize: 34),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _emailValid = validator.email(text);
                          });
                        },
                        textInputAction: TextInputAction.next,
                        textDirection: TextDirection.ltr,
                        focusNode: _emailFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _emailFocus, _passwordFocus);
                        },
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: myBlue,
                            size: 30,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              final dynamic tooltip = _emailToolTipKey.currentState;
                              tooltip.ensureTooltipVisible();
                            },
                            child: Tooltip(
                              key: _emailToolTipKey,
                              message: _emailValid ? "صيغة البريد صحيحة" : "ضيغة البريد غير صحيحة",
                              child: Icon(
                                Icons.help_outline,
                                color: _emailValid ? myBlue : Colors.red,
                              ),
                            ),
                          ),
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: myBlue, width: 1.0),
                          ),
                          labelStyle: TextStyle(fontFamily: fontHiding2, color: myBlue),
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          labelText: 'البريد الالكتروني',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _passwordValid = text.length >= 1;
                          });
                        },
                        textInputAction: TextInputAction.done,
                        textDirection: TextDirection.ltr,
                        focusNode: _passwordFocus,
                        controller: _passwordController,
                        obscureText: _passwordNotVisible,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: myBlue,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _passwordNotVisible = !_passwordNotVisible;
                                      });
                                    },
                                    child: Icon(_passwordNotVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off)),
                              ],
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: myBlue, width: 1.0),
                          ),
                          labelStyle: TextStyle(fontFamily: fontHiding2, color: myBlue),
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          labelText: 'كلمة المرور',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        _loginErrorMessage,
                        style: TextStyle(fontFamily: fontHiding2, fontSize: 20, color: Colors.red),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: RaisedButton(
                          color: myBink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          onPressed: validateLogin() ? _login : null,
                          child: _loginBtnLoading
                              ? SpinKitRipple(
                                  color: Colors.white,
//                              type: SpinKitWaveType.start
                                )
                              : Text('دخول', style: fontButtonStyle),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                CupertinoPageRoute(builder: (context) => ResetPasswordPage()));
                          },
                          child: Text(
                            'هل نسيت كلمة المرور؟',
                            style: TextStyle(color: myBink, fontSize: 16, fontFamily: fontHiding2),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _loginBtnEnable = false;
      _loginBtnLoading = true;
    });
    print('start login');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final data =
          jsonEncode({"username": _emailController.text, "password": _passwordController.text});
      Map<String, String> userHeader = {'Content-Type': 'application/json'};
      print('before login');

      var response = await post(Uri.parse(Conn.loginULR), body: data, headers: userHeader);
      print('after login');

      var responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        try {
          var request = MultipartRequest("POST", Uri.parse(Conn.setNotificationTokenURL));
          request.fields["push_notification_token"] = prefs.getString('NotificationToken')!;
          request.headers['Authorization'] = 'token ${Conn.token}';
          var response = await request.send();
          //Get the response from the server
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print('set token');
          if (response.statusCode == 200) {
          } else if (response.statusCode == 401) {
            Conn.logout();
          }
        } catch (e) {}

        Map responseMap = jsonDecode(response.body);
        Conn.token = responseMap['token'];
        bool isAdmin = responseMap['is_admin'];
        await prefs.setString("token", Conn.token ?? "");
        await prefs.setBool("isLogin", true);
        await prefs.setBool("isAdmin", isAdmin);
        Navigator.of(context).pushNamedAndRemoveUntil(
            isAdmin ? '/admin' : '/child', (Route<dynamic> route) => false);
      } else if (response.statusCode == 401) {
        _loginErrorMessage = "البريد الإلكتروني او كلمة المرور غير صحيحة";
      } else {
        _loginErrorMessage = responseMap;
      }
      setState(() {
        _loginBtnEnable = true;
        _loginBtnLoading = false;
      });
    } on SocketException {
      await AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.ERROR,
              animType: AnimType.SCALE,
              title: 'لا يوجد اتصال بالإنترنت',
              desc: 'تاكد من توصيل الجهاز باإنترنت',
              btnOkOnPress: () {},
              btnOkText: 'تم',
              btnOkColor: Colors.red)
          .show();
      setState(() {
        _loginBtnEnable = true;
        _loginBtnLoading = false;
      });
      return;
    } catch (e) {
      print(e);
    }
  }
}
