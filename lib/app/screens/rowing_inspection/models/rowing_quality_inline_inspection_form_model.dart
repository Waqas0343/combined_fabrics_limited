class RowingQualityInlineInspectionFormModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityInlineInspectionFormListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  RowingQualityInlineInspectionFormModel({
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

  factory RowingQualityInlineInspectionFormModel.fromJson(Map<String, dynamic> json) => RowingQualityInlineInspectionFormModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RowingQualityInlineInspectionFormListModel>.from(json["List"].map((x) => RowingQualityInlineInspectionFormListModel.fromJson(x))),
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

class RowingQualityInlineInspectionFormListModel {
  int orderId;
  String workerId;
  String orderDescription;
  String machineId;

  RowingQualityInlineInspectionFormListModel({
    required this.orderId,
    required this.workerId,
    required this.orderDescription,
    required this.machineId,
  });

  factory RowingQualityInlineInspectionFormListModel.fromJson(Map<String, dynamic> json) => RowingQualityInlineInspectionFormListModel(
    orderId: json["OrderId"],
    workerId: json["WorkerId"],
    orderDescription: json["OrderDescription"],
    machineId: json["machineID"],
  );

  Map<String, dynamic> toJson() => {
    "OrderId": orderId,
    "WorkerId": workerId,
    "OrderDescription": orderDescription,
    "machineID": machineId,
  };

}
