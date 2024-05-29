class PendingIGPNoModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<ReceivedIGPListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  PendingIGPNoModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.errors,
    required this.expiredate,
    required this.data,
    required this.list,
    required this.iList,
    required this.ieList,
    required this.totalRecords,
    required this.totalPagesCount,
  });

  factory PendingIGPNoModel.fromJson(Map<String, dynamic> json) => PendingIGPNoModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<ReceivedIGPListModel>.from(json["List"].map((x) => ReceivedIGPListModel.fromJson(x))),
    iList: json["IList"],
    ieList: json["IEList"],
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
    "IEList": ieList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
  };
}

class ReceivedIGPListModel {
  String igpDate;
  int igpNo;
  String vendor;
  int lineItem;
  DateTime igpDateFilter;

  ReceivedIGPListModel({
    required this.igpDate,
    required this.igpNo,
    required this.vendor,
    required this.lineItem,
    required this.igpDateFilter,
  });

  factory ReceivedIGPListModel.fromJson(Map<String, dynamic> json) => ReceivedIGPListModel(
    igpDate: json["IGPDate"],
    igpNo: json["IGPNo"],
    vendor: json["Vendor"],
    lineItem: json["LineItem"],
    igpDateFilter: DateTime.parse(json["IGPDateFilter"]),
  );

  Map<String, dynamic> toJson() => {
    "IGPDate": igpDate,
    "IGPNo": igpNo,
    "Vendor": vendor,
    "LineItem": lineItem,
    "IGPDateFilter": igpDateFilter.toIso8601String(),
  };
}

