class EndLineInspectorHourlyReportModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<EndLineInspectorHourlyReportListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  EndLineInspectorHourlyReportModel({
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

  factory EndLineInspectorHourlyReportModel.fromJson(Map<String, dynamic> json) => EndLineInspectorHourlyReportModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<EndLineInspectorHourlyReportListModel>.from(json["List"].map((x) => EndLineInspectorHourlyReportListModel.fromJson(x))),
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

class EndLineInspectorHourlyReportListModel {
  int lineNo;
  String enDlineNo;
  DateTime transDate;
  String woNumber;
  int bundleQty;
  int checkedQty;
  int faultpcs;
  String timeRound;

  EndLineInspectorHourlyReportListModel({
    required this.lineNo,
    required this.enDlineNo,
    required this.transDate,
    required this.woNumber,
    required this.bundleQty,
    required this.checkedQty,
    required this.faultpcs,
    required this.timeRound,
  });

  factory EndLineInspectorHourlyReportListModel.fromJson(Map<String, dynamic> json) => EndLineInspectorHourlyReportListModel(
    lineNo: json["Line_No"],
    enDlineNo: json["EnDline_No"],
    transDate: DateTime.parse(json["TransDate"]),
    woNumber: json["WO_Number"],
    bundleQty: json["Bundle_Qty"],
    checkedQty: json["CheckedQty"],
    faultpcs: json["faultpcs"],
    timeRound: json["TimeRound"],
  );

  Map<String, dynamic> toJson() => {
    "Line_No": lineNo,
    "EnDline_No": enDlineNo,
    "TransDate": transDate.toIso8601String(),
    "WO_Number": woNumber,
    "Bundle_Qty": bundleQty,
    "CheckedQty": checkedQty,
    "faultpcs": faultpcs,
    "TimeRound": timeRound,
  };
}
