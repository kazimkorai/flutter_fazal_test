// // To parse this JSON data, do
// //
// //     final welcome = welcomeFromJson(jsonString);
//
// import 'dart:convert';
//
// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));
//
// String welcomeToJson(Welcome data) => json.encode(data.toJson());
//
// class Welcome {
//   Welcome({
//     this.error,
//     this.message,
//     this.data,
//   });
//
//   bool error;
//   String message;
//   Data data;
//
//   factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
//     error: json["error"],
//     message: json["message"],
//     data: Data.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "error": error,
//     "message": message,
//     "data": data.toJson(),
//   };
// }
//
// class Data {
//   Data({
//     this.accessToken,
//     this.tokenType,
//     this.user,
//     this.nearVenues,
//     this.featuredVenues,
//     this.favoriteVenues,
//     this.userLocations,
//   });
//
//   String accessToken;
//   String tokenType;
//   User user;
//   List<Venue> nearVenues;
//   List<Venue> featuredVenues;
//   List<dynamic> favoriteVenues;
//   List<dynamic> userLocations;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     accessToken: json["access_token"],
//     tokenType: json["token_type"],
//     user: User.fromJson(json["user"]),
//     nearVenues: List<Venue>.from(json["nearVenues"].map((x) => Venue.fromJson(x))),
//     featuredVenues: List<Venue>.from(json["featuredVenues"].map((x) => Venue.fromJson(x))),
//     favoriteVenues: List<dynamic>.from(json["favoriteVenues"].map((x) => x)),
//     userLocations: List<dynamic>.from(json["userLocations"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "access_token": accessToken,
//     "token_type": tokenType,
//     "user": user.toJson(),
//     "nearVenues": List<dynamic>.from(nearVenues.map((x) => x.toJson())),
//     "featuredVenues": List<dynamic>.from(featuredVenues.map((x) => x.toJson())),
//     "favoriteVenues": List<dynamic>.from(favoriteVenues.map((x) => x)),
//     "userLocations": List<dynamic>.from(userLocations.map((x) => x)),
//   };
// }
//
// class Venue {
//   Venue({
//     this.venueId,
//     this.name,
//     this.banner,
//     this.latitude,
//     this.longitude,
//     this.distance,
//     this.averageRating,
//     this.favorite,
//     this.status,
//   });
//
//   int venueId;
//   String name;
//   String banner;
//   String latitude;
//   String longitude;
//   double distance;
//   String averageRating;
//   String favorite;
//   int status;
//
//   factory Venue.fromJson(Map<String, dynamic> json) => Venue(
//     venueId: json["venue_id"],
//     name: json["name"],
//     banner: json["banner"],
//     latitude: json["latitude"],
//     longitude: json["longitude"],
//     distance: json["distance"].toDouble(),
//     averageRating: json["average_rating"],
//     favorite: json["favorite"],
//     status: json["status"] == null ? null : json["status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "venue_id": venueId,
//     "name": name,
//     "banner": banner,
//     "latitude": latitude,
//     "longitude": longitude,
//     "distance": distance,
//     "average_rating": averageRating,
//     "favorite": favorite,
//     "status": status == null ? null : status,
//   };
// }
//
// class User {
//   User({
//     this.userId,
//     this.name,
//     this.email,
//     this.dob,
//     this.image,
//     this.roll,
//     this.gender,
//     this.phone,
//     this.address,
//     this.connectStatus,
//     this.connectedVenueId,
//     this.connectHostType,
//     this.orderId,
//     this.status,
//     this.deviceToken,
//   });
//
//   int userId;
//   String name;
//   String email;
//   DateTime dob;
//   String image;
//   String roll;
//   String gender;
//   String phone;
//   dynamic address;
//   int connectStatus;
//   String connectedVenueId;
//   String connectHostType;
//   String orderId;
//   int status;
//   String deviceToken;
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     userId: json["user_id"],
//     name: json["name"],
//     email: json["email"],
//     dob: DateTime.parse(json["dob"]),
//     image: json["image"],
//     roll: json["roll"],
//     gender: json["gender"],
//     phone: json["phone"],
//     address: json["address"],
//     connectStatus: json["connect_status"],
//     connectedVenueId: json["connected_venue_id"],
//     connectHostType: json["connect_host_type"],
//     orderId: json["order_id"],
//     status: json["status"],
//     deviceToken: json["device_token"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "user_id": userId,
//     "name": name,
//     "email": email,
//     "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
//     "image": image,
//     "roll": roll,
//     "gender": gender,
//     "phone": phone,
//     "address": address,
//     "connect_status": connectStatus,
//     "connected_venue_id": connectedVenueId,
//     "connect_host_type": connectHostType,
//     "order_id": orderId,
//     "status": status,
//     "device_token": deviceToken,
//   };
// }
