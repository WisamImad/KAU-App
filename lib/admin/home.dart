import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kau_app/admin/blogs.dart';
import 'package:kau_app/admin/blog_model.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:http/http.dart' as http;
import 'package:kau_app/utils/app_data.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/my_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Future<String> isLoadData() async {
    if (Data.blogList != null || Data.messageList != null) {
      return 'done';
    } else
      return loadData();
  }

  Future<String> loadData() async {
    try {
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      var messageResponse = await get(Uri.parse(Conn.messageURL), headers: userHeader);
      var blogResponse = await get(Uri.parse(Conn.blogURL), headers: userHeader);
      var messagesMap = jsonDecode(utf8.decode(messageResponse.bodyBytes));
      var blogMap = jsonDecode(utf8.decode(blogResponse.bodyBytes));
      if (messageResponse.statusCode == 200 && blogResponse.statusCode == 200) {
        if (messagesMap.length == 0) {
          Data.messageList = null;
        } else {
          setState(() {
            Data.messageList = messagesMap;
          });
        }
        if (blogMap.length == 0) {
          Data.blogList = null;
        } else {
          setState(() {
            Data.blogList = blogMap;
          });
        }

        return 'done';
      } else if (messageResponse.statusCode == 401 || blogResponse.statusCode == 401) {
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
        return 'UnAuthorized';
      } else {
        return "UnknownError";
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
      return 'done';
    }
    return "error";
  }

  late TabController _tabController;
  List<Tab> tabList = [];

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await loadData();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isLoadData(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget body;
        if (snapshot.data == "done") {
          body = SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  height: 30,
                  child: TabBar(
                      controller: _tabController,
                      unselectedLabelColor: myBink,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator:
                          BoxDecoration(borderRadius: BorderRadius.circular(24), color: myBink),
                      tabs: [
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
//                                border: Border.all(color: Colors.transparent, width: 0)
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "الرسائل التوعوية",
                                style: TextStyle(fontFamily: fontHiding2, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
//                                border: Border.all(color: myBink, width: 0)
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "تأملاتي",
                                style: TextStyle(fontFamily: fontHiding2, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: Center(
                              child: RefreshIndicator(
                            onRefresh: refreshList,
                            child: ListView(
                              children: Data.messageList != null
                                  ? Data.messageList!.map((message) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                                        child: MyCard(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.mail_outline,
                                                    color: myBlue,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      '${message['title']}',
                                                      style: TextStyle(
                                                          color: myBlue,
                                                          fontFamily: fontHiding2,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'منذ ${message['week']}',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: fontHiding2,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '${message['content']}',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontFamily: fontHiding2, color: myBlue),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList()
                                  : [
                                      Column(
                                        children: <Widget>[
                                          Icon(Icons.history),
                                          Text('لا يوجد رسائل سابقة')
                                        ],
                                      )
                                    ],
                            ),
                          )),
                        ),
                        Scaffold(
                          backgroundColor: myBackground,
                          floatingActionButton: FloatingActionButton(
                            backgroundColor: myBink,
                            onPressed: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddModifyBlog(
                                            isEdit: false,
                                            content: '',
                                            id: '',
                                            imageURL: '',
                                            title: '',
                                          )));
                              await refreshList();
                            },
                            child: Icon(
                              Icons.add,
                              size: 40,
                            ),
                          ),
                          body: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            child: Center(
                                child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => BlogModel()));
                                  },
                                  child: Text(
                                    "لمعرفة المزيد عن الكتابة التأملية اضغط هنا",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: myBlue,
                                      fontFamily: fontHiding2,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: refreshList,
                                    child: ListView(
                                      children: Data.blogList != null
                                          ? Data.blogList!.map((blog) {
                                              return Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                                child: MyCard(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.edit,
                                                            color: myBlue,
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: <Widget>[
                                                          Text(
                                                            '${blog['title']}',
                                                            style: TextStyle(
                                                              fontFamily: fontHiding2,
                                                              color: myBlue,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 250,
                                                            width: 250,
                                                            child: Image.network(
                                                              Conn.serverURL + blog['image'],
                                                              loadingBuilder: (BuildContext context,
                                                                  Widget child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                                if (loadingProgress == null)
                                                                  return child;
                                                                return Center(
                                                                  child: CircularProgressIndicator(
                                                                    value: loadingProgress
                                                                                .expectedTotalBytes !=
                                                                            null
                                                                        ? loadingProgress
                                                                                .cumulativeBytesLoaded /
                                                                            loadingProgress
                                                                                .expectedTotalBytes!
                                                                        : null,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '${blog['content']}',
                                                            style: TextStyle(
                                                                fontFamily: fontHiding2,
                                                                color: myBlue),
                                                          ),
                                                          Divider(
                                                            thickness: 1,
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              RaisedButton(
                                                                onPressed: () {},
                                                                color: Colors.white,
                                                                elevation: 0.0,
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Icon(
                                                                      Icons.visibility,
                                                                      color: Colors.grey,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      'مشاركة',
                                                                      style: TextStyle(
                                                                          fontFamily: fontHiding2,
                                                                          color: myBlue),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () async {
                                                                  await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              AddModifyBlog(
                                                                                id: "${blog['id']}",
                                                                                title:
                                                                                    blog['title'],
                                                                                content:
                                                                                    blog['content'],
                                                                                imageURL:
                                                                                    blog['image'],
                                                                                isEdit: true,
                                                                              )));
                                                                  await refreshList();
                                                                },
                                                                color: Colors.white,
                                                                elevation: 0.0,
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Icon(
                                                                      Icons.mode_edit,
                                                                      color: Colors.green,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      'تعديل',
                                                                      style: TextStyle(
                                                                          fontFamily: fontHiding2,
                                                                          color: myBlue),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () async {
                                                                  bool? areYouSure;
                                                                  await AwesomeDialog(
                                                                    headerAnimationLoop: false,
                                                                    context: context,
                                                                    dialogType: DialogType.WARNING,
                                                                    animType: AnimType.SCALE,
                                                                    title: 'هل انت متاكد',
                                                                    desc: 'هل ترغب بحذف المذكرة؟',
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
                                                                    try {
                                                                      var request =
                                                                          http.MultipartRequest(
                                                                              "DELETE",
                                                                              Uri.parse(
                                                                                  Conn.blogURL));
                                                                      request.fields["blog_id"] =
                                                                          "${blog['id']}";
                                                                      request.headers[
                                                                              'Authorization'] =
                                                                          'token ${Conn.token}';
                                                                      var response =
                                                                          await request.send();
                                                                      var responseData =
                                                                          await response.stream
                                                                              .toBytes();
                                                                      var responseString =
                                                                          String.fromCharCodes(
                                                                              responseData);
                                                                      if (response.statusCode ==
                                                                          200) {
                                                                        Scaffold.of(context)
                                                                            .showSnackBar(
                                                                                new SnackBar(
                                                                          backgroundColor: myBlue,
                                                                          content: new Text(
                                                                              'تم حذف التدوينة'),
                                                                        ));
                                                                        await refreshList();
                                                                      }
                                                                    } on SocketException {
                                                                      await AwesomeDialog(
                                                                              context: context,
                                                                              headerAnimationLoop:
                                                                                  false,
                                                                              dialogType:
                                                                                  DialogType.ERROR,
                                                                              animType:
                                                                                  AnimType.SCALE,
                                                                              title:
                                                                                  'لا يوجد اتصال بالإنترنت',
                                                                              desc:
                                                                                  'تاكد من توصيل الجهاز باإنترنت',
                                                                              btnOkOnPress: () {},
                                                                              btnOkText: 'تم',
                                                                              btnOkColor:
                                                                                  Colors.red)
                                                                          .show();
                                                                    } catch (e) {
                                                                      print(e);
                                                                    }
                                                                  }
                                                                },
                                                                color: Colors.white,
                                                                elevation: 0.0,
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Icon(
                                                                      Icons.delete,
                                                                      color: Colors.red,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      'حذف',
                                                                      style: TextStyle(
                                                                          fontFamily: fontHiding2,
                                                                          color: myBlue),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList()
                                          : [
                                              Column(
                                                children: <Widget>[
                                                  Icon(Icons.history),
                                                  Text(
                                                    'لا يوجد تأملات سابقة\n يرجى الضغط على زر + لإضافة تأملات جديدة',
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              )
                                            ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else if (snapshot.data == "UnknownError" || snapshot.hasError) {
          body = Container(
            child: Text("${snapshot.error}"),
          );
        } else if (snapshot.data == "ConnectionError") {
          bool load = false;
          body = Container();
        } else {
          body = LoadingPage();
        }
        return body;
      },
    );
  }
}
