import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginQRPage extends StatefulWidget {
  @override
  _LoginQRPageState createState() => _LoginQRPageState();
}

class _LoginQRPageState extends State<LoginQRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";

  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  // QRViewController? controller;

  Future<bool> _login(String username, String password) async {
    try {
      final data = jsonEncode({"username": username, "password": password});
      Map<String, String> userHeader = {'Content-Type': 'application/json'};

      var response = await post(Uri.parse(Conn.loginULR), body: data, headers: userHeader);
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Map responseMap = jsonDecode(response.body);
        Conn.token = responseMap['token'];
        bool isAdmin = responseMap['is_admin'];
        await prefs.setString("token", Conn.token ?? "");
        await prefs.setBool("isLogin", true);
        await prefs.setBool("isAdmin", isAdmin);

        var landscape = [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight];
        var portrait = [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
        SystemChrome.setPreferredOrientations(isAdmin ? portrait : landscape);
        EasyLoading.dismiss(animation: true);
        Navigator.of(context).pushNamedAndRemoveUntil(isAdmin ? '/admin' : '/child', (Route<dynamic> route) => false);

        try {
          var request = MultipartRequest("POST", Uri.parse(Conn.setNotificationTokenURL));
          request.fields["push_notification_token"] = prefs.getString('NotificationToken')!;
          request.headers['Authorization'] = 'token ${Conn.token}';
          var response = await request.send();
          //Get the response from the server
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print('set token');
          if (response.statusCode == 200) {
          } else if (response.statusCode == 401) {
            Conn.logout();
          }
        } catch (e) {}
        return true;
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss(animation: true);
        await AwesomeDialog(
          headerAnimationLoop: false,
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.SCALE,
          title: 'رمز الـ QR قديم او غير صحيح',
          desc: 'الرجاء التاكد مسح اخر تحديث للـ QR',
          btnOkText: 'موافق',
          btnOkColor: myBlue,
          btnOkOnPress: () {},
          dismissOnTouchOutside: true,
        ).show();
        return false;
      } else {
        EasyLoading.dismiss(animation: true);
        await AwesomeDialog(
          headerAnimationLoop: false,
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.SCALE,
          title: 'حدثت مشكله غير معروفة',
          desc: 'الرجاء التواصل مع الدعم الفني',
          btnOkText: 'موافق',
          btnOkColor: myBlue,
          btnOkOnPress: () {},
          dismissOnTouchOutside: true,
        ).show();
        return false;
      }
    } on SocketException {
      EasyLoading.dismiss(animation: true);
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
      return false;
    } catch (e) {
      EasyLoading.dismiss(animation: true);
      print(e);
      return false;
    }
  }

  Future<void> _foundBarcode(Barcode barcode, MobileScannerArguments? args) async {
    if (barcode.rawValue == null) {
      debugPrint('Failed to scan Barcode');
    } else {
      final String code = barcode.rawValue!;
      debugPrint('Barcode found! $code');
      print('before spilt');
      var u_p = code.split(' ');
      EasyLoading.show(status: 'جاري التحميل...');
      print('spilt');
      bool isLoggedIn = await _login(u_p[0], u_p[1]);
    }

    //
    // bool scanned = false;
    //
    // controller.scannedDataStream.listen((scanData) async {
    //   print('kmkm,,');
    //   if (!scanned) {
    //
    //     scanned = true;
    //     controller.pauseCamera();
    //     qrText = scanData.toString();
    //     var u_p = qrText.split(' ');
    //     print(u_p);
    //     EasyLoading.show(status: 'جاري التحميل...');
    //     bool isLoggedIn = await _login(u_p[0], u_p[1]);
    //     isLoggedIn ? null : controller.resumeCamera();
    //     scanned = false;
    //     EasyLoading.dismiss(animation: true);
    //   }
    // });
  }

/*
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    ('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
*/
  //**********************
  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 30, 15, 15),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/login_icon.svg",
                  ),
                  Text(
                    'تسجيل دخول كفرد',
                    style: TextStyle(fontFamily: fontHiding1, color: myBlue, fontSize: 34),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 300,
                    width: 300,
                    child: MobileScanner(
                      allowDuplicates: false,
                      controller: cameraController,
                      onDetect: _foundBarcode,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'لتسجيل الدخول السريع على هذا الجهاز',
                          style: TextStyle(fontFamily: fontHiding2, color: myBlue, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.file_download),
                      SizedBox(
                        height: 5,
                      ),
                      Flexible(
                        child: Text(
                          "بعد تنزيل برنامج الابن الرضي على جهازك قم اولا بإنشاء حساب مشرف",
                          style: TextStyle(fontFamily: fontHiding2, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.group),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          "في صفحة عائلتي اضغط على علامة الزائد وثم بانشاء عضو في الاسرة",
                          style: TextStyle(fontFamily: fontHiding2, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.center_focus_weak),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          "اضغط على حساب العضو الجديد وسيظهر لك QR خاص بحساب العضو\nقم بمسحه من خلال الكاميرا فقي هذه الصفحة",
                          style: TextStyle(fontFamily: fontHiding2, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
