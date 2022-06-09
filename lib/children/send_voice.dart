import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:async/async.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart';
import 'package:kau_app/children/main_child.dart';
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/children_app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/sizeConfig.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:path_provider/path_provider.dart';


const theSource = AudioSource.microphone;
typedef _Fn = void Function();

class sendVoiceState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new sendVoiceStateState();
}

class sendVoiceStateState extends State<sendVoiceState> {

  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

  Random random = new Random();
  int step = 1;
  int record_index = 1;

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
          setState(() {});
        })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
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


    // Future<void> record() async {
    //   // Directory dir = Directory(path.dirname(filePath!));
    //   // if (!dir.existsSync()) {
    //   //   dir.createSync();
    //   // }
    //   _myRecorder!.openAudioSession();
    //   await _myRecorder!.startRecorder(
    //     toFile: filePath,
    //     codec: Codec.pcm16WAV,
    //   );
    //
    //   StreamSubscription _recorderSubscription =
    //   _myRecorder!.onProgress!.listen((e) {
    //     var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds,
    //         isUtc: true);
    //     var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
    //
    //     setState(() {
    //       //_recorderTxt = txt.substring(0, 8);
    //     });
    //   });
    //   _recorderSubscription.cancel();
    // }
    //
    // Future<String?> stopRecord() async {
    //   _myRecorder!.closeAudioSession();
    //   return await _myRecorder!.stopRecorder();
    // }
    //
    // Future<void> startPlaying() async {
    //   audioPlayer.open(
    //     Audio.file(filePath!),
    //     autoStart: true,
    //     showNotification: true,
    //   );
    // }
    //
    // Future<void> stopPlaying() async {
    //   audioPlayer.stop();
    // }
//* **
    //this for permission
    /*static Future<bool> get hasPermissions async {
    bool hasPermission = await _channel.invokeMethod('hasPermissions');
    return hasPermission;
  }*/

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
                                alignment: Alignment.center,
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
                                            'الرسائل',
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
                                    step == 2
                                        ? Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/children/border.png",
                                            ),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        height:
                                        SizeConfig.safeBlockVertical! *
                                            55,
                                        width:
                                        SizeConfig.safeBlockHorizontal! *
                                            35,
                                        alignment: Alignment.bottomCenter,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/children/sent_message.png",
                                              fit: BoxFit.contain,
                                              height: SizeConfig
                                                  .safeBlockVertical! *
                                                  30,
                                            ),
                                            Text(
                                              'تم الارسال',
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                      .safeBlockVertical! *
                                                      6,
                                                  fontFamily: 'Tajawal',
                                                  fontWeight: FontWeight.bold,
                                                  color: chBlue),
                                            ),
                                          ],
                                        ))
                                        : Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/children/border.png",
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      height:
                                      SizeConfig.safeBlockVertical! *
                                          55,
                                      width: SizeConfig.safeBlockVertical! *
                                          80,
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {
                                                switch (record_index) {
                                                  case 1:
                                                    {
                                                      record();
                                                      setState(() {
                                                        record_index = 2;
                                                      });

                                                      break;
                                                    }
                                                  case 2:
                                                    {
                                                      stopRecorder();
                                                      setState(() {
                                                        record_index = 3;
                                                      });

                                                      break;
                                                    }
                                                  case 3:
                                                    {
                                                      play();
                                                      break;
                                                    }
                                                }
                                              },
                                              child: record_index == 3
                                                  ? Image.asset(
                                                "assets/children/message_voice3.png",
                                                height: SizeConfig
                                                    .safeBlockVertical! *
                                                    30,
                                                fit: BoxFit.contain,
                                              )
                                                  : record_index == 2
                                                  ? Image.asset(
                                                "assets/children/message_voice2.png",
                                                height: SizeConfig
                                                    .safeBlockVertical! *
                                                    30,
                                                fit: BoxFit
                                                    .contain,
                                              )
                                                  : Image.asset(
                                                "assets/children/message_voice1.png",
                                                height: SizeConfig
                                                    .safeBlockVertical! *
                                                    30,
                                                fit: BoxFit
                                                    .contain,
                                              )),
                                          Container(
                                              alignment:
                                              Alignment.bottomLeft,
                                              height: SizeConfig
                                                  .safeBlockVertical! *
                                                  10,
                                              child: GestureDetector(
                                                onTap: () {
                                                  getRecorderFn();
                                                  setState(() {
                                                    record_index = 1;
                                                  });
                                                },
                                                child: record_index == 3
                                                    ? Image.asset(
                                                  "assets/children/return_icon.png",
                                                )
                                                    : Container(),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          step == 1 && record_index == 3
                              ? Positioned(
                            bottom: SizeConfig.safeBlockVertical! * 12,
                            left: -SizeConfig.safeBlockHorizontal! * 5,
                            child: InkWell(
                              onTap: () {
                                _send();
                                setState(() {
                                  step = 2;
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
                      step == 1
                          ? Container()
                          : InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: step == 2
                            ? Image.asset(
                          "assets/children/back_icon.png",
                          height: SizeConfig.safeBlockVertical! * 10,
                          width: SizeConfig.safeBlockHorizontal! * 10,
                        )
                            : Container(),
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

    _send() async {
      try {
        String filename;
        filename = "${DateTime.now()}.m4a";
        File file = File(_mPath);
        var length = await file.length();
        var stream = new ByteStream(DelegatingStream.typed(file.openRead()));
        // var length = await file!.length();
        //create multipart request for POST or PATCH method
        var request = MultipartRequest("POST", Uri.parse(Conn.messagingURL));
        request.fields["title"] = '2رسالة مباشرة';
        request.fields["text"] = 'رسالة صوتية';
        request.headers['Authorization'] = 'token ${Conn.token}';

        //create multipart using filepath, string or bytes
        var toSendFile = MultipartFile('voice', stream, length, filename: filename);
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