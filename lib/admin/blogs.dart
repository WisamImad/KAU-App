import 'dart:io';
import 'dart:math';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/connection.dart';
import 'package:path_provider/path_provider.dart';

class AddModifyBlog extends StatefulWidget {
  String? title;
  String? id;
  String? content;
  String? imageURL;
  bool? isEdit;

  AddModifyBlog(
      {this.id, this.title, this.content, this.imageURL, this.isEdit});

  @override
  _AddModifyBlogState createState() => _AddModifyBlogState();
}

class _AddModifyBlogState extends State<AddModifyBlog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  Future<File>? imageFile;
  bool _isImage = false;
  File? _image;
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

  bool _addBlogBtnLoading = false;
  bool _addBlogBtnEnable = true;

  bool validateLogin() {
    return _titleController.text.length > 0 &&
        _contentController.text.length > 0;
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

//change to null
  Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File? file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    http.Response response =
        await http.get(Uri.parse(Conn.serverURL + imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  @override
  void initState() {
    _contentController.text = widget.content!;
    _titleController.text = widget.title!;

    if (widget.imageURL != null) {
      imageFile = urlToFile(widget.imageURL!);
    }
    super.initState();
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
            color: myBink,
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          title: Text(
            widget.isEdit! ? "تعديل" : "مذكرة جديدة",
            style: TextStyle(
              fontFamily: fontHiding1,
              fontSize: 30,
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
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      onChanged: (v) {
                        setState(() {});
                      },
                      textInputAction: TextInputAction.next,
                      focusNode: _titleFocus,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(context, _titleFocus, _contentFocus);
                      },
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.title,
                          color: myBlue,
                          size: 30,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[400]!, width: 0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: myBlue, width: 0.5),
                        ),
                        labelStyle:
                            TextStyle(fontFamily: fontHiding2, color: myBlue),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        labelText: 'عنوان المذكرة',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (v) {
                        setState(() {});
                      },
                      focusNode: _contentFocus,
                      onFieldSubmitted: (term) {
                        _contentFocus.unfocus();
                      },
                      minLines: 9,
                      maxLines: null,
                      controller: _contentController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          prefixIcon: Icon(
                            Icons.content_paste,
                            color: myBlue,
                            size: 30,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey[400]!, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: myBlue, width: 0.5),
                          ),
                          labelStyle:
                              TextStyle(fontFamily: fontHiding2, color: myBlue),
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          labelText: ' محتوى المذكرة',
                          hintText: 'مثال: لقد لاحظت اليوم ...',
                          alignLabelWithHint: true),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    showImage(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            child: RaisedButton(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.camera_alt,
                                    color: myBlue,
                                    size: 60,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'التقاط صورة',
                                    style: TextStyle(
                                        fontFamily: fontHiding2,
                                        color: myBlue,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                              onPressed: () {
                                gallaryphoto(ImageSource.camera);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            child: RaisedButton(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.add_photo_alternate,
                                    color: myBlue,
                                    size: 60,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'اختيار من الالبوم',
                                    style: TextStyle(
                                        fontFamily: fontHiding2,
                                        color: myBlue,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                              onPressed: () {
                                gallaryphoto(ImageSource.gallery);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: RaisedButton(
                        color: myBink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        onPressed: validateLogin() && _addBlogBtnEnable
                            ? _addBlog
                            : null,
                        child: _addBlogBtnLoading
                            ? SpinKitRipple(
                                color: Colors.white,
                              )
                            : Text(widget.isEdit! ? "تعديل" : "إضافة",
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
    );
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          print('youssef${snapshot.data}');
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
          print('yousef222');
          return const CircularProgressIndicator();
        }
      },
    );
  }

//Open gallery
/*
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
      _isImage = true;
    });
  }*/
  gallaryphoto(ImageSource source) async {
    final PickedFile = await ImagePicker().getImage(source: source);
    final bytes = await PickedFile?.readAsBytes();
    setState(() {
      _image = File(PickedFile!.path);
    });
  }

  _asyncFileUpload(String title, String content, File file) async {
    setState(() {
      _addBlogBtnEnable = false;
      _addBlogBtnLoading = true;
    });

    var request = http.MultipartRequest(
        widget.isEdit! ? "PUT" : "POST", Uri.parse(Conn.blogURL));
    if (_isImage) {
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      //create multipart using filepath, string or bytes
      var pic = await http.MultipartFile("image", stream, length,
          filename: "${DateTime.now()}.png");
      //add multipart to request
      request.files.add(pic);
    }
    if (widget.isEdit!) {
      request.fields["blog_id"] = widget.id ?? "";
    }
    request.fields["title"] = title;
    request.fields["content"] = content;
    request.headers['Authorization'] = 'token ${Conn.token}';

    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    setState(() {
      _addBlogBtnEnable = true;
      _addBlogBtnLoading = false;
    });
    Navigator.pop(context);
  }

  _addBlog() async {
    File? file;

    if (_isImage) {
      await imageFile!.then((value) => file = value);
    }

    _asyncFileUpload(_titleController.text, _contentController.text, file!);
  }
}
