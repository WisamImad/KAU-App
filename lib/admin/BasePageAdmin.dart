import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kau_app/admin/reward.dart';
import 'package:kau_app/admin/tasks.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_data.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/my_widget.dart';
import 'package:kau_app/utils/connection.dart';
import 'nav_drawer.dart';
import 'family.dart';
import 'home.dart';
import 'notifications.dart';

class BasePageAdmin extends StatefulWidget {
  @override
  _BasePageAdminState createState() => _BasePageAdminState();
}

class _BasePageAdminState extends State<BasePageAdmin> {
  int _selectedIndex = 1;

  List<String> titles = [
    '',
    'المهام',
    'عائلتي',
    'المكافئات',
    'الإشعارات',
  ];

  static final List<Widget> bodys = <Widget>[
    HomePage(),
    TasksPage(),
    FamilyPage(),
    RewardPage(),
    NotificationsPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Map? user;

  Future<String> loadData() async {
    try {
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      var userResponse =
          await get(Uri.parse(Conn.userInfoURL), headers: userHeader);
      var userMap = jsonDecode(utf8.decode(userResponse.bodyBytes));
      // print(userMap);
      if (userResponse.statusCode == 200) {
        user = userMap['user'];
        Data.user = user!;
        Data.user!['pic'] = NetworkImage(Conn.serverURL + user!['pic']);

        return 'done';
      } else if (userResponse.statusCode == 401) {
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
        return 'done';
      }
    } on SocketException {
      print(SocketException);
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
      return "ConnectionError";
    } catch (e) {
      print(e);
    }
    return "done";
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FutureBuilder(
        future: loadData(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget returnWidget;

          if (snapshot.data == 'done') {
            returnWidget = Scaffold(
              key: _scaffoldKey,
              drawer: NavDrawer(
                user: user!,
              ),
              backgroundColor: myBackground,
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                leading: _selectedIndex == 0
                    ? IconButton(
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                        icon: Container(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 30.0,
                            backgroundImage: user == null
                                ? AssetImage('assets/avatar.png')
                                : user!['pic'],
                          ),
                        ),
                      )
                    : Container(),
                title: Text(
                  _selectedIndex == 0
                      ? user == null
                          ? "username"
                          : user!['name']
                      : titles.elementAt(_selectedIndex),
                  style: TextStyle(
                    fontFamily: _selectedIndex == 0 ? fontHiding2 : fontHiding1,
                    fontSize: _selectedIndex == 0 ? 18 : 25,
                    color: myBlue,
                  ),
                ),
                backgroundColor: myBackground,
                centerTitle: _selectedIndex != 0,
                elevation: 0.0,
              ),
              body: bodys[_selectedIndex],
              bottomNavigationBar: Container(
                height: 80,
                child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      backgroundColor: Colors.white,
                      icon: Icon(
                        Icons.home,
                      ),

                      label: 'الرئيسية',
                      // style: TextStyle(fontFamily: fontHiding2),
                      // ),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list),
                      label: 'المهام',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.group,
                      ),
                      label: 'عائلتي',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.card_giftcard,
                      ),
                      label: 'المكافئات',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.notifications_none,
                      ),
                      label: 'الإشعارات',
                    ),
                  ],
                  showUnselectedLabels: true,
                  currentIndex: _selectedIndex,
                  selectedItemColor: myBink,
                  unselectedItemColor: myBlue,
                  onTap: _onItemTapped,
                ),
              ),
            );
          } else if (snapshot.data == 'ConnectionError') {
            returnWidget = Scaffold(
                body: NoInternetPage(
              context: context,
            ));
            ;
          } else if (snapshot.data == "null" || snapshot.hasError) {
            returnWidget = Scaffold(body: NoInternetPage());
          } else {
            returnWidget = Scaffold(
              body: LoadingPage(),
              backgroundColor: myBackground,
            );
          }
          return returnWidget;
        },
      ),
    );
  }
}
