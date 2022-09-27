// To parse this JSON data, do
//
//     final timeTableData = timeTableDataFromJson(jsonString);

import 'dart:convert';

TimeTableData timeTableDataFromJson(String str) => TimeTableData.fromJson(json.decode(str));

String timeTableDataToJson(TimeTableData data) => json.encode(data.toJson());

class TimeTableData {
  TimeTableData({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  List<Day> monday;
  List<Day> tuesday;
  List<Day> wednesday;
  List<Day> thursday;
  List<Day> friday;
  List<Day> saturday;
  List<Day> sunday;

  factory TimeTableData.fromJson(Map<String, dynamic> json) => TimeTableData(
    monday: List<Day>.from(json["Monday"].map((x) => Day.fromJson(x))),
    tuesday: List<Day>.from(json["Tuesday"].map((x) => Day.fromJson(x))),
    wednesday: List<Day>.from(json["Wednesday"].map((x) => Day.fromJson(x))),
    thursday: List<Day>.from(json["Thursday"].map((x) => Day.fromJson(x))),
    friday: List<Day>.from(json["Friday"].map((x) => Day.fromJson(x))),
    saturday: List<Day>.from(json["Saturday"].map((x) => Day.fromJson(x))),
    sunday: List<Day>.from(json["Sunday"].map((x) => Day.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Monday": List<dynamic>.from(monday.map((x) => x.toJson())),
    "Tuesday": List<dynamic>.from(tuesday.map((x) => x.toJson())),
    "Wednesday": List<dynamic>.from(wednesday.map((x) => x.toJson())),
    "Thursday": List<dynamic>.from(thursday.map((x) => x.toJson())),
    "Friday": List<dynamic>.from(friday.map((x) => x.toJson())),
    "Saturday": List<dynamic>.from(saturday.map((x) => x.toJson())),
    "Sunday": List<dynamic>.from(sunday.map((x) => x.toJson())),
  };
}

class Day {
  Day({
    required this.employeeName,
    required this.subjectName,
    required this.periodName,
    required this.periodType,
    required this.fromTime,
    required this.toTime,
    required this.dayClass,
    required this.periodCount,
    required this.classCode,
    required this.subjectCode,
    required this.sectionCode,
  });

  String employeeName;
  String subjectName;
  String periodName;
  String periodType;
  String fromTime;
  String toTime;
  String dayClass;
  String subjectCode;
  String classCode;
  String sectionCode;
  int periodCount;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    employeeName: json["EmployeeName"],
    subjectName: json["SubjectName"],
    periodName: json["PeriodName"],
    periodType: json["PeriodType"],
    fromTime:json["FromTime"],
    toTime: json["ToTime"],
    dayClass: json["Class"],
    periodCount: json["PeriodCount"],
    classCode: json["ClassCode"],
    subjectCode: json["SubjectCode"],
    sectionCode: json["SectionCode"]==null?'':json["SectionCode"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeName": employeeName,
    "SubjectName": subjectName,
    "PeriodName": periodName,
    "PeriodType": periodType,
    "FromTime": fromTime,
    "ToTime": toTime,
    "Class":dayClass,
    "PeriodCount": periodCount,
    "ClassCode": classCode,
    "SubjectCode": subjectCode,
    "SectionCode": sectionCode,
  };
}

enum Class { EMPTY, THE_2_A }

final classValues = EnumValues({
  "": Class.EMPTY,
  "2 A": Class.THE_2_A
});

enum EmployeeName { EMPTY, MOHIT_KUMAR }

final employeeNameValues = EnumValues({
  "": EmployeeName.EMPTY,
  "Mohit KUMAR": EmployeeName.MOHIT_KUMAR
});

enum FromTime { THE_0800, THE_0900, THE_1100, THE_1200, THE_0100 }

final fromTimeValues = EnumValues({
  "01:00": FromTime.THE_0100,
  "08:00": FromTime.THE_0800,
  "09:00": FromTime.THE_0900,
  "11:00": FromTime.THE_1100,
  "12:00": FromTime.THE_1200
});

enum PeriodName { P1, P2, P3, P4, P5 }

final periodNameValues = EnumValues({
  "P1": PeriodName.P1,
  "P2": PeriodName.P2,
  "P3": PeriodName.P3,
  "P4": PeriodName.P4,
  "P5": PeriodName.P5
});

enum SubjectName { EMPTY, PHYSICS }

final subjectNameValues = EnumValues({
  "": SubjectName.EMPTY,
  "Physics": SubjectName.PHYSICS
});

enum ToTime { THE_0900, THE_1000, THE_1200, THE_0100, THE_0200 }

final toTimeValues = EnumValues({
  "01:00": ToTime.THE_0100,
  "02:00": ToTime.THE_0200,
  "09:00": ToTime.THE_0900,
  "10:00": ToTime.THE_1000,
  "12:00": ToTime.THE_1200
});

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

   EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
