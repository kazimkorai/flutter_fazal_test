// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

HomeCatModel welcomeFromJson(String str) => HomeCatModel.fromJson(json.decode(str));

String welcomeToJson(HomeCatModel data) => json.encode(data.toJson());

class HomeCatModel {
  HomeCatModel({
    this.status,
    this.detail,
  });

  bool status;
  List<Detail> detail;

  factory HomeCatModel.fromJson(Map<String, dynamic> json) => HomeCatModel(
    status: json["status"],
    detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
  };
}

class Detail {
  Detail({
    this.catid,
    this.catname,
    this.catimage,
  });

  String catid;
  String catname;
  String catimage;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    catid: json["catid"],
    catname: json["catname"],
    catimage: json["catimage"],
  );

  Map<String, dynamic> toJson() => {
    "catid": catid,
    "catname": catname,
    "catimage": catimage,
  };
}
