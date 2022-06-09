import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:kau_app/routing/CupertinoPageRoute.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _passwordController = TextEditingController();
  final _confPasswordController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _confPasswordFocus = FocusNode();
  final _familyNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _roleFocus = FocusNode();

  bool _passwordValid = false;
  bool _confPasswordValid = false;
  bool _familyNameValid = false;
  bool _emailValid = false;
  bool _nameValid = false;

  bool _passwordNotVisible = true;

  bool _signUpBtnEnable = true;
  bool _signUpBtnLoading = false;

  String? _selectedRole;
  String? _birthday;
  List roleList = [
    {"name": "ام", "id": 1},
    {"name": "اب", "id": 2},
  ];

  GlobalKey _passToolTipKey = GlobalKey();
  GlobalKey _confPassToolTipKey = GlobalKey();
  GlobalKey _emailToolTipKey = GlobalKey();

  String _signUpErrorMessage = "";

  bool validateSignUp() {
    return _passwordValid && _confPasswordValid && _familyNameValid && _signUpBtnEnable && _nameValid && _selectedRole != null && _birthday != null && _emailValid;
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
                        "assets/create_family_icon.svg",
                      ),
                      Text(
                        'إنشاء عائلة',
                        style: TextStyle(fontFamily: fontHiding1, color: myBlue, fontSize: 34),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _nameValid = text.length >= 2;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: _nameFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _nameFocus, _familyNameFocus);
                        },
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: myBlue,
                            size: 30,
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
                          labelText: 'اسمك',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        value: _selectedRole,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        hint: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            "اختر صفتك في العائلة",
                            style: TextStyle(fontSize: 18, color: myBlue, fontFamily: fontHiding2),
                          ),
                        ),
                        focusNode: _roleFocus,
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue;
                            // print(_selectedRole);
                          });
                        },
                        items: roleList.map((item) {
                          return new DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: new Text(
                                item['name'],
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            value: item['id'].toString(),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        // color: Colors.white,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(2.0)),
                        // elevation: 2.0,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true, onConfirm: (date) {
                            // print('confirm $date');
                            _birthday = "${date.year}-${date.month}-${date.day}";
                            setState(() {});
                          }, currentTime: DateTime.now(), locale: LocaleType.ar);
                          setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.event,
                                    color: myBlue,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "تاريخ ميلادك",
                                    style: TextStyle(color: myBlue, fontSize: 16.0, fontFamily: fontHiding2),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                            _birthday == null ? "لم يتم التحديد" : "$_birthday",
                                            style: TextStyle(color: myBlue, fontFamily: fontHiding2, fontSize: 16.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _familyNameValid = text.length >= 3;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: _familyNameFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _familyNameFocus, _emailFocus);
                        },
                        controller: _familyNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: myBlue,
                            size: 30,
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
                          labelText: 'اسم العائلة',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _emailValid = validator.email(text);
                          });
                        },
                        textInputAction: TextInputAction.next,
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
                        height: 10,
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
                                    child: Icon(_passwordNotVisible ? Icons.visibility : Icons.visibility_off)),
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
                              message: _confPasswordValid ? "تأكيد كلمة المرور متطابقة" : "تأكيد كلمة المرور غير متطابقة",
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
                      Text(
                        _signUpErrorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: fontHiding2, fontSize: 20, color: Colors.red),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          // color: myBink,
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(48.0),
                          // ),
                          style: ElevatedButton.styleFrom(
                            primary: myBink,
                          ),
                          onPressed: validateSignUp() ? _signUp : null,
                          child: _signUpBtnLoading
                              ? SpinKitRipple(
                                  color: Colors.white,
//                              type: SpinKitWaveType.start
                                )
                              : Text('إنشاء', style: fontButtonStyle),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => LoginPage()));
                          },
                          child: Text(
                            'هل لديك حساب؟ تسجيل الدخول',
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

  void _signUp() async {
    print('enter signup');
    setState(() {
      _signUpBtnEnable = false;
      _signUpBtnLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = jsonEncode({
        "username": _emailController.text,
        "password": _passwordController.text,
        "name": _nameController.text,
        "family": _familyNameController.text,
        "birthday": _birthday,
        "role": int.parse(_selectedRole!),
      });
      Map<String, String> userHeader = {'Content-Type': 'application/json'};

      var response = await post(Uri.parse(Conn.signUpURL), body: data, headers: userHeader);
      print(response);
      var responseMap = jsonDecode(utf8.decode(response.bodyBytes));
      print(responseMap);
      if (response.statusCode == 200) {
        try {
          var request = MultipartRequest("POST", Uri.parse(Conn.setNotificationTokenURL));
          request.fields["push_notification_token"] = prefs.getString('NotificationToken')!;
          request.headers['Authorization'] = 'token ${Conn.token}';
          var response = await request.send();
          //Get the response from the server
          print('set token');
          if (response.statusCode == 200) {
          } else if (response.statusCode == 401) {
            Conn.logout();
          }
        } catch (e) {}
        Conn.token = responseMap['token'];
        await prefs.setString("token", Conn.token ?? "");
        await prefs.setBool("isLogin", true);
        await prefs.setBool("isAdmin", true);
        Navigator.of(context).pushNamedAndRemoveUntil('/admin', (Route<dynamic> route) => false);
        setState(() {
          _signUpBtnEnable = true;
          _signUpBtnLoading = false;
        });
      } else if (response.statusCode == 400 && (responseMap.keys.elementAt(0) == "username") && responseMap['username'][0] == "A user with that username already exists.") {
        _signUpErrorMessage = "البريد الإلكتروني مضاف مسبقا\n يرجى تغير البريد او قم بتسجيل الدخول";
      } else {
        await AwesomeDialog(
                context: context,
                headerAnimationLoop: false,
                dialogType: DialogType.ERROR,
                animType: AnimType.SCALE,
                title: 'يوجد مشكلة غير معروفة',
                desc: responseMap.toString(),
                btnOkOnPress: () {},
                btnOkText: 'تم',
                btnOkColor: Colors.red)
            .show();
        setState(() {
          _signUpBtnEnable = true;
          _signUpBtnLoading = false;
        });
        // _signUpErrorMessage = responseMap.toString();
      }
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
        _signUpBtnEnable = true;
        _signUpBtnLoading = false;
      });
      return;
    } catch (e) {
      setState(() {
        _signUpBtnEnable = true;
        _signUpBtnLoading = false;
      });
      print(e);
      print('**************************************************');
    }
  }
}
