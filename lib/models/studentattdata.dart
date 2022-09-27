// To parse this JSON data, do
//
//     final studentAttData = studentAttDataFromJson(jsonString);

import 'dart:convert';

List<StudentAttData> studentAttDataFromJson(String str) => List<StudentAttData>.from(json.decode(str).map((x) => StudentAttData.fromJson(x)));

String studentAttDataToJson(List<StudentAttData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentAttData {
  StudentAttData({
    required this.studentId,
    required this.studentCode,
    required this.name,
    required this.fatherName,
    required this.abbrType,
  });

  String studentId;
  String studentCode;
  String name;
  String fatherName;
  String abbrType;

  factory StudentAttData.fromJson(Map<String, dynamic> json) => StudentAttData(
    studentId: json["StudentID"],
    studentCode: json["StudentCode"],
    name: json["Name"],
    fatherName: json["FatherName"]==null?'':json["FatherName"],
    abbrType: json["AbbrType"]==null?'':json["AbbrType"],
  );

  Map<String, dynamic> toJson() => {
    "StudentID": studentId,
    "StudentCode": studentCode,
    "Name": name,
    "FatherName": fatherName,
    "AbbrType": abbrType,
  };
}
