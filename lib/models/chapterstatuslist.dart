// To parse this JSON data, do
//
//     final chapterStatusList = chapterStatusListFromJson(jsonString);

import 'dart:convert';

List<ChapterStatusList> chapterStatusListFromJson(String str) => List<ChapterStatusList>.from(json.decode(str).map((x) => ChapterStatusList.fromJson(x)));

String chapterStatusListToJson(List<ChapterStatusList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChapterStatusList {
  ChapterStatusList({
    required this.className,
    required this.subjectName,
    required this.chapterName,
    required this.statusDate,
    required this.status,
    required this.remark,
  });

  String className;
  String subjectName;
  String chapterName;
  String statusDate;
  int status;
  String remark;

  factory ChapterStatusList.fromJson(Map<String, dynamic> json) => ChapterStatusList(
    className: json["ClassName"],
    subjectName: json["SubjectName"],
    chapterName: json["ChapterName"],
    statusDate: json["StatusDate"],
    status: json["Status"],
    remark: json["Remark"],
  );

  Map<String, dynamic> toJson() => {
    "ClassName": className,
    "SubjectName": subjectName,
    "ChapterName": chapterName,
    "StatusDate": statusDate,
    "Status": status,
    "Remark": remark,
  };
}
