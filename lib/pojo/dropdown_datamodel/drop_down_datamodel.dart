// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

DropDownRegionModel welcomeFromJson(String str) => DropDownRegionModel.fromJson(json.decode(str));

String welcomeToJson(DropDownRegionModel data) => json.encode(data.toJson());

class DropDownRegionModel {
  DropDownRegionModel({
    this.status,
    this.region,
    this.categories,
  });

  bool status;
  List<Region> region;
  List<Category> categories;

  factory DropDownRegionModel.fromJson(Map<String, dynamic> json) => DropDownRegionModel(
    status: json["status"],
    region: List<Region>.from(json["region"].map((x) => Region.fromJson(x))),
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "region": List<dynamic>.from(region.map((x) => x.toJson())),
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    this.catId,
    this.catName,
  });

  String catId;
  String catName;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    catId: json["cat_id"],
    catName: json["cat_name"],
  );

  Map<String, dynamic> toJson() => {
    "cat_id": catId,
    "cat_name": catName,
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
