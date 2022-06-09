import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:regexed_validator/regexed_validator.dart';

class SetNewPassword extends StatefulWidget {
  String? username;

  SetNewPassword({this.username});

  @override
  _SetNewPasswordState createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final _passwordController = TextEditingController();
  final _confPasswordController = TextEditingController();
  final _pinController = TextEditingController();
  final _passwordFocus = FocusNode();
  final _confPasswordFocus = FocusNode();
  final _pinFocus = FocusNode();
  bool _passwordValid = false;
  bool _confPasswordValid = false;
  bool _pinValid = false;
  bool _passwordNotVisible = true;

  GlobalKey _passToolTipKey = GlobalKey();
  GlobalKey _confPassToolTipKey = GlobalKey();
  GlobalKey _emailToolTipKey = GlobalKey();

  String? _message;

  bool _btnEnable = true;
  bool _btnLoading = false;

  bool validateSetPassword() {
    return _pinValid && _btnEnable && _passwordValid && _confPasswordValid;
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
                        'ادخل كلمة المرور الجديدة',
                        style: TextStyle(fontFamily: fontHiding1, color: myBlue, fontSize: 34),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _pinValid = text.length == 6;
                          });
                        },
                        maxLength: 10,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        controller: _pinController,
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
                              message: _pinValid ? "صيغة الرمز صحيحة" : "ضيغة الرمز غير صحيحة",
                              child: Icon(
                                Icons.help_outline,
                                color: _pinValid ? myBlue : Colors.red,
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
                          labelText: 'رمز الاستعادة',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _passwordValid = validator.mediumPassword(text);
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
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
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
                              ],
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
                        height: 10,
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
                          onPressed: validateSetPassword() ? setPassword : null,
                          child: _btnLoading
                              ? SpinKitRipple(
                                  color: Colors.white,
                                )
                              : Text('تغير كلمة المرور', style: fontButtonStyle),
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

  void setPassword() async {
    setState(() {
      _btnEnable = false;
      _btnLoading = true;
    });
    try {
      final data = jsonEncode({
        "username": widget.username,
        'pin': _pinController.text,
        'new_password': _passwordController.text
      });
      Map<String, String> userHeader = {'Content-Type': 'application/json'};

      var response = await put(Uri.parse(Conn.restorePasswordURL), body: data, headers: userHeader);
      print(response.statusCode);

      var responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      // print(responseMap);
      if (response.statusCode == 200) {
        _message = 'تم تغير كلمة المرور';
        await AwesomeDialog(
          headerAnimationLoop: false,
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: 'تم تغير كلمة المرور بنجاح',
          desc: 'الرجاء تسجيل الدحول بكلمة المرور الجديدة',
          btnOkText: 'موافق',
          btnOkColor: myBlue,
          btnOkOnPress: () {},
          dismissOnTouchOutside: true,
        ).show();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
            ModalRoute.withName('/'));
      } else if (response.statusCode == 406) {
        await AwesomeDialog(
          headerAnimationLoop: false,
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.SCALE,
          title: 'انتهت صلاحية رمز الاستعادة',
          desc: 'الرجاء اعادة عملية ارسال الرمز',
          btnOkText: 'موافق',
          btnOkColor: Colors.redAccent,
          btnOkOnPress: () {},
          dismissOnTouchOutside: true,
        ).show();
      } else if (response.statusCode == 404) {
        await AwesomeDialog(
          headerAnimationLoop: false,
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.SCALE,
          title: 'رمز الاستعادة غير صحصح',
          desc: 'الرجاءالتاكد من الرمز او اعادة ارساله',
          btnOkText: 'موافق',
          btnOkColor: Colors.redAccent,
          btnOkOnPress: () {},
          dismissOnTouchOutside: true,
        ).show();
      } else {
        _message = responseMap;
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
