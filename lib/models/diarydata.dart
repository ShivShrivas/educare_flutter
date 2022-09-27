// To parse this JSON data, do
//
//     final noticeData = noticeDataFromJson(jsonString);

import 'dart:convert';

class DiaryData {

  DiaryData(
      { required this.transID,
        required this.condition,
        required this.className,
        required this.sectionCode,
        required this.studentCode,
        required this.wantToRevertMessage,
        required this.messageTitle,
        required this.message,
        required this.attachmentPath,
        required this.attachmentType,
        required this.date,
        required this.time
      });

  String transID;
  String condition;
  String className;
  String sectionCode;
  String studentCode;
  String wantToRevertMessage;
  String messageTitle;
  String message;
  String attachmentPath;
  String attachmentType;
  String date;
  String time;

  factory DiaryData.fromJson(Map<String, dynamic> json)=> DiaryData(
      transID : json['TransID'],
      condition : json['Condition'],
      className : json['ClassName'],
      sectionCode : json['SectionCode'],
      studentCode : json['StudentCode'],
      wantToRevertMessage : json['WantToRevertMessage'],
      messageTitle : json['MessageTitle'],
      message : json['Message'],
      attachmentPath : json['AttachmentPath'],
      attachmentType : json['AttachmentType'],
      date : json['Date'],
      time : json['Time'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TransID'] = this.transID;
    data['Condition'] = this.condition;
    data['ClassName'] = this.className;
    data['SectionCode'] = this.sectionCode;
    data['StudentCode'] = this.studentCode;
    data['WantToRevertMessage'] = this.wantToRevertMessage;
    data['MessageTitle'] = this.messageTitle;
    data['Message'] = this.message;
    data['AttachmentPath'] = this.attachmentPath;
    data['AttachmentType'] = this.attachmentType;
    data['Date'] = this.date;
    data['Time'] = this.time;
    return data;
  }
}
