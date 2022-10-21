
class LessonPlanList{
  String Code;
  int PeriodCode;
  String ChapterName;
  int TypeCode;
  String ClassCode;
  String SubjectCode;
  String BookCode;
  String ChapterCode;
  String Attachment;

  LessonPlanList(
      {
        required this.Code,
        required this.PeriodCode,
        required this.ChapterName,
        required this.TypeCode,
        required this.ClassCode,
        required this.SubjectCode,
        required this.BookCode,
        required this.ChapterCode,
        required this.Attachment
      });

  factory LessonPlanList.fromJson(Map<String, dynamic> json) => LessonPlanList(
      Code: json["Code"]??"0",
      PeriodCode: json["PeriodCode"]??"0",
      ChapterName: json["ChapterName"] ??"0" ,
      TypeCode: json["TypeCode"]??"0",
      ClassCode: json["ClassCode"]??"0",
      SubjectCode: json["SubjectCode"]??"0",
      BookCode: json["BookCode"]??"0",
      ChapterCode: json["ChapterCode"]??"0",
      Attachment: json["Attachment"]??"0"
  );

  Map<String, dynamic> toJson() => {
    "Code": Code,
    "PeriodCode": PeriodCode,
    "ChapterName": ChapterName,
    "TypeCode": TypeCode,
    "ClassCode": ClassCode,
    "SubjectCode": SubjectCode,
    "BookCode": BookCode,
    "ChapterCode": ChapterCode,
    "Attachment": Attachment,
  };
}