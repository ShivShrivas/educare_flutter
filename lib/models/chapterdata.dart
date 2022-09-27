// To parse this JSON data, do
//
//     final chapterData = chapterDataFromJson(jsonString);

import 'dart:convert';

List<ChapterData> chapterDataFromJson(String str) => List<ChapterData>.from(json.decode(str).map((x) => ChapterData.fromJson(x)));

String chapterDataToJson(List<ChapterData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChapterData {
  ChapterData({
    this.classCode,
    this.className,
    this.subjectCode,
    this.subjectName,
    this.bookCode,
    this.nameOfBook,
    required this.chapterId,
    this.chapterName,
    this.topic,
    required this.noOfPeriod,
    required this.status,
    required this.total_TransID,
  });

  String? classCode;
  String? className;
  String? subjectCode;
  String? subjectName;
  String? bookCode;
  String? nameOfBook;
  int chapterId;
  String? chapterName;
  String? topic;
  int noOfPeriod;
  int status;
  int total_TransID;

  factory ChapterData.fromJson(Map<String, dynamic> json) => ChapterData(
    classCode: json["ClassCode"],
    className: json["ClassName"],
    subjectCode: json["SubjectCode"],
    subjectName: json["SubjectName"],
    bookCode: json["BookCode"],
    nameOfBook: json["NameOfBook"],
    chapterId: json["ChapterID"]==null?0:json["ChapterID"],
    chapterName: json["ChapterName"],
    topic: json["Topic"]==null?'':json["Topic"],
    noOfPeriod: json["NoOfPeriod"]==null?0:json["NoOfPeriod"],
    status: json["Status"]==null?0:json["Status"],
    total_TransID: json["Total_TransID"]==null?0:json["Total_TransID"],
  );

  Map<String, dynamic> toJson() => {
    "ClassCode": classCode,
    "ClassName": className,
    "SubjectCode": subjectCode,
    "SubjectName": subjectName,
    "BookCode": bookCode,
    "NameOfBook": nameOfBook,
    "ChapterID": chapterId,
    "ChapterName": chapterName,
    "Topic": topic,
    "NoOfPeriod": noOfPeriod,
    "Status": status,
    "Total_TransID": total_TransID,
  };
}
