class ChangeFlagReasonModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<ChangeFlagReasonListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  ChangeFlagReasonModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.errors,
    required this.expiredate,
    required this.data,
    required this.list,
    required this.lists,
    required this.iList,
    required this.ieList,
    required this.totalRecords,
    required this.totalPagesCount,
    required this.returnData,
  });

  factory ChangeFlagReasonModel.fromJson(Map<String, dynamic> json) => ChangeFlagReasonModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<ChangeFlagReasonListModel>.from(json["Lists"].map((x) => ChangeFlagReasonListModel.fromJson(x))),
    iList: json["IList"],
    ieList: json["IEList"],
    totalRecords: json["TotalRecords"],
    totalPagesCount: json["TotalPagesCount"],
    returnData: json["ReturnData"],
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
    "StatusCode": statusCode,
    "Errors": errors,
    "Expiredate": expiredate,
    "Data": data,
    "List": list,
    "Lists": List<dynamic>.from(lists.map((x) => x.toJson())),
    "IList": iList,
    "IEList": ieList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
    "ReturnData": returnData,
  };
}

class ChangeFlagReasonListModel {
  String reasons;

  ChangeFlagReasonListModel({
    required this.reasons,
  });

  factory ChangeFlagReasonListModel.fromJson(Map<String, dynamic> json) => ChangeFlagReasonListModel(
    reasons: json["Reasons"],
  );

  Map<String, dynamic> toJson() => {
    "Reasons": reasons,
  };
}
