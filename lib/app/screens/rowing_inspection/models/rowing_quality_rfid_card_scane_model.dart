class CardScanModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<CardScanListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  CardScanModel({
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

  factory CardScanModel.fromJson(Map<String, dynamic> json) => CardScanModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<CardScanListModel>.from(json["Lists"].map((x) => CardScanListModel.fromJson(x))),
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

class CardScanListModel {
  String bundleId;
  int quantity;
  String operationDescription;
  String orderDescription;
  String machineId;
  String opertor;
  String lineId;

  CardScanListModel({
    required this.bundleId,
    required this.quantity,
    required this.operationDescription,
    required this.orderDescription,
    required this.machineId,
    required this.opertor,
    required this.lineId,
  });

  factory CardScanListModel.fromJson(Map<String, dynamic> json) => CardScanListModel(
    bundleId: json["bundleID"],
    quantity: json["quantity"],
    operationDescription: json["operationDescription"],
    orderDescription: json["orderDescription"],
    machineId: json["machineID"],
    opertor: json["Opertor"],
    lineId: json["lineID"],
  );

  Map<String, dynamic> toJson() => {
    "bundleID": bundleId,
    "quantity": quantity,
    "operationDescription": operationDescription,
    "orderDescription": orderDescription,
    "machineID": machineId,
    "Opertor": opertor,
    "lineID": lineId,
  };
}
