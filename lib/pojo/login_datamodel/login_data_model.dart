// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

LoginDataModel welcomeFromJson(String str) => LoginDataModel.fromJson(json.decode(str));

String welcomeToJson(LoginDataModel data) => json.encode(data.toJson());

class LoginDataModel {
  LoginDataModel({
    this.status,
    this.message,
    this.detail,
  });

  bool status;
  String message;
  Detail detail;

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
    status: json["status"],
    message: json["message"],
    detail: Detail.fromJson(json["detail"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "detail": detail.toJson(),
  };
}

class Detail {
  Detail({
    this.userid,
    this.name,
    this.useremail,
    this.phone,
    this.province,
    this.is_supplier,
    this.credits,
    this.thumbnailimage,
    this.welcomeVideo,
  });

  String userid;
  String name;
  String useremail;
  String phone;
  String province;
  String is_supplier;
  String credits;
  String thumbnailimage;
  String welcomeVideo;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    userid: json["userid"],
    name: json["name"],
    useremail: json["useremail"],
    phone: json["phone"],
    province: json["province"],
    is_supplier: json["is_supplier"],
    credits: json["credits"],
    thumbnailimage: json["thumbnailimage"],
    welcomeVideo: json["welcome_video"],
  );

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "name": name,
    "useremail": useremail,
    "phone": phone,
    "province": province,
    "is_supplier": is_supplier,
    "credits": credits,
    "thumbnailimage": thumbnailimage,
    "welcome_video": welcomeVideo,
  };
}
