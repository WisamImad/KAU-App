import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:async/async.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/my_widget.dart';
import 'package:path_provider/path_provider.dart';

class AddModifyReward extends StatefulWidget {
  bool? isEdit;
  Map? reward;

  AddModifyReward({this.isEdit, this.reward});

  @override
  _AddModifyRewardState createState() => _AddModifyRewardState();
}

class _AddModifyRewardState extends State<AddModifyReward> {
  final _nameController = TextEditingController();
  final _scoreController = TextEditingController();
  final _linkController = TextEditingController();

  bool firstEdit = true;

  final _nameFocus = FocusNode();
  final _scoreFocus = FocusNode();
  final _linkFocus = FocusNode();
  File? _image;
  bool imageValid = false;

  bool _editBtnLoading = false;
  bool _editBtnEnable = true;

  Future<XFile>? imageFile;

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _editValidation() {
    return _nameController.text.length > 0 &&
        _scoreController.text.length > 0 &&
        _editBtnEnable;
  }

  Widget showImage() {
    return FutureBuilder<XFile?>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          imageValid = true;
          return Image.file(
            File(snapshot.data!.path),
            width: 300,
            height: 50,
          );
        } else if (snapshot.error != null) {
          imageValid = false;
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          imageValid = false;
          return Text('لم يتم اختيار صورة');
        }
      },
    );
  }

//Open gallery
/*
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker().pickImage(source: source);
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
    if (widget.isEdit!) {
      _nameController.text = widget.reward!['name'];
      _scoreController.text = "${widget.reward!['score']}";
      _linkController.text = widget.reward!['link'];
      imageFile = urlToFile(widget.reward!['picture']) as Future<XFile>?;
      imageValid = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: myBackground,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              Navigator.pop(context, () {
                setState(() {});
              });
            },
          ),
          iconTheme: IconThemeData(
            color: myBink, //change your color here
          ),
          title: Text(
            widget.isEdit! ? "تعديل مكافئة" : "مكافئة جديدة",
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
        body: GestureDetector(
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
                      MyCard(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                focusNode: _nameFocus,
                                onFieldSubmitted: (e) {
                                  _fieldFocusChange(
                                      context, _nameFocus, _scoreFocus);
                                },
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
                                  labelText: 'إسم المكافئة',
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                focusNode: _scoreFocus,
                                onFieldSubmitted: (e) {
                                  _fieldFocusChange(
                                      context, _scoreFocus, _linkFocus);
                                },
                                controller: _scoreController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                ],
                                maxLength: 2,
                                decoration: InputDecoration(
                                  counter: Container(),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      Icons.star,
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
                                  labelText: 'عدد النقاط',
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.done,
                                focusNode: _linkFocus,
                                onFieldSubmitted: (e) {
                                  _linkFocus.unfocus();
                                },
                                controller: _linkController,
                                decoration: InputDecoration(
                                  counter: Container(),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      Icons.link,
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
                                  labelText: 'رابط المكافئة',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyCard(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.image,
                                        color: myBink,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        'صورة',
                                        style: TextStyle(
                                            fontFamily: fontHiding2,
                                            color: myBlue,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            gallaryphoto(ImageSource.camera);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            gallaryphoto(ImageSource.gallery);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.photo_library,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              showImage(),
                            ],
                          ),
                        ),
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
                          onPressed: _editValidation() ? _editAdd : null,
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
        ),
      ),
    );
  }

  _editAdd() async {
    setState(() {
      _editBtnLoading = true;
      _editBtnEnable = false;
    });
    try {
      //create multipart request for POST or PATCH method
      var request = MultipartRequest(
          widget.isEdit! ? "PUT" : "POST", Uri.parse(Conn.rewardURL));
      if (widget.isEdit!) {
        print("${widget.reward!['id']}");
        request.fields["reward_id"] = "${widget.reward!['id']}";
        request.fields["user"] = "${widget.reward!['user']}";
      }

      request.fields["name"] = _nameController.text;
      request.fields["score"] = _scoreController.text;
      request.fields["link"] = _linkController.text;
      request.fields["text"] = 'text';

      request.headers['Authorization'] = 'token ${Conn.token}';

      //create multipart using filepath, string or bytes

      if (imageValid) {
        // print('**********');
        File? file;
        await imageFile?.then((value) => file = value as File?);
        var stream = new ByteStream(DelegatingStream.typed(file!.openRead()));
        var length = await file!.length();
        var pic = MultipartFile("picture", stream, length,
            filename: "${DateTime.now()}.png");
        //add multipart to request
        request.files.add(pic);
      }
      // print(request.fields);
      var response = await request.send();

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = utf8.decode(responseData);
      print(responseString);
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
        Navigator.pop(context, () {
          setState(() {});
        });
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
                title: 'يوجد مشكلة',
                desc: responseString,
                btnOkOnPress: () {},
                btnOkText: 'تم',
                btnOkColor: Colors.red)
            .show();
      }
      setState(() {
        _editBtnLoading = false;
        _editBtnEnable = true;
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
      return 'done';
    } catch (e) {
      print(e);
      setState(() {
        _editBtnLoading = false;
        _editBtnEnable = true;
      });
    }
  }
}
