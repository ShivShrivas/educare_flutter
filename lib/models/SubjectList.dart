
class SubjectDataList{
  String subjectCode;
  String subjectName;
  bool isActive;
  bool chk;


  SubjectDataList({required this.subjectCode, required this.subjectName, required this.isActive, required this.chk});

  factory SubjectDataList.fromJson(Map<String, dynamic> json) => SubjectDataList(
      subjectCode: json["SubjectCode"],
      subjectName: json["SubjectName"],
      isActive: json["IsActive"],
      chk: json["chk"]

  );
  Map<String, dynamic> toJson() => {
    "SubjectCode" : subjectCode,
    "SubjectName": subjectName,
    "IsActive" :isActive,
    "chk" :chk
  };
}