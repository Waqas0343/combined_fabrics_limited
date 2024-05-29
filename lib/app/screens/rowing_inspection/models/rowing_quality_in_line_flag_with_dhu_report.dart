class RowingQualityInLineFlagWithDHUModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityInLineFlagWithDHUListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityInLineFlagWithDHUModel({
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

  factory RowingQualityInLineFlagWithDHUModel.fromJson(Map<String, dynamic> json) => RowingQualityInLineFlagWithDHUModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RowingQualityInLineFlagWithDHUListModel>.from(json["List"].map((x) => RowingQualityInLineFlagWithDHUListModel.fromJson(x))),
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

class RowingQualityInLineFlagWithDHUListModel {
  String woOrders;
  String transactionDate;
  int lineNo;
  int roundNo;
  int inspGarmentNo;
  int faultpcs;
  double dhu;
  int empOperatorCode;
  int operationCode;
  String operationname;
  String machineCode;
  String cFaults;
  String flag;
  String inspectername;
  String reasons;

  RowingQualityInLineFlagWithDHUListModel({
    required this.woOrders,
    required this.transactionDate,
    required this.lineNo,
    required this.roundNo,
    required this.inspGarmentNo,
    required this.faultpcs,
    required this.dhu,
    required this.empOperatorCode,
    required this.operationCode,
    required this.operationname,
    required this.machineCode,
    required this.cFaults,
    required this.flag,
    required this.inspectername,
    required this.reasons,
  });

  factory RowingQualityInLineFlagWithDHUListModel.fromJson(Map<String, dynamic> json) => RowingQualityInLineFlagWithDHUListModel(
    woOrders: json["Wo_orders"],
    transactionDate: json["Transaction_Date"],
    lineNo: json["Line_No"],
    roundNo: json["Round_No"],
    inspGarmentNo: json["Insp_Garment_No"],
    faultpcs: json["Faultpcs"],
    dhu: json["DHU"]?.toDouble(),
    empOperatorCode: json["EMP_Operator_Code"],
    operationCode: json["Operation_Code"],
    operationname: json["operationname"],
    machineCode: json["Machine_Code"],
    cFaults: json["CFaults"],
    flag: json["Flag"],
    inspectername: json["Inspectername"],
    reasons: json["Reasons"],
  );

  Map<String, dynamic> toJson() => {
    "Wo_orders": woOrders,
    "Transaction_Date": transactionDate,
    "Line_No": lineNo,
    "Round_No": roundNo,
    "Insp_Garment_No": inspGarmentNo,
    "Faultpcs": faultpcs,
    "DHU": dhu,
    "EMP_Operator_Code": empOperatorCode,
    "Operation_Code": operationCode,
    "operationname": operationname,
    "Machine_Code": machineCode,
    "CFaults":cFaults,
    "Flag": flag,
    "Inspectername": inspectername,
    "Reasons": reasons,
  };
}
