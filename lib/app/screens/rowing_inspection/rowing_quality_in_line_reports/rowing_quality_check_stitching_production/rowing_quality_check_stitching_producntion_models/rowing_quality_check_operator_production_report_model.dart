class RowingQualityCheckOperatorProductionReportModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<RowingQualityCheckOperatorProductionReportListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityCheckOperatorProductionReportModel({
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

  factory RowingQualityCheckOperatorProductionReportModel.fromJson(Map<String, dynamic> json) => RowingQualityCheckOperatorProductionReportModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<RowingQualityCheckOperatorProductionReportListModel>.from(json["Lists"].map((x) => RowingQualityCheckOperatorProductionReportListModel.fromJson(x))),
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

class RowingQualityCheckOperatorProductionReportListModel {
  DateTime transactionDate;
  String woOrders;
  int lineNo;
  String operationname;
  String operationCode;
  String machineCode;
  String flagShortName;
  String listOperator;
  String flagReason;
  int empOperatorCode;
  int producepcs;
  int ageInMinutes;
  double stichfaultCount;
  double outherfaults;
  int? inspGarmentNo;
  double enlineDhu;

  RowingQualityCheckOperatorProductionReportListModel({
    required this.transactionDate,
    required this.woOrders,
    required this.lineNo,
    required this.operationname,
    required this.operationCode,
    required this.machineCode,
    required this.flagShortName,
    required this.listOperator,
    required this.flagReason,
    required this.empOperatorCode,
    required this.producepcs,
    required this.ageInMinutes,
    required this.stichfaultCount,
    required this.outherfaults,
    required this.inspGarmentNo,
    required this.enlineDhu,
  });

  factory RowingQualityCheckOperatorProductionReportListModel.fromJson(Map<String, dynamic> json) => RowingQualityCheckOperatorProductionReportListModel(
    transactionDate: DateTime.parse(json["Transaction_Date"]),
    woOrders: json["Wo_orders"],
    lineNo: json["Line_No"],
    operationname: json["operationname"],
    operationCode: json["Operation_Code"],
    machineCode: json["Machine_Code"],
    flagShortName: json["Flag_Short_Name"],
    listOperator: json["operator"],
    flagReason: json["FlagReason"],
    empOperatorCode: json["EMP_Operator_Code"],
    producepcs: json["producepcs"],
    ageInMinutes: json["age_in_minutes"],
    stichfaultCount: json["StichfaultCount"],
    outherfaults: json["outherfaults"],
    inspGarmentNo: json["Insp_Garment_No"],
    enlineDhu: json["EnlineDhu"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Transaction_Date": transactionDate.toIso8601String(),
    "Wo_orders": woOrders,
    "Line_No": lineNo,
    "operationname": operationname,
    "Operation_Code": operationCode,
    "Machine_Code": machineCode,
    "Flag_Short_Name": flagShortName,
    "operator": listOperator,
    "FlagReason": flagReason,
    "EMP_Operator_Code": empOperatorCode,
    "producepcs": producepcs,
    "age_in_minutes": ageInMinutes,
    "StichfaultCount": stichfaultCount,
    "outherfaults": outherfaults,
    "Insp_Garment_No": inspGarmentNo,
    "EnlineDhu": enlineDhu,
  };
}
