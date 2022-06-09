import 'dart:io';
import 'dart:math';
import 'package:async/async.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:kau_app/User.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

const theSource = AudioSource.microphone;
typedef _Fn = void Function();



class SendMessage extends StatefulWidget {
  Member? member;

  SendMessage({this.member});

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {


  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  bool isRecorded = false;


  // LocalFileSystem localFileSystem = LocalFileSystem();
  // Recording _recording = new Recording();
  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  bool _isRecording = false;
  int index = 0;
  Random random = new Random();
  static const MethodChannel _channel =
      const MethodChannel('flutter_audio_recorder');
  String? recordingPath;
  int step = 1;

  File? voiceFile;

  //this for permission
  static Future<bool> get hasPermissions async {
    bool hasPermission = await _channel.invokeMethod('hasPermissions');
    return hasPermission;
  }

  bool _sendBtnLoading = false;
  bool _sendBtnEnable = true;

  Future<File>? imageFile;
  String fileType = '';

  List<String> stickerPaths = [
    'أحبك بعدد الكواكب والنجوم.png',
    'أحبك يا صغيرتي البارة.png',
    'أحبك يا صغيري البار.png',
    'أنا محظوظة بك.png',
    'أنت أجمل نعمة من الله.png',
    'أنت ابن رضي.png',
    'الله يرضى عليك يا بنتي.png',
    'الله يرضى عليك يا ولدي.png',
    'بر الوالدين يزيد من حسناتك.png',
    'برقر.png',
    'رضا الله من رضا الوالدين.png',
    'شكراً لك طفلتي المبدعة.png',
    'شكراً لك يا طفلي المبدع.png',
    'شكراً يا مساعدتي البارة.png',
    'شكراً يا مساعدي البار.png',
    'عملك جميل كم انت مبدع.png',
    'نجمة.png',
  ];

  bool _sendValidate() {
    return (isRecorded || imageFile != null) && _sendBtnEnable;
  }

  @override
  void initState() {
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }


  Future<void> openTheRecorder() async {
    Directory tempDir = await getTemporaryDirectory();
    File outputFile = await File ('${tempDir.path}/flutter_sound-tmp.aac');
    _mPath = outputFile.path;
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      // Directory appDocDirectory = await getApplicationDocumentsDirectory();
      // _mPath = appDocDirectory.path + '/' + "${DateTime.now()}" + ".webm";
      // _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    isRecorded = false;
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        //var url = value;
        isRecorded = true;
        _mplaybackReady = true;
      });
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
        fromURI: _mPath,
        //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
        whenFinished: () {
          setState(() {
            index = 2;
          });
        })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {
        index = 2;
      });
    });
  }


// ----------------------------- UI --------------------------------------------

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }


  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Widget audiRecorder() {
    String? text;
    Widget? icon;
    if (index == 0) {
      // recorder not started yet
      text = "اضغط لبداء التسجيل";
      icon = Icon(
        Icons.keyboard_voice,
        size: 50,
        color: myBink,
      );
    } else if (index == 1) {
      // recoding
      text = "اضغط لإقاف التسجيل";
      icon = Image(
        image: AssetImage(
          'assets/recording.gif',
        ),
        height: 45,
      );
    } else if (index == 2) {
      // stopped
      text = "اضغط لسماع التسجيل";
      icon = Icon(
        Icons.play_arrow,
        color: myBink,
        size: 50,
      );
    } else if (index == 3) {
      // plying
      text = "اضغط للإيقاف";
      icon = Icon(Icons.stop_circle_sharp, color: myBink, size: 50);
    }

    return InkWell(
      onTap: () {
        if (index == 0) {
          // recorder not started yet
          record();
          setState(() {
            index = 1;
          });
        } else if (index == 1) {
          // recoding
          stopRecorder();
          setState(() {
            index = 2;
          });
        } else if (index == 2) {
          // plying
          play();
          setState(() {
            index = 3;
          });
        } else if (index == 3) {
          // paused
          stopPlayer();
          setState(() {
            index = 2;
          });
        }
      },
      child: Column(
        children: <Widget>[
          Text(text!),
          icon!,
        ],
      ),
    );
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        Widget? widget;
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          if (fileType == 'image') {
            widget = Image.file(
              snapshot.data!,
              width: 300,
              height: 100,
            );
          }
          return widget!;
        } else if (snapshot.error != null) {
          widget = const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else if (fileType == 'voice') {
          widget = audiRecorder();
        } else {
          widget = Text(
            'اختر ملصق او سجل رسالة صوتية',
            style: TextStyle(
              fontSize: 16,
              fontFamily: fontHiding2,
            ),
          );
        }
        return widget;
      },
    );
  }

  void showAsBottomSheet() async {
    List<Widget> images = <Widget>[];
    images.add(Image.asset('assets/أحبك بعدد الكواكب والنجوم.png', height: 35));
    images.add(Image.asset('assets/أحبك يا صغيرتي البارة.png', height: 35));
    images.add(Image.asset('assets/أحبك يا صغيري البار.png', height: 35));
    images.add(Image.asset('assets/أنا محظوظة بك.png', height: 35));
    images.add(Image.asset('assets/أنت أجمل نعمة من الله.png', height: 35));
    images.add(Image.asset('assets/أنت ابن رضي.png', height: 35));
    images.add(Image.asset('assets/الله يرضى عليك يا بنتي.png', height: 35));
    images.add(Image.asset('assets/الله يرضى عليك يا ولدي.png', height: 35));
    images
        .add(Image.asset('assets/بر الوالدين يزيد من حسناتك.png', height: 35));
    images.add(Image.asset('assets/برقر.png', height: 35));
    images.add(Image.asset('assets/رضا الله من رضا الوالدين.png', height: 35));
    images.add(Image.asset('assets/شكراً لك طفلتي المبدعة.png', height: 35));
    images.add(Image.asset('assets/شكراً لك يا طفلي المبدع.png', height: 35));
    images.add(Image.asset('assets/شكراً يا مساعدتي البارة.png', height: 35));
    images.add(Image.asset('assets/شكراً يا مساعدي البار.png', height: 35));
    images.add(Image.asset('assets/عملك جميل كم انت مبدع.png', height: 35));
    images.add(Image.asset('assets/نجمة.png', height: 35));
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
            height: 400,
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
                        return InkWell(
                          onTap: () {
                            setState(() {
                              fileType = 'image';
                              imageFile =
                                  getImageFileFromAssets(stickerPaths[index]);
                            });
                            Navigator.pop(context);
                          },
                          child: Card(
                            child: GridTile(
                              child: images[
                                  index], //just for testing, will fill with image later
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
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: myBackground,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: myBink, //change your color here
          ),
          title: Text(
            "ارسال رسالة الى ${widget.member!.name}",
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 20,
                      child: RaisedButton(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.image,
                              color: myBlue,
                              size: 60,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'اضافة ملصق',
                              style: TextStyle(
                                  fontFamily: fontHiding2,
                                  color: myBlue,
                                  fontSize: 18),
                            )
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            showAsBottomSheet();
                          });
                          // Navigator.pop(context, true);
                        },
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 2,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 20,
                      child: RaisedButton(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.keyboard_voice,
                              color: myBlue,
                              size: 60,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'تسجيل صوت',
                              style: TextStyle(
                                  fontFamily: fontHiding2,
                                  color: myBlue,
                                  fontSize: 18),
                            )
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            fileType = 'voice';
                            imageFile;
                            index = 0;
                          });
                          // Navigator.pop(context, true);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: showImage(),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: RaisedButton(
                    color: myBink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    onPressed: _sendValidate() ? _send : null,
                    child: _sendBtnLoading
                        ? SpinKitRipple(
                            color: Colors.white,
//                              type: SpinKitWaveType.start
                          )
                        : Text('ارسال', style: fontButtonStyle),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }

  _send() async {
    setState(() {
      _sendBtnLoading = true;
      _sendBtnEnable = false;
    });
    try {
      File? file;
      String? filename;
      if (fileType == 'image') {
        filename = "${DateTime.now()}.png";
        await imageFile!.then((value) => file = value);
      } else if (fileType == 'voice') {
        filename = "${DateTime.now()}.m4a";
        print(_mPath);
        file = File(_mPath);

      } else {
        return;
      }

      var stream = new ByteStream(DelegatingStream.typed(file!.openRead()));
      var length = await file!.length();
      //create multipart request for POST or PATCH method
      var request = MultipartRequest("POST", Uri.parse(Conn.messagingURL));
      request.fields["user"] = "${widget.member!.id}";
      request.fields["title"] = 'رسالة من الوالدين';
      request.fields["text"] = '';
      request.headers['Authorization'] = 'token ${Conn.token}';

      //create multipart using filepath, string or bytes
      var toSendFile = MultipartFile(fileType, stream, length, filename: filename);
      //add multipart to request
      request.files.add(toSendFile);
      var response = await request.send();
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      print(response.statusCode);
      if (response.statusCode == 200) {
        await AwesomeDialog(
          headerAnimationLoop: false,
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: 'تم الارسال بنجاح',
          desc: ' ',
          btnOkText: 'موافق',
          btnOkColor: myBlue,
          btnOkOnPress: () {},
          dismissOnTouchOutside: true,
        ).show();
        setState(() {
          _sendBtnLoading = false;
          _sendBtnEnable = true;
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
        _sendBtnLoading = false;
        _sendBtnEnable = true;
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
      setState(() {
        _sendBtnLoading = false;
        _sendBtnEnable = true;
      });
    }
  }
}
