class RowingQualityOperationModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityOperationListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityOperationModel({
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
    required this.returnData,
  });

  factory RowingQualityOperationModel.fromJson(Map<String, dynamic> json) => RowingQualityOperationModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RowingQualityOperationListModel>.from(json["List"].map((x) => RowingQualityOperationListModel.fromJson(x))),
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
    "List": List<dynamic>.from(list.map((x) => x.toJson())),
    "IList": iList,
    "IEList": ieList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
    "ReturnData": returnData,
  };
}

class RowingQualityOperationListModel {
  String operationname;
  int operationcode;
  RowingQualityOperationListModel({
    required this.operationcode,
    required this.operationname,
  });

  factory RowingQualityOperationListModel.fromJson(Map<String, dynamic> json) => RowingQualityOperationListModel(
    operationname: json["operationname"],
    operationcode: json["operationcode"],
  );

  Map<String, dynamic> toJson() => {
    "operationcode": operationcode,
    "operationname": operationname,
  };
}
