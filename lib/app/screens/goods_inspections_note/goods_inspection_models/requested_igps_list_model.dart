class RequestedIGPSModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RequestedIGPSListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  RequestedIGPSModel({
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

  factory RequestedIGPSModel.fromJson(Map<String, dynamic> json) => RequestedIGPSModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RequestedIGPSListModel>.from(json["List"].map((x) => RequestedIGPSListModel.fromJson(x))),
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

class RequestedIGPSListModel {
  String igpDate;
  int igpNo;
  String vendor;
  String requestedDept;
  String itemName;
  int lineItem;
  int pendingQty;
  DateTime igpDateFilter;

  RequestedIGPSListModel({
    required this.igpDate,
    required this.igpNo,
    required this.vendor,
    required this.requestedDept,
    required this.itemName,
    required this.lineItem,
    required this.pendingQty,
    required this.igpDateFilter,
  });

  factory RequestedIGPSListModel.fromJson(Map<String, dynamic> json) => RequestedIGPSListModel(
    igpDate: json["IGPDate"],
    igpNo: json["IGPNo"],
    vendor: json["Vendor"],
    requestedDept: json["RequestedDept"],
    itemName: json["ItemName"],
    lineItem: json["LineItem"],
    pendingQty: json["PendingQty"],
    igpDateFilter: DateTime.parse(json["IGPDateFilter"]),
  );

  Map<String, dynamic> toJson() => {
    "IGPDate": igpDate,
    "IGPNo": igpNo,
    "Vendor": vendor,
    "RequestedDept": requestedDept,
    "ItemName": itemName,
    "LineItem": lineItem,
    "PendingQty": pendingQty,
    "IGPDateFilter": igpDateFilter.toIso8601String(),
  };
}
