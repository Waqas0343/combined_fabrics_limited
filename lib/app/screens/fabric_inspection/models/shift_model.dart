class FabricShiftModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  String data;
  dynamic list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  FabricShiftModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    this.expiredate,
    required this.data,
    this.list,
    this.iList,
    this.totalRecords,
    this.totalPagesCount,
  });

  factory FabricShiftModel.fromJson(Map<String, dynamic> json) =>
      FabricShiftModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
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
        "Expiredate": expiredate,
        "Data": data,
        "List": list,
        "IList": iList,
        "TotalRecords": totalRecords,
        "TotalPagesCount": totalPagesCount,
      };
}
