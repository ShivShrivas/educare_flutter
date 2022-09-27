// To parse this JSON data, do
//
//     final loginData = loginDataFromJson(jsonString);

import 'dart:convert';

List<LoginData> loginDataFromJson(String str) => List<LoginData>.from(json.decode(str).map((x) => LoginData.fromJson(x)));

String loginDataToJson(List<LoginData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginData {
  LoginData({
    required this.userId,
    required this.username,
    required this.email,
    required this.mobile,
    required this.userTypeId,
    required this.isActive,
    required this.gsmid,
  });

  int userId;
  String username;
  String email;
  String mobile;
  int userTypeId;
  int isActive;
  String gsmid;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    userId: json["UserId"],
    username: json["Username"],
    email: json["Email"],
    mobile: json["Mobile"],
    userTypeId: json["UserTypeId"],
    isActive: json["IsActive"],
    gsmid: json["GSMID"],
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "Username": username,
    "Email": email,
    "Mobile": mobile,
    "UserTypeId": userTypeId,
    "IsActive": isActive,
    "GSMID": gsmid,
  };
}
