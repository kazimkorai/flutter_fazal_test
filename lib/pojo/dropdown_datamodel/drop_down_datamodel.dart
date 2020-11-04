
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

DropDownDataModel welcomeFromJson(String str) => DropDownDataModel.fromJson(json.decode(str));

String welcomeToJson(DropDownDataModel data) => json.encode(data.toJson());

class DropDownDataModel {
  DropDownDataModel({
    this.status,
    this.region,
  });

  bool status;
  List<Region> region;

  factory DropDownDataModel.fromJson(Map<String, dynamic> json) => DropDownDataModel(
    status: json["status"],
    region: List<Region>.from(json["region"].map((x) => Region.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "region": List<dynamic>.from(region.map((x) => x.toJson())),
  };
}

class Region {
  Region({
    this.id,
    this.regionname,
  });

  String id;
  String regionname;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    id: json["id"],
    regionname: json["regionname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "regionname": regionname,
  };
}
