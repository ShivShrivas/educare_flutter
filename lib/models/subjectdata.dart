// To parse this JSON data, do
//
//     final subjectData = subjectDataFromJson(jsonString);

import 'dart:convert';

List<SubjectData> subjectDataFromJson(String str) => List<SubjectData>.from(json.decode(str).map((x) => SubjectData.fromJson(x)));

String subjectDataToJson(List<SubjectData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubjectData {
  SubjectData({
    required this.subjectName,
    required this.code,
    required this.classCode,
    required this.sectionCode,
    required this.isActive,
  });

  String subjectName;
  String code;
  String classCode;
  String sectionCode;
  bool isActive;

  factory SubjectData.fromJson(Map<String, dynamic> json) => SubjectData(
    subjectName: json["SubjectName"],
    code: json["Code"],
    classCode: json["ClassCode"],
    sectionCode: json["SectionCode"],
    isActive: json["IsActive"],
  );

  Map<String, dynamic> toJson() => {
    "SubjectName": subjectName,
    "Code": code,
    "ClassCode": classCode,
    "SectionCode": sectionCode,
    "IsActive": isActive,
  };
}
