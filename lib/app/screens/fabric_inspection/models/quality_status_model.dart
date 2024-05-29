class QualityModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<QualityListModel> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  QualityModel({
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

  factory QualityModel.fromJson(Map<String, dynamic> json) => QualityModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<QualityListModel>.from(
            json["List"].map((x) => QualityListModel.fromJson(x))),
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

class QualityListModel {
  int value;
  String display;

  QualityListModel({
    required this.value,
    required this.display,
  });

  factory QualityListModel.fromJson(Map<String, dynamic> json) =>
      QualityListModel(
        value: json["Value"],
        display: json["Display"],
      );

  Map<String, dynamic> toJson() => {
        "Value": value,
        "Display": display,
      };
}
