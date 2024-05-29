class NotificationModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<NotificationListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  NotificationModel({
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

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<NotificationListModel>.from(json["List"].map((x) => NotificationListModel.fromJson(x))),
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

class NotificationListModel {
  int igpNo;
  int igpSrNo;
  int igpQty;
  String itemName;
  String itemDetail;
  String deptName;
  String itemCode;
  String requestedBy;
  String requestDateTime;
  DateTime filterByDate;
  int deptRequest;

  NotificationListModel({
    required this.igpNo,
    required this.igpSrNo,
    required this.igpQty,
    required this.itemName,
    required this.itemCode,
    required this.deptName,
    required this.itemDetail,
    required this.requestedBy,
    required this.requestDateTime,
    required this.filterByDate,
    required this.deptRequest,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
    igpNo: json["IGPNo"],
    igpSrNo: json["IGPSrNo"],
    igpQty: json["IGPQty"],
    itemName: json["ItemName"],
    itemCode: json["ItemCode"],
    deptName: json["DeptName"],
    itemDetail: json["ItemDetail"],
    requestedBy: json["RequestedBy"],
    requestDateTime: json["RequestDateTime"],
    filterByDate: DateTime.parse(json["FilterByDate"]),
    deptRequest: json["DeptRequest"],
  );

  Map<String, dynamic> toJson() => {
    "IGPNo": igpNo,
    "IGPSrNo": igpSrNo,
    "IGPQty": igpQty,
    "ItemName": itemName,
    "ItemCode": itemCode,
    "ItemDetail": itemDetail,
    "DeptName": deptName,
    "RequestedBy": requestedBy,
    "RequestDateTime": requestDateTime,
    "FilterByDate": filterByDate.toIso8601String(),
    "DeptRequest": deptRequest,
  };
}
