// import 'dart:convert';
//
// class Address {
//   final String? streetAddress;
//   final String? city;
//   final String? state;
//   final String? postalCode;
//   final String? id;
//
//   Address({
//     this.streetAddress,
//     this.city,
//     this.state,
//     this.postalCode,
//     this.id,
//   });
//
//   factory Address.fromJson(Map<String, dynamic> json) {
//     return Address(
//       streetAddress: json['streetAddress'] ?? "",
//       city: json['city'] ?? "",
//       state: json['state'] ?? "",
//       postalCode: json['postalCode'] ?? "",
//       id: json['_id'] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'streetAddress': streetAddress,
//       'city': city,
//       'state': state,
//       'postalCode': postalCode,
//       '_id': id,
//     };
//   }
// }
//
// class Apartment {
//   final String? societyName;
//   final String? societyBlock;
//   final String? apartment;
//   final String? role;
//   final String? id;
//
//   Apartment({
//     required this.societyName,
//     required this.societyBlock,
//     required this.apartment,
//     required this.role,
//     required this.id,
//   });
//
//   factory Apartment.fromJson(Map<String, dynamic> json) {
//     return Apartment(
//       societyName: json['societyName'] ?? "",
//       societyBlock: json['societyBlock'] ?? "",
//       apartment: json['apartment'] ?? "",
//       role: json['role'] ?? "",
//       id: json['_id'] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'societyName': societyName,
//       'societyBlock': societyBlock,
//       'apartment': apartment,
//       'role': role,
//       '_id': id,
//     };
//   }
// }
//
// class Gate {
//   final String? id;
//   final String? societyName;
//   final String? gateAssign;
//
//   Gate({
//     required this.id,
//     required this.societyName,
//     required this.gateAssign,
//   });
//
//   factory Gate.fromJson(Map<String, dynamic> json) {
//     return Gate(
//       id: json['_id'] ?? "",
//       societyName: json['societyName'] ?? "",
//       gateAssign: json['gateAssign'] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'societyName': societyName,
//       'gateAssign': gateAssign,
//     };
//   }
// }
//
// class GetUserModel {
//   final String? id;
//   final String? userName;
//   final String? email;
//   final String? phoneNo;
//   final String? profile;
//   final String? role;
//   final String? profileType;
//   final String? createdAt;
//   final Address? address;
//   final List<Apartment>? apartments;
//   final List<Gate>? gate;
//   final int? age;
//   final String? gender;
//   final int? statusCode;
//   final String? message;
//
//   GetUserModel({
//     this.id,
//     this.userName,
//     this.email,
//     this.phoneNo,
//     this.profile,
//     this.role,
//     this.profileType,
//     this.createdAt,
//     this.address,
//     this.apartments,
//     this.gate,
//     this.age,
//     this.gender,
//     this.statusCode,
//     this.message,
//   });
//
//   factory GetUserModel.fromJson(Map<String, dynamic> json) {
//     return GetUserModel(
//       id: json['data']['_id'] ?? "",
//       userName: json['data']['userName'] ?? "",
//       email: json['data']['email'] ?? "",
//       phoneNo: json['data']['phoneNo'] ?? "",
//       profile: json['data']['profile'] ?? "",
//       role: json['data']['role'] ?? "",
//       profileType: json['data']['profileType'] ?? "",
//       createdAt: json['data']['createdAt'] ?? "",
//       address: json['data']['address'] != null
//           ? Address.fromJson(json['data']['address'])
//           : null,
//       apartments: json['data']['apartments'] != null
//           ? List<Apartment>.from(json['data']['apartments'].map((x) => Apartment.fromJson(x)))
//           : [],
//       gate: json['data']['gate'] != null
//           ? List<Gate>.from(json['data']['gate'].map((x) => Gate.fromJson(x)))
//           : [],
//       age: json['data']['age'] ?? 0,
//       gender: json['data']['gender'] ?? "",
//       statusCode: json['statusCode'] ?? 0,
//       message: json['message'] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'data': {
//         '_id': id,
//         'userName': userName,
//         'email': email,
//         'profile': profile,
//         'role': role,
//         'createdAt': createdAt,
//         'address': address?.toJson(),
//         'age': age,
//         'gender': gender,
//       },
//       'statusCode': statusCode,
//       'message': message,
//     };
//   }
// }

// To parse this JSON data, do
//
//     final getUserModel = getUserModelFromJson(jsonString);

import 'dart:convert';

GetUserModel getUserModelFromJson(String str) => GetUserModel.fromJson(json.decode(str));

String getUserModelToJson(GetUserModel data) => json.encode(data.toJson());

class GetUserModel {
  final String? id;
  final String? profile;
  final String? userName;
  final String? email;
  final String? phoneNo;
  final String? role;
  final String? userType;
  final bool? isUserTypeVerified;
  final String? profileType;
  final String? societyName;
  final String? societyBlock;
  final String? apartment;
  final String? gateAssign;
  final String? checkInCode;
  final String? residentStatus;
  final String? guardStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GetUserModel({
    this.id,
    this.userName,
    this.email,
    this.profile,
    this.role,
    this.userType,
    this.isUserTypeVerified,
    this.createdAt,
    this.updatedAt,
    this.phoneNo,
    this.checkInCode,
    this.societyName,
    this.gateAssign,
    this.societyBlock,
    this.apartment,
    this.profileType,
    this.residentStatus,
    this.guardStatus,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) => GetUserModel(
    id: json["_id"],
    profile: json["profile"],
    userName: json["userName"],
    email: json["email"],
    phoneNo: json["phoneNo"],
    role: json["role"],
    userType: json['userType'],
    isUserTypeVerified: json['isUserTypeVerified'],
    profileType: json["profileType"],
    societyName: json["societyName"],
    societyBlock: json["societyBlock"],
    apartment: json["apartment"],
    gateAssign: json["gateAssign"],
    checkInCode: json["checkInCode"],
    residentStatus: json["residentStatus"],
    guardStatus: json["guardStatus"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]).toLocal(),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]).toLocal(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "profile": profile,
    "userName": userName,
    "email": email,
    "phoneNo": phoneNo,
    "role": role,
    "userType": userType,
    "isUserTypeVerified": isUserTypeVerified,
    "profileType": profileType,
    "societyName": societyName,
    "societyBlock": societyBlock,
    "apartment": apartment,
    "gateAssign": gateAssign,
    "checkInCode": checkInCode,
    "residentStatus": residentStatus,
    "guardStatus": guardStatus,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
