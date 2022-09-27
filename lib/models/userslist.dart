// To parse this JSON data, do
//
//     final userType = userTypeFromJson(jsonString);

import 'dart:convert';

List<UserType> userTypeFromJson(String str) => List<UserType>.from(json.decode(str).map((x) => UserType.fromJson(x)));

String userTypeToJson(List<UserType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserType {
  UserType({
    required this.roleId,
    required this.levelName,
    required this.roleName,
    required this.userLevel,
    required this.displayOrder,
    required this.isActive,
  });

  int roleId;
  String levelName;
  String roleName;
  String userLevel;
  String displayOrder;
  bool isActive;

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
    roleId: json["RoleId"],
    levelName: json["LevelName"],
    roleName: json["RoleName"],
    userLevel: json["UserLevel"],
    displayOrder: json["DisplayOrder"],
    isActive: json["IsActive"],
  );

  Map<String, dynamic> toJson() => {
    "RoleId": roleId,
    "LevelName": levelName,
    "RoleName": roleName,
    "UserLevel": userLevel,
    "DisplayOrder": displayOrder,
    "IsActive": isActive,
  };
}
