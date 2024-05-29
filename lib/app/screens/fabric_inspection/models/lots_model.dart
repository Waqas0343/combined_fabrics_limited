class LotsModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<LotsListModel> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  LotsModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    this.expiredate,
    this.data,
    required this.list,
    this.iList,
    this.totalRecords,
    this.totalPagesCount,
  });

  factory LotsModel.fromJson(Map<String, dynamic> json) => LotsModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<LotsListModel>.from(
            json["List"].map((x) => LotsListModel.fromJson(x))),
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
        "List": List<dynamic>.from(list.map((x) => x.toJson())),
        "IList": iList,
        "TotalRecords": totalRecords,
        "TotalPagesCount": totalPagesCount,
      };
}

class LotsListModel {
  String lotNo;

  LotsListModel({
    required this.lotNo,
  });

  factory LotsListModel.fromJson(Map<String, dynamic> json) => LotsListModel(
        lotNo: json["LotNo"],
      );

  Map<String, dynamic> toJson() => {
        "LotNo": lotNo,
      };
}
