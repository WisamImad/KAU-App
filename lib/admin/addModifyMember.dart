import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:async/async.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kau_app/User.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:path_provider/path_provider.dart';

class AddModifyMember extends StatefulWidget {
  bool? isEdit;
  Member? member;

  AddModifyMember({this.isEdit, this.member});

  @override
  _AddModifyMemberState createState() => _AddModifyMemberState();
}

class _AddModifyMemberState extends State<AddModifyMember> {
  final _nameController = TextEditingController();

  final _nameFocus = FocusNode();
  final _roleFocus = FocusNode();

  bool _nameValid = true;

  bool _editBtnLoading = false;
  bool _editBtnEnable = true;
  bool _retryLoading = false;

  bool isSecondAdmin = false;
  String? _selectedRole;
  String _birthday = 'لم يتم التحديد';
  Future<File>? imageFile;
  File? _image;
  List roleList = [
    {"name": "أم", "id": 1},
    {"name": "أب", "id": 2},
    {"name": "بنت", "id": 4},
    {"name": "إبن", "id": 3},
  ];

  String _errorMessage = "";

  Future<String> loadData() async {
    return "done";
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  onSwitchValueChanged(bool newVal) {
    setState(() {
      isSecondAdmin = newVal;
    });
  }

  _editValidation() {
    return _nameValid &&
        _selectedRole != null &&
        _birthday != 'لم يتم التحديد' &&
        _editBtnEnable;
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data!,
            width: 300,
            height: 100,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Image(
            image: AssetImage('assets/avatar_upload.png'),
          );
        }
      },
    );
  }

//Open gallery
  /*
  pickImageFromGallery(ImageSource source) async{
    setState(() {
    final XFile?  imageFile =await ImagePicker.pickImage(source: source);
    });
  }
  */
  gallaryphoto(ImageSource source) async {
    final PickedFile = await ImagePicker().getImage(source: source);
    final bytes = await PickedFile?.readAsBytes();
    setState(() {
      _image = File(PickedFile!.path);
    });
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    Response response = await get(Uri.parse(Conn.serverURL + imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      imageFile = urlToFile(widget.member!.picURL!);
      _nameController.text = widget.member!.name!;
      _birthday = widget.member!.birthday!;
      _selectedRole = widget.member!.role!['id'].toString();
      isSecondAdmin = widget.member!.level! <= 1;
    } else {
      imageFile = getImageFileFromAssets('avatar_upload.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: myBackground,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: myBink, //change your color here
            ),
            title: Text(
              widget.isEdit! ? "تعديل الملف الشخصي" : "اضافة",
              style: TextStyle(
                fontFamily: fontHiding1,
                fontSize: 25,
                color: myBink,
              ),
            ),
            backgroundColor: myBackground,
            centerTitle: true,
            elevation: 0.0,
          ),
          body: FutureBuilder(
            future: loadData(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              Widget body;
              if (snapshot.data == "done") {
                body = GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  // width: 100,
                                  child: GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Container(
                                                    width: double.maxFinite,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            4.5,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: SizedBox(
                                                            // height: 100,
                                                            child: RaisedButton(
                                                              color:
                                                                  Colors.white,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    color:
                                                                        myBlue,
                                                                    size: 60,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    'التقاط صورة',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          fontHiding2,
                                                                      color:
                                                                          myBlue,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )
                                                                ],
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  gallaryphoto(
                                                                      ImageSource
                                                                          .camera);
                                                                });
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            // height: MediaQuery.of(context).size.height/3,
                                                            child: RaisedButton(
                                                              color:
                                                                  Colors.white,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .add_photo_alternate,
                                                                    color:
                                                                        myBlue,
                                                                    size: 60,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    'اختيار من الالبوم',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            fontHiding2,
                                                                        color:
                                                                            myBlue,
                                                                        fontSize:
                                                                            18),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )
                                                                ],
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  gallaryphoto(
                                                                      ImageSource
                                                                          .gallery);
                                                                });
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: showImage())),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.isEdit! ? "${widget.member!.name}" : "",
                                style: TextStyle(
                                    fontFamily: fontHiding2,
                                    color: myBlue,
                                    fontSize: 20),
                              ),
                              Text(
                                widget.isEdit!
                                    ? '${widget.member!.role!['name']}'
                                    : "",
                                style: TextStyle(
                                    fontFamily: fontHiding2,
                                    color: myBink,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              TextFormField(
                                onChanged: (text) {
                                  setState(() {
                                    _nameValid = text.length >= 2;
                                  });
                                },
                                textInputAction: TextInputAction.next,
                                focusNode: _nameFocus,
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      Icons.perm_identity,
                                      color: myBlue,
                                      size: 30,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: myBlue, width: 1.0),
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: fontHiding2, color: myBlue),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  focusColor: Colors.white,
                                  disabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  labelText: 'الإسم',
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              RaisedButton(
                                color: myBackground,
                                disabledColor: myBackground,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                elevation: 2.0,
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      theme: DatePickerTheme(
                                        containerHeight: 210.0,
                                      ),
                                      showTitleActions: true,
                                      onConfirm: (date) {
                                    setState(() {
                                      _birthday =
                                          "${date.year}-${date.month}-${date.day}";
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.ar);
                                  setState(() {});
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.event,
                                            color: myBlue,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "الميلاد:",
                                                style: TextStyle(
                                                    color: myBlue,
                                                    fontSize: 13.0,
                                                    fontFamily: fontHiding2),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                "$_birthday",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 60,
                                child: DropdownButton<String>(
                                  value: _selectedRole,
                                  isExpanded: true,
                                  icon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.arrow_drop_down),
                                  ),
                                  style: TextStyle(color: Colors.black),
                                  hint: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.face,
                                            color: myBlue,
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'اختر صلة القرابة',
                                          style: TextStyle(
                                              color: myBlue,
                                              fontSize: 18,
                                              fontFamily: fontHiding2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  focusNode: _roleFocus,
                                  underline: Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedRole = newValue!;
                                      // print(_selectedRole);
                                    });
                                  },
                                  items: roleList.map((item) {
                                    return new DropdownMenuItem(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Icon(
                                              Icons.face,
                                              color: myBlue,
                                              size: 30,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('${item['name']}'),
                                        ],
                                      ),
                                      value: item['id'].toString(),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Switch(
                                      value: isSecondAdmin,
                                      onChanged: (newVal) {
                                        onSwitchValueChanged(newVal);
                                      }),
                                  Text(
                                    'إضافة كمشرف ثاني',
                                    style: TextStyle(
                                        color: myBlue,
                                        fontSize: 18,
                                        fontFamily: fontHiding2),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 48,
                                width: double.infinity,
                                child: RaisedButton(
                                  color: myBink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  onPressed:
                                      _editValidation() ? _editAdd : null,
                                  child: _editBtnLoading
                                      ? SpinKitRipple(
                                          color: Colors.white,
//                              type: SpinKitWaveType.start
                                        )
                                      : Text(widget.isEdit! ? 'تعديل' : 'إضافة',
                                          style: fontButtonStyle),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.data == "UnAuthorized") {
                body = Container(
                  child: Text('UnAuthorized'),
                );
              } else if (snapshot.data == "UnknownError" || snapshot.hasError) {
                body = Container(
                  child: Text("${snapshot.error}"),
                );
              } else {
                body = Center(
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
              return body;
            },
          )),
    );
  }

  _editAdd() async {
    setState(() {
      _editBtnLoading = true;
      _editBtnEnable = false;
    });

    try {
      File? file;
      await imageFile!.then((value) => file = value);

      var stream = new ByteStream(DelegatingStream.typed(file!.openRead()));
      var length = await file!.length();
      //create multipart request for POST or PATCH method
      var request = MultipartRequest(
          widget.isEdit! ? "PUT" : "POST", Uri.parse(Conn.memberURL));
      if (widget.isEdit!) {
        request.fields["member_username"] = widget.member!.username ?? "";
      }

      request.fields["name"] = _nameController.text;
      request.fields["birthday"] = _birthday;
      request.fields["role"] = _selectedRole ?? "";
      request.fields["permission"] = isSecondAdmin ? "1" : "2";
      print(request.fields['permission']);
      request.headers['Authorization'] = 'token ${Conn.token}';

      //create multipart using filepath, string or bytes
      var pic = MultipartFile("pic", stream, length,
          filename: "${DateTime.now()}.png");
      //add multipart to request
      request.files.add(pic);
      var response = await request.send();

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        await AwesomeDialog(
          headerAnimationLoop: false,
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title:
              widget.isEdit! ? 'تم تعديل البيانات بنجاح' : "تم الاضافة بنجاح",
          desc: ' ',
          btnOkText: 'موافق',
          btnOkColor: myBlue,
          btnOkOnPress: () {},
          dismissOnTouchOutside: true,
        ).show();
        setState(() {
          _editBtnLoading = false;
        });
        Navigator.pop(context, true);
      } else if (response.statusCode == 401) {
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
        _editBtnEnable = true;
        _editBtnLoading = false;
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
        _editBtnEnable = true;
        _editBtnLoading = false;
      });
      return;
    } catch (e) {
      print(e);
    }
  }
}
