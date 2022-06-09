import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:regexed_validator/regexed_validator.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _basePasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confPasswordController = TextEditingController();

  final _basePasswordFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confPasswordFocus = FocusNode();

  bool _basePasswordValid = false;
  bool _passwordValid = false;
  bool _confPasswordValid = false;

  bool _passwordNotVisible = true;

  bool _changeBtnEnable = true;
  bool _changeBtnLoading = false;

  GlobalKey _passToolTipKey = GlobalKey();
  GlobalKey _confPassToolTipKey = GlobalKey();

  bool validateSignUp() {
    return _changeBtnEnable && _passwordValid && _confPasswordValid && _basePasswordValid;
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
            color: myBink, //change your color here
          ),
        ),
        body: SafeArea(
          child: Container(
            color: myBackground,
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        SvgPicture.asset(
                          "assets/change_password_icon.svg",
                        ),
                        Text(
                          'تغيير كلمة المرور',
                          style: TextStyle(fontFamily: fontHiding1, color: myBlue, fontSize: 36),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          onChanged: (text) {
                            setState(() {
                              _basePasswordValid = text.length > 0;
                            });
                          },
                          textInputAction: TextInputAction.next,
                          focusNode: _basePasswordFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, _basePasswordFocus, _passwordFocus);
                          },
                          controller: _basePasswordController,
                          obscureText: _passwordNotVisible,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: myBlue,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _passwordNotVisible = !_passwordNotVisible;
                                    });
                                  },
                                  child: Icon(_passwordNotVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
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
                            labelText: 'كلمة المرور القديمة',
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          onChanged: (text) {
                            setState(() {
                              _passwordValid = validator.password(text);
                            });
                          },
                          textInputAction: TextInputAction.next,
                          focusNode: _passwordFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(context, _passwordFocus, _confPasswordFocus);
                          },
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
                              child: GestureDetector(
                                  onTap: () {
                                    final dynamic tooltip = _passToolTipKey.currentState;
                                    tooltip.ensureTooltipVisible();
                                  },
                                  child: Tooltip(
                                    key: _passToolTipKey,
                                    child: Icon(
                                      Icons.help_outline,
                                      color: _passwordValid ? myBlue : Colors.red,
                                    ),
                                    message: _passwordValid
                                        ? "كلمة السر مقبولة"
                                        : "يجب ان تحتوي كلمة المرور على الاقل:\n حرف واحد كبير\n حرف واحد صغير\n رمز خاص (@ً، #، %، &، * او +) \n رقم واحد\n طول كلمة المرور لا يقل عن 8 خانات",
                                  )),
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
                            labelText: 'كلمة المرور',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _confPasswordValid = _passwordController.text == value;
                            });
                          },
                          textInputAction: TextInputAction.done,
                          focusNode: _confPasswordFocus,
                          onFieldSubmitted: (term) {
                            _confPasswordFocus.unfocus();
                          },
                          controller: _confPasswordController,
                          obscureText: _passwordNotVisible,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: myBlue,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                final dynamic tooltip = _confPassToolTipKey.currentState;
                                tooltip.ensureTooltipVisible();
                              },
                              child: Tooltip(
                                key: _confPassToolTipKey,
                                message: _confPasswordValid
                                    ? "تأكيد كلمة المرور متطابقة"
                                    : "تأكيد كلمة المرور غير متطابقة",
                                child: Icon(
                                  Icons.help_outline,
                                  color: _confPasswordValid ? myBlue : Colors.red,
                                ),
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
                            labelText: 'تاكيد كلمة المرور',
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: RaisedButton(
                            color: myBink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48.0),
                            ),
                            onPressed: validateSignUp() ? changePassword : null,
                            child: _changeBtnLoading
                                ? SpinKitRipple(
                                    color: Colors.white,
//                              type: SpinKitWaveType.start
                                  )
                                : Text('تغير كملة المرور', style: fontButtonStyle),
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
      ),
    );
  }

  void changePassword() async {
    setState(() {
      _changeBtnEnable = false;
      _changeBtnLoading = true;
    });

    try {
      final data = jsonEncode(
          {"old_password": _basePasswordController.text, "new_password": _passwordController.text});
      Map<String, String> userHeader = {
        'Authorization': 'Token ${Conn.token}',
        'Content-Type': 'application/json'
      };
      var passwordResponse =
          await post(Uri.parse(Conn.changPasswordURL), headers: userHeader, body: data);

      var responseString = passwordResponse.toString();
      if (passwordResponse.statusCode == 200) {
        await AwesomeDialog(
          headerAnimationLoop: false,
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: "تم تعديل كلمة المرور بنجاح",
          desc: ' ',
          btnOkText: 'موافق',
          btnOkColor: myBlue,
          btnOkOnPress: () {},
          dismissOnTouchOutside: true,
        ).show();
        Navigator.pop(context, true);
      } else if (passwordResponse.statusCode == 401) {
        Conn.logout();
        await AwesomeDialog(
                context: context,
                headerAnimationLoop: false,
                dialogType: DialogType.ERROR,
                animType: AnimType.SCALE,
                title: 'لا يمكن الوصول الى حسابك',
                desc: 'تم تسجيل الخروج',
                btnOkOnPress: () {},
                btnOkText: 'تم',
                btnOkColor: Colors.red)
            .show();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
            ModalRoute.withName('/'));
      } else {
        await AwesomeDialog(
                context: context,
                headerAnimationLoop: false,
                dialogType: DialogType.ERROR,
                animType: AnimType.SCALE,
                title: 'يوجد مشكلة غير معروفة',
                desc: responseString,
                btnOkOnPress: () {},
                btnOkText: 'تم',
                btnOkColor: Colors.red)
            .show();
      }
      setState(() {
        _changeBtnEnable = true;
        _changeBtnLoading = false;
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
    } catch (e) {
      print(e);
    }
  }
}
