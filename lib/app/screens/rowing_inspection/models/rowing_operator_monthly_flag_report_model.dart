class InLineInspectorMonthlyFlagReportModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<InLineInspectorMonthlyFlagReportListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  InLineInspectorMonthlyFlagReportModel({
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

  factory InLineInspectorMonthlyFlagReportModel.fromJson(Map<String, dynamic> json) => InLineInspectorMonthlyFlagReportModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<InLineInspectorMonthlyFlagReportListModel>.from(json["List"].map((x) => InLineInspectorMonthlyFlagReportListModel.fromJson(x))),
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

class InLineInspectorMonthlyFlagReportListModel {
  DateTime transactionDate;
  String woDetails;
  int lineNo;
  int empOperatorCode;
  String employeeName;
  String operationname;
  String remarks;
  String red;
  String yellow;
  int redNoflg;
  int yellowNoflg;

  InLineInspectorMonthlyFlagReportListModel({
    required this.transactionDate,
    required this.woDetails,
    required this.lineNo,
    required this.empOperatorCode,
    required this.employeeName,
    required this.operationname,
    required this.remarks,
    required this.red,
    required this.yellow,
    required this.redNoflg,
    required this.yellowNoflg,
  });

  factory InLineInspectorMonthlyFlagReportListModel.fromJson(Map<String, dynamic> json) => InLineInspectorMonthlyFlagReportListModel(
    transactionDate: DateTime.parse(json["Transaction_Date"]),
    woDetails: json["wo_details"],
    lineNo: json["Line_No"],
    empOperatorCode: json["EMP_Operator_Code"],
    employeeName: json["EmployeeName"],
    operationname: json["operationname"],
    remarks: json["Remarks"],
    red: json["RED"],
    yellow: json["YELLOW"],
    redNoflg: json["RED_NOFLG"],
    yellowNoflg: json["YELLOW_NOFLG"],
  );

  Map<String, dynamic> toJson() => {
    "Transaction_Date": transactionDate.toIso8601String(),
    "wo_details": woDetails,
    "Line_No": lineNo,
    "EMP_Operator_Code": empOperatorCode,
    "EmployeeName": employeeName,
    "operationname": operationname,
    "Remarks": remarks,
    "RED": red,
    "YELLOW": yellow,
    "RED_NOFLG": redNoflg,
    "YELLOW_NOFLG": yellowNoflg,
  };
}

