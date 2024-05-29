class RowingQualityOperatorOperationModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityOperatorOperationListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  RowingQualityOperatorOperationModel({
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

  factory RowingQualityOperatorOperationModel.fromJson(Map<String, dynamic> json) => RowingQualityOperatorOperationModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RowingQualityOperatorOperationListModel>.from(json["List"].map((x) => RowingQualityOperatorOperationListModel.fromJson(x))),
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

class RowingQualityOperatorOperationListModel {
  String workerName;
  String machineId;
  String operationDescription;
  String operationId;
  int orderId;
  String orderDescription;
  int workerId;

  RowingQualityOperatorOperationListModel({
    required this.workerName,
    required this.machineId,
    required this.operationDescription,
    required this.operationId,
    required this.orderId,
    required this.orderDescription,
    required this.workerId,
  });

  factory RowingQualityOperatorOperationListModel.fromJson(Map<String, dynamic> json) => RowingQualityOperatorOperationListModel(
    workerName: json["WorkerName"],
    machineId: json["MachineID"],
    operationDescription: json["OperationDescription"],
    operationId: json["OperationID"],
    orderId: json["orderId"],
    orderDescription: json["OrderDescription"],
    workerId: json["workerId"],
  );

  Map<String, dynamic> toJson() => {
    "WorkerName": workerName,
    "MachineID": machineId,
    "OperationDescription": operationDescription,
    "OperationID": operationId,
    "orderId": orderId,
    "OrderDescription": orderDescription,
    "workerId": workerId,
  };
}
