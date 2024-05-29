class InLineInspectorMonthlyFlagDetailReportModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<InLineInspectorMonthlyFlagDetailReportListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  InLineInspectorMonthlyFlagDetailReportModel({
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

  factory InLineInspectorMonthlyFlagDetailReportModel.fromJson(Map<String, dynamic> json) => InLineInspectorMonthlyFlagDetailReportModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<InLineInspectorMonthlyFlagDetailReportListModel>.from(json["List"].map((x) => InLineInspectorMonthlyFlagDetailReportListModel.fromJson(x))),
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

class InLineInspectorMonthlyFlagDetailReportListModel {
  DateTime transactionDate;
  String woDetails;
  int lineNo;
  int empOperatorCode;
  String employeeName;
  String operationname;
  int roundNo;
  String flag;
  String remarks;
  DateTime flagDate;

  InLineInspectorMonthlyFlagDetailReportListModel({
    required this.transactionDate,
    required this.woDetails,
    required this.lineNo,
    required this.empOperatorCode,
    required this.employeeName,
    required this.operationname,
    required this.roundNo,
    required this.flag,
    required this.remarks,
    required this.flagDate,
  });

  factory InLineInspectorMonthlyFlagDetailReportListModel.fromJson(Map<String, dynamic> json) => InLineInspectorMonthlyFlagDetailReportListModel(
    transactionDate: DateTime.parse(json["Transaction_Date"]),
    woDetails: json["wo_details"],
    lineNo: json["Line_No"],
    empOperatorCode: json["EMP_Operator_Code"],
    employeeName: json["EmployeeName"],
    operationname: json["operationname"],
    roundNo: json["Round_No"],
    flag: json["Flag"],
    remarks: json["Remarks"],
    flagDate: DateTime.parse(json["FlagDate"]),
  );

  Map<String, dynamic> toJson() => {
    "Transaction_Date": transactionDate.toIso8601String(),
    "wo_details": woDetails,
    "Line_No": lineNo,
    "EMP_Operator_Code": empOperatorCode,
    "EmployeeName": employeeName,
    "operationname": operationname,
    "Round_No": roundNo,
    "Flag": flag,
    "Remarks": remarks,
    "FlagDate": flagDate.toIso8601String(),
  };
}