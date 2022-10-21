
class ChapterListBookWise{
  String Code;
  String ChapterName;
  bool IsActive;

  ChapterListBookWise({required this.Code, required this.ChapterName, required this.IsActive});



  factory ChapterListBookWise.fromJson(Map<String, dynamic> json) => ChapterListBookWise(
      Code: json["Code"],
      ChapterName: json["ChapterName"],
      IsActive: json["IsActive"]
  );

  Map<String, dynamic> toJson() => {
    "Code": Code,
    "ChapterName": ChapterName,
    "IsActive": IsActive
  };
}