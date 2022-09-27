import 'dart:convert';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Client {
  int id;
  String school_code;
  String user_id;
  String user_code;
  String school_name;
  String user_name;
  String designation;
  String type;
  String relationship_id;
  String session_id;
  String fyId;
  String loginAs;
  String mobileNo;
  String isActive;

  Client({
    required this.id,
    required this.school_code,
    required this.user_id,
    required this.user_code,
    required this.school_name,
    required this.user_name,
    required this.designation,
    required this.type,
    required this.relationship_id,
    required this.session_id,
    required this.fyId,
    required this.loginAs,
    required this.mobileNo,
    required this.isActive,
  });

  factory Client.fromMap(Map<String, dynamic> json) => new Client(
    id: json["id"],
    school_code: json["school_code"],
    user_id: json["user_id"],
    user_code: json["user_code"],
    school_name: json["school_name"],
    user_name: json["user_name"],
    designation: json["designation"],
    type: json["type"]==""?"":json["type"],
    relationship_id: json["relationship_id"],
    session_id: json["session_id"],
    fyId: json["fyId"],
    loginAs: json["loginAs"],
    mobileNo: json["mobileNo"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "school_code": school_code,
    "last_name": user_id,
    "user_code": user_code,
    "school_name": school_name,
    "user_name": user_name,
    "designation": designation,
    "type": type,
    "relationship_id": relationship_id,
    "session_id": session_id,
    "fyId": fyId,
    "loginAs": loginAs,
    "mobileNo": mobileNo,
    "isActive": isActive,

  };
}