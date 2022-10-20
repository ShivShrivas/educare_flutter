
class AcademicSessionDataList {

  AcademicSessionDataList({
  required this.sessionId, required this.sessionName, required this.isActive
});

  int sessionId;
  String sessionName;
  bool isActive;

  factory AcademicSessionDataList.fromJson(Map<String, dynamic> json) => AcademicSessionDataList(
      sessionName: json["SessionName"],
      isActive: json["IsActive"],
      sessionId: json["SessionId"]

  );
  Map<String, dynamic> toJson() => {
    "SessionId" : sessionId,
    "SessionName": sessionName,
    "IsActive" :isActive
  };


}
