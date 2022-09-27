// To parse this JSON data, do
//
//     final roleData = roleDataFromJson(jsonString);

import 'dart:convert';

List<RoleData> roleDataFromJson(String str) => List<RoleData>.from(json.decode(str).map((x) => RoleData.fromJson(x)));

String roleDataToJson(List<RoleData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoleData {
  RoleData({
    required this.profileName,
    required this.userId,
    required this.designation,
    required this.profilePic,
  });

  dynamic profileName;
  int userId;
  dynamic designation;
  dynamic profilePic;

  factory RoleData.fromJson(Map<String, dynamic> json) => RoleData(
    profileName: json["ProfileName"],
    userId: json["UserId"],
    designation: json["Designation"],
    profilePic: json["ProfilePic"],
  );

  Map<String, dynamic> toJson() => {
    "ProfileName": profileName,
    "UserId": userId,
    "Designation": designation,
    "ProfilePic": profilePic,
  };
}
