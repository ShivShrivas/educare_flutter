// To parse this JSON data, do
//
//     final classDataList = classDataListFromJson(jsonString);

class ClassDataList {
  ClassDataList({
    required this.className,
    required this.classCode,
  });

  String className;
  String classCode;

  factory ClassDataList.fromJson(Map<String, dynamic> json) => ClassDataList(
    className: json["ClassName"],
    classCode: json["Code"],
  );

  Map<String, dynamic> toJson() => {
    "ClassName": className,
    "Code": classCode,
  };
}
