import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:async/async.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kau_app/common/welcome.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:kau_app/utils/my_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

const theSource = AudioSource.microphone;

typedef _Fn = void Function();

class AddModifyTask extends StatefulWidget {
  bool? isEdit;
  Map? task;

  AddModifyTask({this.isEdit, this.task});

  @override
  _AddModifyTaskState createState() => _AddModifyTaskState();
}

class _AddModifyTaskState extends State<AddModifyTask> {
  List? users;
  final _nameController = TextEditingController();
  final _scoreController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool called = false;

  bool firstEdit = true;
  TimeOfDay _time = TimeOfDay.now().replacing(minute: 30);

  final _nameFocus = FocusNode();
  final _scoreFocus = FocusNode();

  bool imageValid = false;
  // File? _image;
  Future<File>? imageFile;
  bool _editBtnLoading = false;
  bool _editBtnEnable = true;

  String? _taskDuration;

  String _taskTime = 'لم يتم التحديد';

  List _taskDurationList = [
    {"time": "5 دقائق", "id": "00:05:00"},
    {"time": "10 دقائق", "id": "00:10:00"},
    {"time": "15 دقيقة", "id": "00:15:00"},
    {"time": "20 دقيقة", "id": "00:20:00"},
  ];



  List<bool> daySelectList = [true, false, false, false, false, false, false];
  List<bool> memberSelectList = [];

  double animatedWidth = 0;
  double animatedHeight = 0;

  String? _selectedCategory;
  List categoryList = [
    {"name": "مهام صحية", "id": 1},
    {"name": "مهام سلوكية", "id": 2},
    {"name": "مهام منزلية", "id": 3},
    {"name": "مهام اخرى", "id": 4},
  ];

  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  bool _isRecording = false;
  int index = 0;
  Random random = Random();
  static const MethodChannel _channel = const MethodChannel('audio_recorder');
  String? recordingPath;
  int step = 1;

  File? voiceFile;

  //this for permission
  static Future<bool> get hasPermissions async {
    bool hasPermission = await _channel.invokeMethod('hasPermissions');
    return hasPermission;
  }

  bool? isRecorded = false;

  Codec _codec = Codec.aacMP4;
  String _mPath = '';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

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
    File outputFile = await File('${tempDir.path}/flutter_sound-tmp.aac');
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
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth | AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
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
    assert(_mPlayerIsInited && _mplaybackReady && _mRecorder!.isStopped && _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromURI: _mPath!=""? _mPath: voiceFile!.path,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {
                index = 2;
              });
            })
        .then((value) {
      setState(() {

      });
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
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Widget audiRecorder() {
    String? text;
    Widget? icon;
    if (index == 0) {
      // recorder not started yet

      text = "اضغط لبدءالتسجيل";
      icon = Icon(
        Icons.keyboard_voice,
        size: 30,
        color: myBink,
      );
    } else if (index == 1) {
      // recoding
      text = "اضغط لإيقاف التسجيل";
      icon = Image(
        image: AssetImage(
          'assets/recording.gif',
        ),
        height: 30,
      );
    } else if (index == 2) {
      // stopped
      text = "اضغط لبدء لسماع التسجيل";
      icon = Icon(
        Icons.play_arrow,
        color: myBink,
        size: 30,
      );
    } else if (index == 3) {
      // plying
      text = "اضغط للإيقاف سماع التسجيل";
      icon = Icon(Icons.pause_circle_filled, color: myBink, size: 30);
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[icon!, Text(text!, style: TextStyle(color: myBlue, fontSize: 16, fontFamily: fontHiding2))],
      ),
    );
  }

  Future<String> loadData() async {
    // print('entered');
    // if (called) return 'done';
    // called = true;

    try {
      print('entered');
      final params = {
        "task_id": widget.isEdit! ? "${widget.task!['id']}" : "",
      };
      final uri = Uri.https(Conn.url, "/app/api/task");
      final newUri = widget.isEdit! ? uri.replace(queryParameters: params) : uri;
      Map<String, String> userHeader = {'Authorization': 'Token ${Conn.token}'};
      var getTaskResponse = await get(
        newUri,
        headers: userHeader,
      );
      var taskMap = jsonDecode(utf8.decode(getTaskResponse.bodyBytes));
      if (getTaskResponse.statusCode == 200) {
        if (firstEdit) {
          widget.task = taskMap;

          users = widget.task!['users'];
          for (int i = 0; i < users!.length; i++) {
            memberSelectList.add(users![i]['is_enrolled']);
          }
          if (!widget.isEdit!) {
            firstEdit = false;
          }
        }
        if (widget.isEdit! && firstEdit) {
          firstEdit = false;
          _nameController.text = widget.task!['name'];
          _scoreController.text = "${widget.task!['score']}";
          _taskDuration = widget.task!['duration'];
          _taskTime = "${widget.task!['time']}";
          _selectedCategory = "${widget.task!['task_category']['id']}";
          _taskDuration = "${widget.task!['duration']}";
          //add cast as future<file>?;
          imageFile = (await urlToFile(widget.task!['picture'])) as Future<File>?;
          voiceFile = (await urlToVoiceFile(widget.task!['voice']))!;

          if (voiceFile!=null) {
            print(voiceFile);
            print("voiceFile*******************************************************************************");
            index = 2;
          }
          List days = widget.task!['days'];
          for (int i = 0; i < days.length; i++) {
            daySelectList[days[i]['day']['week_order'] - 1] = true;
          }
        }
        return 'done';
      } else if (getTaskResponse.statusCode == 401) {
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
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WelcomePage()), ModalRoute.withName('/'));
        return 'done';
      } else {
        return ""
            "${taskMap}";
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
    } catch (e) {
      print(e);
    }
    return "ConnectionError";
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _editValidation() {
    // print(_nameValid && _scoreValid && _taskTime != 'لم يتم التحديد' && _taskDuration != 'لم يتم التحديد');
    return _editBtnEnable &&
        _nameController.text.length > 0 &&
        _scoreController.text.length > 0 &&
        _taskTime != 'لم يتم التحديد' &&
        _taskDuration != 'لم يتم التحديد' &&
        _selectedCategory != null;
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          imageValid = true;
          return Image.file(
            snapshot.data!,
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

  gallaryphoto(ImageSource source) async {
    final PickedFile = await ImagePicker().getImage(source: source);
    final bytes = await PickedFile?.readAsBytes();
    setState(() {
      imageFile = File(PickedFile!.path) as Future<File>?;
    });
  }

  Future<File?> urlToFile(String? imageUrl) async {
    if (imageUrl == null) {
      imageValid = false;
      return null;
    }
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    print(imageUrl);
    Response response = await get(Uri.parse(Conn.serverURL + imageUrl.toString()));
    await file.writeAsBytes(response.bodyBytes);
    imageValid = true;
    return file;
  }

  Future<File?> urlToVoiceFile(String? voiceURL) async {
    if (voiceURL == null) {
      isRecorded = false;
      index = 0;
      return null;
    }
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.m4a');
    print(voiceURL);
    Response response = await get(Uri.parse(Conn.serverURL + voiceURL.toString()));
    await file.writeAsBytes(response.bodyBytes);
    isRecorded = true;
    index = 2;
    return file;
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
              widget.isEdit! ? "تعديل المهمة" : "مهمة جديدة",
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
                                          _fieldFocusChange(context, _nameFocus, _scoreFocus);
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
                                            borderSide: BorderSide(color: Colors.grey[400]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: myBlue, width: 1.0),
                                          ),
                                          labelStyle: TextStyle(fontFamily: fontHiding2, color: myBlue),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          focusColor: Colors.white,
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent),
                                          ),
                                          labelText: 'إسم المهمة',
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextFormField(
                                              textInputAction: TextInputAction.done,
                                              focusNode: _scoreFocus,
                                              onFieldSubmitted: (e) {
                                                _scoreFocus.unfocus();
                                              },
                                              controller: _scoreController,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                              ],
                                              maxLength: 2,
                                              decoration: InputDecoration(
                                                  counter: Container(),
                                                  contentPadding: EdgeInsets.all(8),
                                                  prefixIcon: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Icon(
                                                      Icons.star,
                                                      color: myBlue,
                                                      size: 30,
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
                                                  fillColor: Colors.transparent,
                                                  focusColor: Colors.white,
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.transparent),
                                                  ),
                                                  labelText: 'عدد النقاط',
                                                  hintText: 'من 0 الى 99'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: SizedBox(
                                              height: 49,
                                              child: DecoratedBox(
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                                  child: DropdownButton<String>(
                                                    focusColor: Colors.transparent,
                                                    value: _taskDuration,
                                                    isExpanded: true,
                                                    icon: Padding(
                                                      padding: const EdgeInsets.all(12.0),
                                                      child: Icon(
                                                        Icons.arrow_drop_down,
                                                        color: myBlue,
                                                      ),
                                                    ),
                                                    style: TextStyle(color: Colors.black),
                                                    hint: Padding(
                                                      padding: const EdgeInsets.fromLTRB(0.0, 9.0, 0, 0),
                                                      child: Column(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            'مدة تنفيذ المهمة',
                                                            style: TextStyle(color: myBlue, fontSize: 14, fontFamily: fontHiding2),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors.transparent,
                                                    ),
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        _taskDuration = newValue!;
                                                        // print(_selectedCategory);
                                                      });
                                                    },
                                                    items: _taskDurationList.map((item) {
                                                      return new DropdownMenuItem(
                                                        child: Text('${item['time']}'),
                                                        value: item['id'].toString(),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              MyCard(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'صاحب المهمة',
                                        style: TextStyle(color: myBlue, fontFamily: fontHiding2, fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          margin: EdgeInsets.symmetric(vertical: 0.0),
                                          height: 72.0,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: users != null
                                                ? users!.asMap().entries.map((entry) {
                                                    int idx = entry.key;
                                                    Map user = entry.value;
                                                    GlobalKey userTooltip = GlobalKey();
                                                    return Row(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          onTap: () {
                                                            final dynamic tooltip = userTooltip.currentState;
                                                            tooltip.ensureTooltipVisible();
                                                            setState(() {
                                                              user['is_enrolled'] = !user['is_enrolled'];
                                                              memberSelectList[idx] = user['is_enrolled'];
                                                            });
                                                          },
                                                          child: Tooltip(
                                                            message: '${user['name']}',
                                                            key: userTooltip,
                                                            child: Column(
                                                              children: <Widget>[
                                                                Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  child: CircleAvatar(
                                                                    backgroundColor: Colors.transparent,
                                                                    backgroundImage: NetworkImage(Conn.serverURL + user['pic']),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${user['name']}',
                                                                  style: TextStyle(color: myBlue, fontFamily: fontHiding2),
                                                                ),
                                                                user['is_enrolled']
                                                                    ? Icon(
                                                                        Icons.done,
                                                                        color: Colors.green,
                                                                        size: 15,
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        )
                                                      ],
                                                    );
                                                  }).toList()
                                                : [Container()],
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              MyCard(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            RaisedButton(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              elevation: 0.0,
                                              onPressed: () {
                                                Navigator.of(context).push(showPicker(
                                                  context: context,
                                                  value: _time,
                                                  onChange: (date) {
                                                    setState(() {
                                                      // intl.DateFormat.jm().format(date);
                                                      // _taskTime = "${intl.DateFormat.Hms().format(date)}";
                                                      print("${date.hour}:${date.minute}:00");
                                                      _taskTime = "${date.hour}:${date.minute}:00";
                                                    });
                                                  },
                                                ));
                                                // DatePicker.showTimePicker(context,
                                                //     theme: DatePickerTheme(
                                                //       containerHeight: 210.0,
                                                //     ),
                                                //     showTitleActions: true, onConfirm: (date) {
                                                //   setState(() {
                                                //     // intl.DateFormat.jm().format(date);
                                                //     _taskTime = "${intl.DateFormat.Hms().format(date)}";
                                                //   });
                                                // }, currentTime: DateTime.now(), locale: LocaleType.ar);
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
                                                          Icons.access_time,
                                                          color: myBlue,
                                                        ),
                                                        SizedBox(
                                                          width: 12,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "وقت ظهور المهمة",
                                                              style: TextStyle(color: myBlue, fontSize: 14.0, fontFamily: fontHiding2),
                                                            ),
                                                            SizedBox(
                                                              height: 2,
                                                            ),
                                                            Text(
                                                              "$_taskTime",
                                                              style: TextStyle(color: Colors.black),
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
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: DecoratedBox(
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                                  child: DropdownButton<String>(
                                                    focusColor: Colors.transparent,
                                                    value: _selectedCategory,
                                                    isExpanded: true,
                                                    icon: Padding(
                                                      padding: const EdgeInsets.all(12.0),
                                                      child: Icon(
                                                        Icons.arrow_drop_down,
                                                        color: myBlue,
                                                      ),
                                                    ),
                                                    style: TextStyle(color: Colors.black),
                                                    hint: Padding(
                                                      padding: const EdgeInsets.fromLTRB(0.0, 9.0, 0, 0),
                                                      child: Column(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            'تصنيف المهمة',
                                                            style: TextStyle(color: myBlue, fontSize: 14, fontFamily: fontHiding2),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors.transparent,
                                                    ),
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        _selectedCategory = newValue!;
                                                        // print(_selectedCategory);
                                                      });
                                                    },
                                                    items: categoryList.map((item) {
                                                      return new DropdownMenuItem(
                                                        child: Text('${item['name']}'),
                                                        value: item['id'].toString(),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Container(
                                            alignment: Alignment.center,
                                            // width: animatedWidth,
                                            // height: animatedHeight,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(8),
                                            ),

                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: ToggleButtons(
                                                constraints: BoxConstraints.tight(Size(70, 50)),
                                                borderRadius: BorderRadius.circular(100),
                                                borderColor: Colors.transparent,
                                                disabledBorderColor: Colors.transparent,
                                                color: myBlue,
                                                fillColor: myBink,
                                                borderWidth: 2,
                                                selectedBorderColor: myBink,
                                                focusColor: Colors.transparent,
                                                selectedColor: Colors.white,
                                                renderBorder: true,
                                                children: <Widget>[
                                                  Text(
                                                    'الاحد',
                                                    style: TextStyle(
                                                      fontFamily: fontHiding2,
                                                    ),
                                                  ),
                                                  Text('الاثنين',
                                                      style: TextStyle(
                                                        fontFamily: fontHiding2,
                                                      )),
                                                  Text('الثلاثاء',
                                                      style: TextStyle(
                                                        fontFamily: fontHiding2,
                                                      )),
                                                  Text('الاربعاء',
                                                      style: TextStyle(
                                                        fontFamily: fontHiding2,
                                                      )),
                                                  Text('الخميس',
                                                      style: TextStyle(
                                                        fontFamily: fontHiding2,
                                                      )),
                                                  Text('الجمعة',
                                                      style: TextStyle(
                                                        fontFamily: fontHiding2,
                                                      )),
                                                  Text('السبت',
                                                      style: TextStyle(
                                                        fontFamily: fontHiding2,
                                                      )),
                                                ],
                                                onPressed: false
                                                    ? null
                                                    : (int index) {
                                                        setState(() {
                                                          if (!daySelectList[index])
                                                            daySelectList[index] = !daySelectList[index];
                                                          else {
                                                            daySelectList[index] = !daySelectList[index];
                                                            if (!daySelectList.contains(true)) daySelectList[index] = !daySelectList[index];
                                                          }
                                                        });
                                                      },
                                                isSelected: daySelectList,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container()
                                      ],
                                    )
                                  ],
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
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                style: TextStyle(fontFamily: fontHiding2, color: myBlue, fontSize: 18),
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: showImage()),
                                          IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  imageFile;
                                                });
                                              })
                                        ],
                                      ),
                                      Divider(
                                        thickness: 2,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          audiRecorder(),
                                          IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  index = 0;
                                                  voiceFile = null;
                                                });
                                              })
                                        ],
                                      )
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
                                      : Text(widget.isEdit! ? 'تعديل' : 'إضافة', style: fontButtonStyle),
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
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
      //create multipart request for POST or PATCH method
      var request = MultipartRequest(widget.isEdit! ? "PUT" : "POST", Uri.parse(Conn.tasksURL));
      if (widget.isEdit!) {
        request.fields["task_id"] = "${widget.task!['id']}";
      }
      request.fields["name"] = _nameController.text;
      request.fields["score"] = _scoreController.text;
      request.fields["duration"] = _taskDuration!;
      request.fields["time"] = _taskTime;
      request.fields["task_category"] = _selectedCategory!;

      String usernames = '';
      for (int i = 0; i < users!.length; i++) {
        if (users![i]['is_enrolled']) {
          usernames += ' ${users![i]['username']}';
        }
      }
      request.fields["users_username"] = usernames;

      String daysToSend = '';
      for (int i = 0; i < daySelectList.length; i++) {
        if (daySelectList[i]) {
          daysToSend += ' ${i + 1}';
        }
      }
      request.fields["days"] = daysToSend;
      request.headers['Authorization'] = 'token ${Conn.token}';

      //create multipart using filepath, string or bytes

      if (imageValid) {
        File? file;
        await imageFile!.then((value) => file = value);
        var stream = new ByteStream(DelegatingStream.typed(file!.openRead()));
        var length = await file!.length();
        var pic = MultipartFile("picture", stream, length, filename: "${DateTime.now()}.png");

        //add multipart to request
        request.files.add(pic);
      }
      if (_mPath != "") {
        String voiceFileName = "${DateTime.now()}.m4a";
        voiceFile = File(_mPath);
        var voiceFileLength = await voiceFile!.length();
        var voiceStream = new ByteStream(DelegatingStream.typed(voiceFile!.openRead()));
        var voice = MultipartFile("voice", voiceStream, voiceFileLength, filename: voiceFileName);
        //add multipart to request
        request.files.add(voice);
      }

      var response = await request.send();

      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      if (response.statusCode == 200) {
        await AwesomeDialog(
          headerAnimationLoop: false,
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: widget.isEdit! ? 'تم تعديل المهمة بنجاح' : "تمت الاضافة بنجاح",
          desc: ' ',
          btnOkText: 'موافق',
          btnOkColor: myBlue,
          btnOkOnPress: () {},
          dismissOnTouchOutside: true,
        ).show();
        Navigator.pop(context);
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
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WelcomePage()), ModalRoute.withName('/'));
      } else {
        await AwesomeDialog(
                context: context,
                headerAnimationLoop: false,
                dialogType: DialogType.ERROR,
                animType: AnimType.SCALE,
                title: 'يوجد مشكلة غير معروفة',
                desc: "${response.statusCode} \n $responseString",
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
      setState(() {
        _editBtnLoading = false;
        _editBtnEnable = true;
      });
    } catch (e) {
      await AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.ERROR,
              animType: AnimType.SCALE,
              title: 'Error',
              desc: e.toString(),
              btnOkOnPress: () {},
              btnOkText: 'تم',
              btnOkColor: Colors.red)
          .show();
      print(e);
      setState(() {
        _editBtnLoading = false;
        _editBtnEnable = true;
      });
    }
  }
}
