class InspectionTable {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<InspectionTableList> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  InspectionTable({
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

  factory InspectionTable.fromJson(Map<String, dynamic> json) =>
      InspectionTable(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<InspectionTableList>.from(
            json["List"].map((x) => InspectionTableList.fromJson(x))),
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

class InspectionTableList {
  int value;
  String display;

  InspectionTableList({
    required this.value,
    required this.display,
  });

  factory InspectionTableList.fromJson(Map<String, dynamic> json) =>
      InspectionTableList(
        value: json["Value"],
        display: json["Display"],
      );

  Map<String, dynamic> toJson() => {
        "Value": value,
        "Display": display,
      };
}
