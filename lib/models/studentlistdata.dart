// To parse this JSON data, do
//
//     final studentListData = studentListDataFromJson(jsonString);

import 'dart:convert';

List<StudentListData> studentListDataFromJson(String str) => List<StudentListData>.from(json.decode(str).map((x) => StudentListData.fromJson(x)));

String studentListDataToJson(List<StudentListData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentListData {
  StudentListData({
    required this.id,
    required this.className,
    required this.name,
    required this.fatherName,
    required this.studentPhoto,
    required this.abbrType,
  });

  String id;
  String className;
  String name;
  String fatherName;
  String studentPhoto;
  String abbrType;

  factory StudentListData.fromJson(Map<String, dynamic> json) => StudentListData(
    id: json["ID"],
    className: json["ClassName"],
    name: json["Name"],
    fatherName: json["FatherName"]== null ? "" : json["FatherName"],
    studentPhoto: json["StudentPhoto"] == null ? "" : json["StudentPhoto"],
    abbrType: json["AbbrType"] == null ? "" : json["AbbrType"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "ClassName": className,
    "Name": name,
    "FatherName": fatherName,
    "StudentPhoto": studentPhoto == null ? null : studentPhoto,
    "AbbrType": abbrType == null ? null : abbrType,
  };
}
