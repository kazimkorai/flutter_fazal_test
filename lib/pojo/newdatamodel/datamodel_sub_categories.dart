// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

SubCategoriesDataModel welcomeFromJson(String str) => SubCategoriesDataModel.fromJson(json.decode(str));

String welcomeToJson(SubCategoriesDataModel data) => json.encode(data.toJson());

class SubCategoriesDataModel {
  SubCategoriesDataModel({
    this.status,
    this.subcat,
    this.response,
  });

  bool status;
  int subcat;
  List<Response> response;

  factory SubCategoriesDataModel.fromJson(Map<String, dynamic> json) => SubCategoriesDataModel(
    status: json["status"],
    subcat: json["subcat"],
    response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "subcat": subcat,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}

class Response {
  Response({
    this.establishmentid,
    this.establishmentname,
    this.establishmentaddress,
    this.establishmentrating,
    this.userid,
    this.establishmentregion,
    this.establishmentimage,
  });

  String establishmentid;
  String establishmentname;
  dynamic establishmentaddress;
  dynamic establishmentrating;
  dynamic userid;
  dynamic establishmentregion;
  String establishmentimage;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    establishmentid: json["establishmentid"],
    establishmentname: json["establishmentname"],
    establishmentaddress: json["establishmentaddress"],
    establishmentrating: json["establishmentrating"],
    userid: json["userid"],
    establishmentregion: json["establishmentregion"],
    establishmentimage: json["establishmentimage"],
  );

  Map<String, dynamic> toJson() => {
    "establishmentid": establishmentid,
    "establishmentname": establishmentname,
    "establishmentaddress": establishmentaddress,
    "establishmentrating": establishmentrating,
    "userid": userid,
    "establishmentregion": establishmentregion,
    "establishmentimage": establishmentimage,
  };
}
