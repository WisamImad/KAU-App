import 'dart:math';

import 'package:async/async.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/children/paint.dart';
import 'package:kau_app/children/send_voice.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:sliding_sheet/sliding_sheet.dart';

class sendMessage extends StatefulWidget {
  List? stickers;
  bool? isFromStory = false;
  sendMessage({this.stickers, this.isFromStory});

  @override
  _sendMessageState createState() => _sendMessageState();
}

class _sendMessageState extends State<sendMessage> {
  int step = 1;
  String? typeMessage; //the type of message image or voice

  File? _image;
  Future<File>? stickerImage;
  int? indexSticker;

  bool record = false;

  Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    Response response = await get(Uri.parse(Conn.serverURL + imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  void showAsBottomSheet() async {
    List images = widget.stickers!;
    print(images);
    final result = await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 20,
        cornerRadius: 23,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.5, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return Container(
            height: 500,
            child: Center(
              child: Material(
                child: InkWell(
                  onTap: () => Navigator.pop(context, true),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      itemCount: images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        print(images[index]['image']);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              step = 2;
                              typeMessage = "image";
                              stickerImage = urlToFile(images[index]['image']);
                              indexSticker = index;
                            });
                            Navigator.pop(context);
                          },
                          child: Card(
                            child: GridTile(
                              child: Image.network(Conn.serverURL +
                                  images[index][
                                      'image']), //just for testing, will fill with image later
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });

    // print(result); // This is the result.
  }

  @override
  void initState() {
    super.initState();
  }
/*
 _imgFromCamera() async {
    if (widget.isFromStory!){

    }
    File image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      setState(() {
        step = 2;
        typeMessage = "image";
        _image = image;
      });
    }
  }*/

  _imgFromCamera() async {
    if (widget.isFromStory!) {}
    final PickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    final bytes = await PickedFile?.readAsBytes();
    if (_image != null) {
      setState(() {
        step = 2;
        typeMessage = "image";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      "assets/children/child_avatar${ChildUserInfo.child!['image_in_app']}.png",
                      height: SizeConfig.safeBlockVertical! * 17,
                      width: SizeConfig.safeBlockHorizontal! * 10,
                    ),
                    Stack(
                      // overflow: Overflow.visible,
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: SizeConfig.safeBlockVertical! * 4,
                            ),
                            Container(
                              height: SizeConfig.safeBlockVertical! * 80,
                              width: SizeConfig.safeBlockHorizontal! * 75,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/children/message_border.png",
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              padding: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical! * 5,
                                  right: 5),
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    alignment: AlignmentDirectional.topCenter,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/children/title_pic1.png",
                                        height:
                                            SizeConfig.safeBlockVertical! * 15,
                                        width: SizeConfig.safeBlockHorizontal! *
                                            80,
                                        fit: BoxFit.fill,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: 20,
                                            top: SizeConfig.safeBlockVertical! *
                                                1),
                                        child: Text(
                                          step == 1 ? 'ارسال رسالة' : 'الرسائل',
                                          style: TextStyle(
                                              fontSize: SizeConfig
                                                      .safeBlockVertical! *
                                                  6.5,
                                              fontFamily: 'ge_ss',
                                              fontWeight: FontWeight.bold,
                                              color: chBlue),
                                        ),
                                      )
                                    ],
                                  ),
                                  stepWidgets()!
                                ],
                              ),
                            )
                          ],
                        ),
                        step == 2
                            ? Positioned(
                                bottom: SizeConfig.safeBlockVertical! * 12,
                                left: -SizeConfig.safeBlockHorizontal! * 5,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _send();
                                      step = 3;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "assets/children/button_green1.png",
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    height: SizeConfig.safeBlockVertical! * 15,
                                    width: SizeConfig.safeBlockHorizontal! * 16,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        right: SizeConfig.safeBlockHorizontal! *
                                            2),
                                    child: Text(
                                      'ارسال ',
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockVertical! *
                                                  5.5,
                                          fontFamily: 'ge_ss',
                                          fontWeight: FontWeight.bold,
                                          color: chBlue),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "assets/children/back_icon.png",
                        height: SizeConfig.safeBlockVertical! * 10,
                        width: SizeConfig.safeBlockHorizontal! * 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? stepWidgets() {
    if (step == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => sendVoiceState()),
              );
            },
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/children/border.png",
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                height: SizeConfig.safeBlockVertical! * 55,
                width: SizeConfig.safeBlockHorizontal! * 35,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/children/mic_icon.png",
                  fit: BoxFit.contain,
                  height: SizeConfig.safeBlockVertical! * 30,
                  width: SizeConfig.safeBlockHorizontal! * 20,
                )),
          ),
          GestureDetector(
            onTap: () {
              if (widget.isFromStory!) {
                setState(() {
                  showAsBottomSheet();
                });
              } else {
                _imgFromCamera();
              }
            },
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/children/border.png",
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                height: SizeConfig.safeBlockVertical! * 55,
                width: SizeConfig.safeBlockHorizontal! * 35,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/children/camera_icon.png",
                  fit: BoxFit.contain,
                  height: SizeConfig.safeBlockVertical! * 30,
                  width: SizeConfig.safeBlockHorizontal! * 20,
                )),
          ),
        ],
      );
    } else if (step == 2) {
      return Container(
        height: SizeConfig.safeBlockVertical! * 40,
        width: SizeConfig.safeBlockHorizontal! * 40,
        alignment: Alignment.center,
        child: typeMessage == 'image'
            ? widget.isFromStory!
                ? Image.network(
                    Conn.serverURL + widget.stickers![indexSticker!]["image"])
                : Image.file(
                    _image!,
                    fit: BoxFit.contain,
                  )
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sendVoiceState()),
                  );
                },
                child: Image.asset(
                  "assets/children/message_voice1.png",
                  fit: BoxFit.contain,
                  height: SizeConfig.safeBlockVertical! * 30,
                ),
              ),
      );
    } else if (step == 3) {
      return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/children/border.png",
              ),
              fit: BoxFit.contain,
            ),
          ),
          height: SizeConfig.safeBlockVertical! * 55,
          width: SizeConfig.safeBlockHorizontal! * 35,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/children/sent_message.png",
                fit: BoxFit.contain,
                height: SizeConfig.safeBlockVertical! * 30,
              ),
              Text(
                'تم الارسال',
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical! * 6,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                    color: chBlue),
              ),
            ],
          ));
    }
    return null;
  }

  Widget messageWidget(String title, String image) {
    return Container(
      height: SizeConfig.safeBlockVertical! * 10.5,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: SizeConfig.safeBlockVertical! * 6,
                fontFamily: 'ge_ss',
                fontWeight: FontWeight.bold,
                color: chBlue),
          ),
          SizedBox(
            width: SizeConfig.safeBlockHorizontal! * 4,
          ),
          Container(
            width: SizeConfig.safeBlockHorizontal! * 5,
            alignment: Alignment.center,
            child: Image.asset(
              "assets/children/${image}_icon.png",
              height: SizeConfig.safeBlockVertical! * 8,
            ),
          ),
          SizedBox(
            width: SizeConfig.safeBlockHorizontal! * 2,
          ),
        ],
      ),
    );
  }

  _send() async {
    try {
      //create multipart request for POST or PATCH method
      var request = MultipartRequest("POST", Uri.parse(Conn.messagingURL));
      request.fields["title"] = 'رسالة مباشرة';
      request.fields["text"] = 'صورة';
      request.headers['Authorization'] = 'token ${Conn.token}';

      var toSendFile;
      //create multipart using filepath, string or bytes
      if (widget.isFromStory!) {
        File? file;
        await stickerImage?.then((value) => file = value);
        var stream = new ByteStream(DelegatingStream.typed(file!.openRead()));
        var length = await file!.length();
        String filename = "${DateTime.now()}.png";
        toSendFile = MultipartFile('image', stream, length, filename: filename);
      } else {
        File file = _image!;
        String filename = "${DateTime.now()}.png";

        var stream = new ByteStream(DelegatingStream.typed(file.openRead()));
        var length = await file.length();
        toSendFile = MultipartFile('image', stream, length, filename: filename);
      }

      //add multipart to request
      request.files.add(toSendFile);

      print('before send');
      var response = await request.send();
      print('after send');
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('successful');
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
