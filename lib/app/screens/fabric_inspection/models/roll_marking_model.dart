class RollMarkingModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RollMarkingStatusList> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  RollMarkingModel({
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

  factory RollMarkingModel.fromJson(Map<String, dynamic> json) => RollMarkingModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RollMarkingStatusList>.from(json["List"].map((x) => RollMarkingStatusList.fromJson(x))),
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

class RollMarkingStatusList {
  int value;
  String display;

  RollMarkingStatusList({
    required this.value,
    required this.display,
  });

  factory RollMarkingStatusList.fromJson(Map<String, dynamic> json) => RollMarkingStatusList(
    value: json["Value"],
    display: json["Display"],
  );

  Map<String, dynamic> toJson() => {
    "Value": value,
    "Display": display,
  };
}
