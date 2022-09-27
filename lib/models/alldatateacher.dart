// To parse this JSON data, do
//
//     final teacherListData = teacherListDataFromJson(jsonString);

import 'dart:convert';

List<TeacherListData> teacherListDataFromJson(String str) => List<TeacherListData>.from(json.decode(str).map((x) => TeacherListData.fromJson(x)));

String teacherListDataToJson(List<TeacherListData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TeacherListData {
  TeacherListData({
   required this.employeeName,
    required this.employeeCode,
    required this.employeeId,
    required this.displayName,
  });

  String employeeName;
  String employeeCode;
  String employeeId;
  String displayName;

  factory TeacherListData.fromJson(Map<String, dynamic> json) => TeacherListData(
    employeeName: json["EmployeeName"],
    employeeCode: json["EmployeeCode"],
    employeeId: json["EmployeeId"],
    displayName: json["DisplayName"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeName": employeeName,
    "EmployeeCode": employeeCode,
    "EmployeeId": employeeId,
    "DisplayName": displayName,
  };
}
