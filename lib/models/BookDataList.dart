
class BookList{
  String  bookCode;
  String bookName;
  bool isActive;

  BookList({required this.bookCode, required this.bookName, required this.isActive});

  factory BookList.fromJson(Map<String, dynamic> json) => BookList(
    bookCode: json["BookCode"],
    bookName: json["BookName"],
    isActive: json["IsActive"]
  );

  Map<String, dynamic> toJson() => {
    "BookCode": bookCode,
    "BookName": bookName,
    "IsActive": isActive
  };
}