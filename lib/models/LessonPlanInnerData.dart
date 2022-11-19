class LessonPlanInnerDataList {
  String Code;
  int PeriodCode;
  int SrNo;
  String LessonPlanCode;
  String TextContent;
  String ChapterName;
  String CategoryName;
  String CreatedOn;
  int TypeCode;
  String LessonPlanComponentPdf;

  LessonPlanInnerDataList(
      {
      required this.Code,
      required this.PeriodCode,
      required this.SrNo,
      required this.LessonPlanCode,
      required this.TextContent,
      required this.ChapterName,
      required this.CategoryName,
      required this.CreatedOn,
      required this.TypeCode,
      required this.LessonPlanComponentPdf});

  factory LessonPlanInnerDataList.fromJson(Map<String, dynamic> json) => LessonPlanInnerDataList(
      Code: json["Code"],
      PeriodCode: json["PeriodCode"],
      SrNo: json["SrNo"],
      LessonPlanCode: json["LessonPlanCode"],
      TextContent: json["TextContent"],
      ChapterName: json["ChapterName"] ,
      CategoryName: json["CategoryName"],
      CreatedOn: json["CreatedOn"],
      TypeCode: json["TypeCode"],
      LessonPlanComponentPdf: json["LessonPlanComponentPdf"]

  );
  Map<String, dynamic> toJson() => {
    "Code" : Code,
    "PeriodCode": PeriodCode,
    "SrNo" :SrNo ,
    "LessonPlanCode" : LessonPlanCode,
    "TextContent": TextContent,
    "ChapterName" :ChapterName   ,
    "CategoryName" : CategoryName,
    "CreatedOn": CreatedOn,
    "TypeCode" :TypeCode,
    "LessonPlanComponentPdf" :LessonPlanComponentPdf,
  };



}
