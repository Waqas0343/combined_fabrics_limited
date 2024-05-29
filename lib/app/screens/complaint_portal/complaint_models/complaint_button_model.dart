class ComplaintButtonModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  ComplaintButtonData data;
  dynamic list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  ComplaintButtonModel({
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

  factory ComplaintButtonModel.fromJson(Map<String, dynamic> json) =>
      ComplaintButtonModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: ComplaintButtonData.fromJson(json["Data"]),
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
        "Data": data.toJson(),
        "List": list,
        "IList": iList,
        "TotalRecords": totalRecords,
        "TotalPagesCount": totalPagesCount,
      };
}

class ComplaintButtonData {
  bool? verified;
  bool? resovled;
  bool? closed;
  bool? rejected;

  ComplaintButtonData({
    this.verified,
    this.resovled,
    this.closed,
    this.rejected,
  });

  factory ComplaintButtonData.fromJson(Map<String, dynamic> json) => ComplaintButtonData(
    verified: json["Data"]["Verified"],
    resovled: json["Data"]["Resovled"],
    closed: json["Data"]["Closed"],
    rejected: json["Data"]["Rejected"],
  );

  Map<String, dynamic> toJson() => {
    "Verified": verified,
    "Resovled": resovled,
    "Closed": closed,
    "Rejected": rejected,
  };
}

