// To parse this JSON data, do
//
//     final classSectionData = classSectionDataFromJson(jsonString);

import 'dart:convert';

List<ClassSectionData> classSectionDataFromJson(String str) => List<ClassSectionData>.from(json.decode(str).map((x) => ClassSectionData.fromJson(x)));

String classSectionDataToJson(List<ClassSectionData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClassSectionData {
  ClassSectionData({
    this.code,
    this.className,
    this.classCode,
    this.sectionName,
    this.isActive,
    this.classIsActive,
  });

  String? code;
  String? className;
  String? classCode;
  String? sectionName;
  bool? isActive;
  bool? classIsActive;

  factory ClassSectionData.fromJson(Map<String, dynamic> json) => ClassSectionData(
    code: json["Code"],
    className: json["ClassName"],
    classCode: json["ClassCode"],
    sectionName: json["SectionName"],
    isActive: json["IsActive"],
    classIsActive: json["ClassIsActive"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "ClassName": className,
    "ClassCode": classCode,
    "SectionName": sectionName,
    "IsActive": isActive,
    "ClassIsActive": classIsActive,
  };
}

