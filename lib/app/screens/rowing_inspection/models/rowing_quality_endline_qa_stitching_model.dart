class EndLineQAStitchingReportModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<EndLineQAStitchingReportListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  EndLineQAStitchingReportModel({
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

  factory EndLineQAStitchingReportModel.fromJson(Map<String, dynamic> json) => EndLineQAStitchingReportModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<EndLineQAStitchingReportListModel>.from(json["Lists"].map((x) => EndLineQAStitchingReportListModel.fromJson(x))),
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

class EndLineQAStitchingReportListModel {
  int line;
  DateTime transactionDate;
  String woNumber;
  int e1BundleNo;
  int e2BundleNo;
  int column1;
  int e1BundleQty;
  int e2BundleQty;
  int qmpBundleQty;
  int offLinepcs;
  int e1InspGarmentNo;
  int e2InspGarmentNo;
  int qMpInspGarmentNo;
  int e1Faultpcs;
  int e1Stichfaultpc;
  int e1Otherfaultpc;
  double e1StichDhu;
  double e1Otherstch;
  int e2Faultpcs;
  int e2Stichfaultpc;
  int e2Otherfaultpc;
  double e2StichDhu;
  double e2Otherstch;
  int qmpFaultpcs;
  int qmpStichfaultpc;
  int qmpOtherfaultpc;
  double qmpStichDhu;
  double qmpOtherstch;

  EndLineQAStitchingReportListModel({
    required this.line,
    required this.transactionDate,
    required this.woNumber,
    required this.e1BundleNo,
    required this.e2BundleNo,
    required this.column1,
    required this.e1BundleQty,
    required this.e2BundleQty,
    required this.qmpBundleQty,
    required this.offLinepcs,
    required this.e1InspGarmentNo,
    required this.e2InspGarmentNo,
    required this.qMpInspGarmentNo,
    required this.e1Faultpcs,
    required this.e1Stichfaultpc,
    required this.e1Otherfaultpc,
    required this.e1StichDhu,
    required this.e1Otherstch,
    required this.e2Faultpcs,
    required this.e2Stichfaultpc,
    required this.e2Otherfaultpc,
    required this.e2StichDhu,
    required this.e2Otherstch,
    required this.qmpFaultpcs,
    required this.qmpStichfaultpc,
    required this.qmpOtherfaultpc,
    required this.qmpStichDhu,
    required this.qmpOtherstch,
  });

  factory EndLineQAStitchingReportListModel.fromJson(Map<String, dynamic> json) => EndLineQAStitchingReportListModel(
    line: json["Line"],
    transactionDate: DateTime.parse(json["Transaction_Date"]),
    woNumber: json["WO_Number"],
    e1BundleNo: json["E1_BundleNo"],
    e2BundleNo: json["E2_BundleNo"],
    column1: json["Column1"] ?? 0,
    e1BundleQty: json["E1_BundleQty"],
    e2BundleQty: json["E2_BundleQty"],
    qmpBundleQty: json["Qmp_BundleQty"],
    offLinepcs: json["OffLinepcs"],
    e1InspGarmentNo: json["E1_InspGarmentNo"],
    e2InspGarmentNo: json["E2_InspGarmentNo"],
    qMpInspGarmentNo: json["QMp_InspGarmentNo"],
    e1Faultpcs: json["E1faultpcs"],
    e1Stichfaultpc: json["E1Stichfaultpc"],
    e1Otherfaultpc: json["E1otherfaultpc"],
    e1StichDhu: json["E1StichDHU"],
    e1Otherstch: json["E1Otherstch"],
    e2Faultpcs: json["E2faultpcs"],
    e2Stichfaultpc: json["E2Stichfaultpc"],
    e2Otherfaultpc: json["E2otherfaultpc"],
    e2StichDhu: json["E2StichDHU"]?.toDouble(),
    e2Otherstch: json["E2Otherstch"],
    qmpFaultpcs: json["QMP_faultpcs"],
    qmpStichfaultpc: json["QMP_Stichfaultpc"],
    qmpOtherfaultpc: json["QMP_otherfaultpc"],
    qmpStichDhu: json["QMP_StichDHU"]?.toDouble(),
    qmpOtherstch: json["QMP_Otherstch"],
  );

  Map<String, dynamic> toJson() => {
    "Line": line,
    "Transaction_Date": transactionDate.toIso8601String(),
    "WO_Number": woNumber,
    "E1_BundleNo": e1BundleNo,
    "E2_BundleNo": e2BundleNo,
    "Column1": column1,
    "E1_BundleQty": e1BundleQty,
    "E2_BundleQty": e2BundleQty,
    "Qmp_BundleQty": qmpBundleQty,
    "OffLinepcs": offLinepcs,
    "E1_InspGarmentNo": e1InspGarmentNo,
    "E2_InspGarmentNo": e2InspGarmentNo,
    "QMp_InspGarmentNo": qMpInspGarmentNo,
    "E1faultpcs": e1Faultpcs,
    "E1Stichfaultpc": e1Stichfaultpc,
    "E1otherfaultpc": e1Otherfaultpc,
    "E1StichDHU": e1StichDhu,
    "E1Otherstch": e1Otherstch,
    "E2faultpcs": e2Faultpcs,
    "E2Stichfaultpc": e2Stichfaultpc,
    "E2otherfaultpc": e2Otherfaultpc,
    "E2StichDHU": e2StichDhu,
    "E2Otherstch": e2Otherstch,
    "QMP_faultpcs": qmpFaultpcs,
    "QMP_Stichfaultpc": qmpStichfaultpc,
    "QMP_otherfaultpc": qmpOtherfaultpc,
    "QMP_StichDHU": qmpStichDhu,
    "QMP_Otherstch": qmpOtherstch,
  };
}
