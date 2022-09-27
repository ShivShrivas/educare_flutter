// To parse this JSON data, do
//
//     final classData = classDataFromJson(jsonString);

import 'dart:convert';

List<ClassData> classDataFromJson(String str) => List<ClassData>.from(json.decode(str).map((x) => ClassData.fromJson(x)));

String classDataToJson(List<ClassData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClassData {
  ClassData({
    required this.code,
    required this.className,
    required this.courseName,
    required this.isActive,
    required this.courseCode,
    required this.displayOrder,
  });

  String code;
  String className;
  String courseName;
  bool isActive;
  String courseCode;
  int displayOrder;

  factory ClassData.fromJson(Map<String, dynamic> json) => ClassData(
    code: json["Code"],
    className: json["ClassName"],
    courseName: json["CourseName"],
    isActive: json["IsActive"],
    courseCode: json["CourseCode"],
    displayOrder: json["DisplayOrder"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "ClassName": className,
    "CourseName": courseName,
    "IsActive": isActive,
    "CourseCode": courseCode,
    "DisplayOrder": displayOrder,
  };
}
