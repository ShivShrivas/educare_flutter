// To parse this JSON data, do
//
//     final leaveTypeMaster = leaveTypeMasterFromJson(jsonString);

import 'dart:convert';

List<LeaveTypeMaster> leaveTypeMasterFromJson(String str) => List<LeaveTypeMaster>.from(json.decode(str).map((x) => LeaveTypeMaster.fromJson(x)));

String leaveTypeMasterToJson(List<LeaveTypeMaster> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveTypeMaster {
  LeaveTypeMaster({
    required this.abbrTypeId,
    required this.abbrType,
    required this.abbrFor,
    required this.code,
    required this.abbrTypeId1,
    required this.totalLeaves,
    required this.isActive,
    required this.fyId,
    required this.sessionId,
    required  this.createdOn,
    required this.createdBy,
    required this.isDeleted,
  });

  int abbrTypeId;
  String abbrType;
  String abbrFor;
  String code;
  int abbrTypeId1;
  int totalLeaves;
  bool isActive;
  int fyId;
  int sessionId;
  DateTime createdOn;
  int createdBy;
  bool isDeleted;

  factory LeaveTypeMaster.fromJson(Map<String, dynamic> json) => LeaveTypeMaster(
    abbrTypeId: json["AbbrTypeId"],
    abbrType: json["AbbrType"],
    abbrFor: json["AbbrFor"],
    code: json["Code"],
    abbrTypeId1: json["AbbrTypeId1"],
    totalLeaves: json["TotalLeaves"],
    isActive: json["IsActive"],
    fyId: json["FYId"],
    sessionId: json["SessionId"],
    createdOn: DateTime.parse(json["CreatedOn"]),
    createdBy: json["CreatedBy"],
    isDeleted: json["IsDeleted"],
  );

  Map<String, dynamic> toJson() => {
    "AbbrTypeId": abbrTypeId,
    "AbbrType": abbrType,
    "AbbrFor": abbrFor,
    "Code": code,
    "AbbrTypeId1": abbrTypeId1,
    "TotalLeaves": totalLeaves,
    "IsActive": isActive,
    "FYId": fyId,
    "SessionId": sessionId,
    "CreatedOn": createdOn.toIso8601String(),
    "CreatedBy": createdBy,
    "IsDeleted": isDeleted,
  };
}
