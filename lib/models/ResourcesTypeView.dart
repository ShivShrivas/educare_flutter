
class ResourcesTypeViewList{
  String Code;
  String ResourceCategoryCode;
  String FilePath;
  String FileName;
  String ResourceCategoryName;


  ResourcesTypeViewList(
  {
      required this.Code,
      required this.ResourceCategoryCode,
      required this.FilePath,
      required this.FileName,
      required this.ResourceCategoryName,
  });

  factory ResourcesTypeViewList.fromJson(Map<String, dynamic> json) => ResourcesTypeViewList(
      Code: json["Code"],
      ResourceCategoryCode: json["ResourceCategoryCode"],
      FilePath: json["FilePath"]  ,
      FileName: json["FileName"],
      ResourceCategoryName: json["ResourceCategoryName"]
  );

  Map<String, dynamic> toJson() => {
    "Code": Code,
    "ResourceCategoryCode": ResourceCategoryCode,
    "FilePath": FilePath,
    "FileName": FileName,
    "ResourceCategoryName": ResourceCategoryName
  };
}