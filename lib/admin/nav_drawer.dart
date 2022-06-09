import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:kau_app/admin/changePassword.dart';
import 'package:kau_app/admin/settings.dart';
import 'package:kau_app/admin/terms_conditions.dart';
import 'package:kau_app/admin/privacy_policy.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/routing/CupertinoPageRoute.dart';
import 'package:kau_app/utils/app_data.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'about.dart';
import 'profile.dart';

class NavDrawer extends StatefulWidget {
  Map? user;

  NavDrawer({this.user});

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 30.0,
                  backgroundImage: Data.user == null ? AssetImage('assets/avatar.png') : Data.user!['pic'],
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    '${widget.user == null ? "username" : widget.user!['name']}',
                    style: TextStyle(color: myBlue, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: myBink,
            ),
            title: Text('الملف الشخصي'),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => AdminProfile()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.lock_outline,
              color: myBink,
            ),
            title: Text('تغير كلمة المرور'),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => ChangePasswordPage()));
            },
          ),
          // ListTile(
          //   leading: Icon(
          //     Icons.settings,
          //     color: myBink,
          //   ),
          //   title: Text('الإعدادات'),
          //   onTap: (){
          //     Navigator.of(context).push(
          //         CupertinoPageRoute(builder: (context) => SettingsPage()));
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.format_list_numbered_rtl,
              color: myBink,
            ),
            title: Text('الشروط والأحكام'),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => ConditionsPage()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.verified_user,
              color: myBink,
            ),
            title: Text('الخصوصية'),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PrivacyPage()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: myBink,
            ),
            title: Text('عن التطبيق'),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => AboutPage()));
            },
          ),
          SizedBox(
            height: 30,
          ),
          Divider(),
          Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.red),
                      title: Text('تسجيل الخروج'),
                      onTap: () async {
                        bool? areYouSure;
                        await AwesomeDialog(
                          headerAnimationLoop: false,
                          context: context,
                          dialogType: DialogType.WARNING,
                          animType: AnimType.SCALE,
                          title: 'هل انت متاكد',
                          desc: 'هل ترغب بتسجيل الخروج؟',
                          btnOkOnPress: () {
                            setState(() {
                              areYouSure = true;
                            });
                          },
                          btnOkText: 'موافق',
                          btnOkColor: myBlue,
                          btnCancelOnPress: () {
                            setState(() {
                              areYouSure = false;
                            });
                          },
                          btnCancelText: "الغاء",
                          btnCancelColor: Colors.red,
                          dismissOnTouchOutside: false,
                        ).show();
                        if (areYouSure!) {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WelcomePage()), ModalRoute.withName('/'));
                          Conn.logout();
                        }
                      }))),
        ],
      ),
    );
  }
}
