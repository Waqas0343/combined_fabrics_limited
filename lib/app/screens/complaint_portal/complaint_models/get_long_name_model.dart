
class LongNameModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<LongNameModelList> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  LongNameModel({
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

  factory LongNameModel.fromJson(Map<String, dynamic> json) => LongNameModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<LongNameModelList>.from(json["List"].map((x) => LongNameModelList.fromJson(x))),
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

class LongNameModelList {
  String assetCode;
  String longName;

  LongNameModelList({
    required this.assetCode,
    required this.longName,
  });

  factory LongNameModelList.fromJson(Map<String, dynamic> json) => LongNameModelList(
    assetCode: json["AssetCode"],
    longName: json["LongName"],
  );

  Map<String, dynamic> toJson() => {
    "AssetCode": assetCode,
    "LongName": longName,
  };
}
