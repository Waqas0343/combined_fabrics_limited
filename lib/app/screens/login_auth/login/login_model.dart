class LoginModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  DateTime expiredate;
  String data;
  dynamic list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  LoginModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    required this.expiredate,
    required this.data,
    this.list,
    this.iList,
    this.totalRecords,
    this.totalPagesCount,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: DateTime.parse(json["Expiredate"]),
    data: json["Data"],
    list: json["List"],
    iList: json["IList"],
    totalRecords: json["TotalRecords"],
    totalPagesCount: json["TotalPagesCount"],
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
    "StatusCode": statusCode,
    "Errors": errors,
    "Expiredate": expiredate.toIso8601String(),
    "Data": data,
    "List": list,
    "IList": iList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
  };
}
