// To parse this JSON data, do
//
//     final employeeData = employeeDataFromJson(jsonString);

import 'dart:convert';

List<EmployeeData> employeeDataFromJson(String str) => List<EmployeeData>.from(json.decode(str).map((x) => EmployeeData.fromJson(x)));

String employeeDataToJson(List<EmployeeData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeData {
  EmployeeData({
    required this.code,
    required this.employeeName,
    required this.employeeCode,
    required this.employeeId,
    required this.maxPeriodInWeek,
    required this.displayName,
  });

  String code;
  String employeeName;
  String employeeCode;
  String employeeId;
  int maxPeriodInWeek;
  String displayName;

  factory EmployeeData.fromJson(Map<String, dynamic> json) => EmployeeData(
    code: json["Code"],
    employeeName: json["EmployeeName"],
    employeeCode: json["EmployeeCode"],
    employeeId: json["EmployeeId"],
    maxPeriodInWeek: json["MaxPeriodInWeek"],
    displayName: json["DisplayName"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "EmployeeName": employeeName,
    "EmployeeCode": employeeCode,
    "EmployeeId": employeeId,
    "MaxPeriodInWeek": maxPeriodInWeek,
    "DisplayName": displayName,
  };
}
