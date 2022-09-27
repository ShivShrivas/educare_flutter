// To parse this JSON data, do
//
//     final classDataList = classDataListFromJson(jsonString);

import 'dart:convert';

List<ClassDataList> classDataListFromJson(String str) => List<ClassDataList>.from(json.decode(str).map((x) => ClassDataList.fromJson(x)));

String classDataListToJson(List<ClassDataList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClassDataList {
  ClassDataList({
    required this.className,
    required this.classCode,
  });

  String className;
  String classCode;

  factory ClassDataList.fromJson(Map<String, dynamic> json) => ClassDataList(
    className: json["ClassName"],
    classCode: json["Code"],
  );

  Map<String, dynamic> toJson() => {
    "ClassName": className,
    "Code": classCode,
  };
}
