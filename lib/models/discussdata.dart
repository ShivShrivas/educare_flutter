// To parse this JSON data, do
//
//     final discussData = discussDataFromJson(jsonString);

import 'dart:convert';

List<DiscussData> discussDataFromJson(String str) => List<DiscussData>.from(json.decode(str).map((x) => DiscussData.fromJson(x)));

String discussDataToJson(List<DiscussData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiscussData {
  DiscussData({
    required this.code,
    required this.complainAgainest,
    required this.complainBy,
    required this.complain,
    required this.createdDate,
    required this.createdTime,
    required this.discussDatumClass,
    required this.studentName,
    required this.studentCode,
    required this.classCode,
    required this.senderId,
  });

  String code;
  String complainAgainest;
  String complainBy;
  String complain;
  String createdDate;
  String createdTime;
  String discussDatumClass;
  String studentName;
  String studentCode;
  String classCode;
  int senderId;

  factory DiscussData.fromJson(Map<String, dynamic> json) => DiscussData(
    code: json["Code"],
    complainAgainest: json["ComplainAgainest"],
    complainBy: json["ComplainBy"],
    complain: json["Complain"],
    createdDate: json["CreatedDate"],
    createdTime: json["CreatedTime"],
    discussDatumClass: json["Class"],
    studentName: json["StudentName"],
    studentCode: json["StudentCode"],
    classCode: json["ClassCode"],
    senderId: json["SenderID"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "ComplainAgainest": complainAgainest,
    "ComplainBy": complainBy,
    "Complain": complain,
    "CreatedDate": createdDate,
    "CreatedTime": createdTime,
    "Class": discussDatumClass,
    "StudentName": studentName,
    "StudentCode": studentCode,
    "ClassCode": classCode,
    "SenderID": senderId,
  };
}
