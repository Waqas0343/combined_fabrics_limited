class RowingQualityReportDetailModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityReportDetailListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityReportDetailModel({
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

  factory RowingQualityReportDetailModel.fromJson(Map<String, dynamic> json) => RowingQualityReportDetailModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RowingQualityReportDetailListModel>.from(json["List"].map((x) => RowingQualityReportDetailListModel.fromJson(x))),
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

class RowingQualityReportDetailListModel {
  String lineNo;
  String wo0Rder;
  String transactionDate;
  String inspecter;
  String endLineNo;
  int bundleNo;
  int totalpcs;
  int checkpc;
  int faultpc;
  String faults;
  String operationValue;
  int? opretor;
  String? machine;

  RowingQualityReportDetailListModel({
    required this.lineNo,
    required this.wo0Rder,
    required this.transactionDate,
    required this.inspecter,
    required this.endLineNo,
    required this.bundleNo,
    required this.totalpcs,
    required this.checkpc,
    required this.faultpc,
    required this.faults,
    required this.operationValue,
    required this.opretor,
    required this.machine,
  });

  factory RowingQualityReportDetailListModel.fromJson(Map<String, dynamic> json) => RowingQualityReportDetailListModel(
    lineNo: json["Line_No"],
    wo0Rder: json["wo0rder"],
    transactionDate: json["Transaction_Date"],
    inspecter:json["inspecter"],
    endLineNo: json["EndLine_No"],
    bundleNo: json["Bundle_No"],
    totalpcs: json["totalpcs"],
    checkpc: json["checkpc"],
    faultpc: json["faultpc"],
    faults: json["faults"],
    operationValue: json["operation_value"],
    opretor: json["opretor"],
    machine: json["machine"],
  );

  Map<String, dynamic> toJson() => {
    "Line_No": lineNo,
    "wo0rder": wo0Rder,
    "Transaction_Date": transactionDate,
    "inspecter": inspecter,
    "EndLine_No": endLineNo,
    "Bundle_No": bundleNo,
    "totalpcs": totalpcs,
    "checkpc": checkpc,
    "faultpc": faultpc,
    "faults": faults,
    "operation_value": operationValue,
    "opretor": opretor,
    "machine": machine,
  };
}
