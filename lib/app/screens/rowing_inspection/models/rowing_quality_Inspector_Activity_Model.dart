class InspectorActivityModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<InspectorActivityListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  InspectorActivityModel({
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

  factory InspectorActivityModel.fromJson(Map<String, dynamic> json) => InspectorActivityModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<InspectorActivityListModel>.from(json["List"].map((x) => InspectorActivityListModel.fromJson(x))),
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

class InspectorActivityListModel {
  String woOrders;
  DateTime transactionDate;
  int lineNo;
  int roundNo;
  String inspGarmentNo;
  int empOperatorCode;
  int operationCode;
  String operationname;
  String machineCode;
  String cFaults;
  String flag;
  String inspectername;
  int opsequence;

  InspectorActivityListModel({
    required this.woOrders,
    required this.transactionDate,
    required this.lineNo,
    required this.roundNo,
    required this.inspGarmentNo,
    required this.empOperatorCode,
    required this.operationCode,
    required this.operationname,
    required this.machineCode,
    required this.cFaults,
    required this.flag,
    required this.inspectername,
    required this.opsequence,
  });

  factory InspectorActivityListModel.fromJson(Map<String, dynamic> json) => InspectorActivityListModel(
    woOrders: json["Wo_orders"],
    transactionDate: DateTime.parse(json["Transaction_Date"]),
    lineNo: json["Line_No"],
    roundNo: json["Round_No"],
    inspGarmentNo: json["Insp_Garment_No"],
    empOperatorCode: json["EMP_Operator_Code"],
    operationCode: json["Operation_Code"],
    operationname: json["operationname"],
    machineCode: json["Machine_Code"],
    cFaults: json["CFaults"],
    flag: json["Flag"],
    inspectername: json["Inspectername"],
    opsequence: json["opsequence"],
  );

  Map<String, dynamic> toJson() => {
    "Wo_orders": woOrders,
    "Transaction_Date": transactionDate.toIso8601String(),
    "Line_No": lineNo,
    "Round_No": roundNo,
    "Insp_Garment_No": inspGarmentNo,
    "EMP_Operator_Code": empOperatorCode,
    "Operation_Code": operationCode,
    "operationname": operationname,
    "Machine_Code": machineCode,
    "CFaults": cFaults,
    "Flag": flag,
    "Inspectername": inspectername,
    "opsequence": opsequence,
  };
}
