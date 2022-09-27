// To parse this JSON data, do
//
//     final teacherDataList = teacherDataListFromJson(jsonString);

import 'dart:convert';

List<TeacherDataList> teacherDataListFromJson(String str) => List<TeacherDataList>.from(json.decode(str).map((x) => TeacherDataList.fromJson(x)));

String teacherDataListToJson(List<TeacherDataList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TeacherDataList {
  TeacherDataList({
    required this.teacherCode,
    required this.teacher,
    required this.photo,
  });

  String teacherCode;
  String teacher;
  String photo;

  factory TeacherDataList.fromJson(Map<String, dynamic> json) => TeacherDataList(
    teacherCode: json["TeacherCode"],
    teacher: json["Teacher"],
    photo: json["Photo"],
  );

  Map<String, dynamic> toJson() => {
    "TeacherCode": teacherCode,
    "Teacher": teacher,
    "Photo": photo,
  };
}
