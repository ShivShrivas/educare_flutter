// To parse this JSON data, do
//
//     final studentData = studentDataFromJson(jsonString);

import 'dart:convert';

List<StudentData> studentDataFromJson(String str) => List<StudentData>.from(json.decode(str).map((x) => StudentData.fromJson(x)));

String studentDataToJson(List<StudentData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentData {
  StudentData({
    required  this.studentCode,
    required this.classCode,
    required this.sectionCode,
    required this.className,
    required this.sectionName,
    required this.fatherName,
    required this.motherName,
    required this.name,
    required this.mobile,
    required this.dob,
    required this.dateOfAdmission,
    this.studentPhoto,
  });

  String studentCode;
  String classCode;
  dynamic sectionCode;
  String className;
  dynamic sectionName;
  String fatherName;
  String motherName;
  String name;
  String mobile;
  String dob;
  String dateOfAdmission;
  dynamic studentPhoto;

  factory StudentData.fromJson(Map<String, dynamic> json) => StudentData(
    studentCode: json["StudentCode"],
    classCode: json["ClassCode"],
    sectionCode: json["SectionCode"],
    className: json["ClassName"],
    sectionName: json["SectionName"],
    fatherName: json["FatherName"],
    motherName: json["MotherName"],
    name: json["Name"],
    mobile: json["Mobile"],
    dob: json["DOB"],
    dateOfAdmission: json["DateOfAdmission"],
    studentPhoto: json["StudentPhoto"],
  );

  Map<String, dynamic> toJson() => {
    "StudentCode": studentCode,
    "ClassCode": classCode,
    "SectionCode": sectionCode,
    "ClassName": className,
    "SectionName": sectionName,
    "FatherName": fatherName,
    "MotherName": motherName,
    "Name": name,
    "Mobile": mobile,
    "DOB": dob,
    "DateOfAdmission": dateOfAdmission,
    "StudentPhoto": studentPhoto,
  };
}
