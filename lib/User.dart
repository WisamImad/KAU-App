import 'package:flutter/cupertino.dart';

class MainUser {
  static String? name;
  static String? email;
  static String? birthday;
  static Map? role;
  static Map? family;
  static Map? permission;
  static NetworkImage? pic;
  static bool? isEmailVerified;
}

class Member {
  int? id;
  String? name;
  String? username;
  String? password;
  Map? role;
  String? birthday;
  int? level;
  NetworkImage? pic;
  String? picURL;
  int? score;

  Member(
      {this.id,
      this.username,
      this.name,
      this.password,
      this.role,
      this.level,
      this.pic,
      this.birthday,
      this.picURL,
      this.score});
}
