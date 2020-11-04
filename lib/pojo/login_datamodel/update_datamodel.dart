// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

UpdateDataModel welcomeFromJson(String str) => UpdateDataModel.fromJson(json.decode(str));

String welcomeToJson(UpdateDataModel data) => json.encode(data.toJson());

class UpdateDataModel {
  UpdateDataModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  Data data;

  factory UpdateDataModel.fromJson(Map<String, dynamic> json) => UpdateDataModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.userid,
    this.name,
    this.useremail,
    this.phone,
    this.province,
    this.isSupplier,
    this.credits,
    this.thumbnailimage,
  });

  String userid;
  String name;
  String useremail;
  String phone;
  String province;
  String isSupplier;
  String credits;
  String thumbnailimage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userid: json["userid"],
    name: json["name"],
    useremail: json["useremail"],
    phone: json["phone"],
    province: json["province"],
    isSupplier: json["is_supplier"],
    credits: json["credits"],
    thumbnailimage: json["thumbnailimage"],
  );

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "name": name,
    "useremail": useremail,
    "phone": phone,
    "province": province,
    "is_supplier": isSupplier,
    "credits": credits,
    "thumbnailimage": thumbnailimage,
  };
}
