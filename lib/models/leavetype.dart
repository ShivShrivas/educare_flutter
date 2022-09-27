// To parse this JSON data, do
//
//     final leaveTypeData = leaveTypeDataFromJson(jsonString);

import 'dart:convert';

List<LeaveTypeData> leaveTypeDataFromJson(String str) => List<LeaveTypeData>.from(json.decode(str).map((x) => LeaveTypeData.fromJson(x)));

String leaveTypeDataToJson(List<LeaveTypeData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveTypeData {
  LeaveTypeData({
    required this.abbrTypeId,
    required this.abbrType,
    required this.code,
  });

  int abbrTypeId;
  String code;
  String abbrType;

  factory LeaveTypeData.fromJson(Map<String, dynamic> json) => LeaveTypeData(
    abbrTypeId: json["AbbrTypeId"],
    abbrType: json["AbbrType"],
    code: json["Code"],
  );

  Map<String, dynamic> toJson() => {
    "AbbrTypeId": abbrTypeId,
    "AbbrType": abbrType,
    "Code": code,
  };
}
