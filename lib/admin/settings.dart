import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool messageNotifications = true;
  bool taskNotifications = true;
  bool rewardNotifications = true;

  bool _changeSettingsBtnLoading = false;

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
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        SvgPicture.asset(
                          "assets/settings_icon.svg",
                        ),
                        Text(
                          'الإعدادات',
                          style: TextStyle(
                              fontFamily: fontHiding1,
                              color: myBlue,
                              fontSize: 36),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'اشعارات الرسائل التوعوية',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontHiding2,
                                  color: myBlue),
                            ),
                            Switch(
                              value: messageNotifications,
                              onChanged: (value) {
                                messageNotifications = value;
                              },
                            )
                          ],
                        ),
                        Divider(
                          height: 5,
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'اشعارات الرسائل التوعوية',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontHiding2,
                                  color: myBlue),
                            ),
                            Switch(
                              value: messageNotifications,
                              onChanged: (value) {
                                messageNotifications = value;
                              },
                            )
                          ],
                        ),
                        Divider(
                          height: 5,
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'اشعارات الرسائل التوعوية',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontHiding2,
                                  color: myBlue),
                            ),
                            Switch(
                              value: messageNotifications,
                              onChanged: (value) {
                                messageNotifications = value;
                              },
                            )
                          ],
                        ),
                        Divider(
                          height: 5,
                          thickness: 2,
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
                            onPressed: changePassword,
                            child: _changeSettingsBtnLoading
                                ? SpinKitRipple(
                                    color: Colors.white,
//                              type: SpinKitWaveType.start
                                  )
                                : Text('حفظ الإعدادات', style: fontButtonStyle),
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

  void changePassword() async {}
}
