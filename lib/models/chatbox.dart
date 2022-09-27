// To parse this JSON data, do
//
//     final chatBox = chatBoxFromJson(jsonString);

import 'dart:convert';

List<ChatBox> chatBoxFromJson(String str) => List<ChatBox>.from(json.decode(str).map((x) => ChatBox.fromJson(x)));

String chatBoxToJson(List<ChatBox> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatBox {
  ChatBox({
    required this.complainTransId,
    required this.receiverId,
    required this.senderId,
    required this.message,
    required this.date,
    required this.time,
  });

  String complainTransId;
  int receiverId;
  int senderId;
  String message;
  String date;
  String time;

  factory ChatBox.fromJson(Map<String, dynamic> json) => ChatBox(
    complainTransId: json["ComplainTransId"],
    receiverId: json["ReceiverID"],
    senderId: json["SenderID"],
    message: json["Message"],
    date: json["Date"],
    time: json["Time"],
  );

  Map<String, dynamic> toJson() => {
    "ComplainTransId": complainTransId,
    "ReceiverID": receiverId,
    "SenderID": senderId,
    "Message": message,
    "Date": date,
    "Time": time,
  };
}
