import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:kau_app/common/set_new_password.dart';
import 'package:kau_app/routing/CupertinoPageRoute.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:regexed_validator/regexed_validator.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();

  bool _emailValid = false;
  String _message = "";

  bool _btnEnable = true;
  bool _btnLoading = false;

  GlobalKey _emailToolTipKey = GlobalKey();

  bool validateRestorePassword() {
    return _emailValid && _btnEnable && _emailValid;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        backgroundColor: Colors.white,
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
                      Container(
                        height: 60,
                        width: 60,
                        child: SvgPicture.asset(
                          "assets/reset_password_icon.svg",
                          color: myBlue,
                        ),
                      ),
                      Text(
                        'استعادة كلمة المرور',
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
                        textInputAction: TextInputAction.done,
                        controller: _emailController,
                        keyboardType: TextInputType.text,
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
                          fillColor: Colors.transparent,
                          focusColor: Colors.white,
                          labelText: 'البريد الالكتروني',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '$_message',
                        style: TextStyle(color: Colors.redAccent, fontFamily: fontHiding2),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: myBink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: validateRestorePassword() ? sendEmail : null,
                          child: _btnLoading
                              ? SpinKitRipple(
                                  color: Colors.white,
                                )
                              : Text('ارسال', style: fontButtonStyle),
                        ),
                      ),
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

  void sendEmail() async {
    setState(() {
      _btnEnable = false;
      _btnLoading = true;
    });
    try {
      final data = jsonEncode({
        "username": _emailController.text,
      });
      Map<String, String> userHeader = {'Content-Type': 'application/json'};

      var response =
          await post(Uri.parse(Conn.restorePasswordURL), body: data, headers: userHeader);
      print(response.body);

      var responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      print('response');
      print(responseMap);
      if (response.statusCode == 200) {
        _message = 'تم ارسال رمز الاستعادة الى بريدك الالكتروني';
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => SetNewPassword(
                  username: _emailController.text,
                )));
      } else if (response.statusCode == 400 || response.statusCode == 412) {
        setState(() {
          _message = "فشل ارسال البريد، ربما البريد غير مسجل او حاول مرة اخرى بعد قليل";
        });
      } else {
        setState(() {
          _message = responseMap.toString();
        });
      }
      setState(() {
        _btnEnable = true;
        _btnLoading = false;
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
        _btnEnable = true;
        _btnLoading = false;
      });
      return;
    } catch (e) {
      setState(() {
        _btnEnable = true;
        _btnLoading = false;
      });
      print(e);
    }
  }
}
