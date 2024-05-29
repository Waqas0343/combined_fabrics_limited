class ComplaintChartModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<ComplaintChartListModel> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  ComplaintChartModel({
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

  factory ComplaintChartModel.fromJson(Map<String, dynamic> json) => ComplaintChartModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<ComplaintChartListModel>.from(json["List"].map((x) => ComplaintChartListModel.fromJson(x))),
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

class ComplaintChartListModel {
  String status;
  int count;

  ComplaintChartListModel({
    required this.status,
    required this.count,
  });

  factory ComplaintChartListModel.fromJson(Map<String, dynamic> json) => ComplaintChartListModel(
    status: json["Status"],
    count: json["Count"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Count": count,
  };
}
