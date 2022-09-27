// To parse this JSON data, do
//
//     final empleaveData = empleaveDataFromJson(jsonString);

import 'dart:convert';

List<EmpleaveData> empleaveDataFromJson(String str) => List<EmpleaveData>.from(json.decode(str).map((x) => EmpleaveData.fromJson(x)));

String empleaveDataToJson(List<EmpleaveData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmpleaveData {
  EmpleaveData({
    required this.dateData,
    required this.abbrTypeIdFirst,
    required this.firstIsApproved,
    required this.abbrTypeIdSecond,
    required this.secondIsApproved,
    this.leaveTypeName,
    this.secondLeaveTypeName,
  });

  String dateData;
  String abbrTypeIdFirst;
  String firstIsApproved;
  String abbrTypeIdSecond;
  String secondIsApproved;
  String? leaveTypeName;
  String? secondLeaveTypeName;

  factory EmpleaveData.fromJson(Map<String, dynamic> json) => EmpleaveData(
    dateData: json["DateData"],
    abbrTypeIdFirst: json["AbbrTypeIdFirst"]==null ? "0":json["AbbrTypeIdFirst"],
    firstIsApproved: json["FirstIsApproved"]==null ? "":json["FirstIsApproved"],
    abbrTypeIdSecond: json["AbbrTypeIdSecond"]==null ? "0":json["AbbrTypeIdSecond"],
    secondIsApproved: json["SecondIsApproved"]==null ? "":json["SecondIsApproved"],
    leaveTypeName: json["LeaveTypeName"]=="Leave Without Pay" ? "LWP":json["LeaveTypeName"]==null?"":json["LeaveTypeName"],
    secondLeaveTypeName: json["SecondLeaveTypeName"]=="Leave Without Pay" ? "LWP":json["SecondLeaveTypeName"]==null?"":json["SecondLeaveTypeName"],
  );

  Map<String, dynamic> toJson() => {
    "DateData": dateData,
    "AbbrTypeIdFirst": abbrTypeIdFirst,
    "FirstIsApproved": firstIsApproved,
    "AbbrTypeIdSecond": abbrTypeIdSecond,
    "SecondIsApproved": secondIsApproved,
    "LeaveTypeName": leaveTypeName,
    "SecondLeaveTypeName": secondLeaveTypeName,
  };
}
