class EndLineBundleReportsModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<EndLineBundleReportsListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  EndLineBundleReportsModel({
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

  factory EndLineBundleReportsModel.fromJson(Map<String, dynamic> json) => EndLineBundleReportsModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<EndLineBundleReportsListModel>.from(json["List"].map((x) => EndLineBundleReportsListModel.fromJson(x))),
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

class EndLineBundleReportsListModel {
  int lineNo;
  int enDlineNo;
  DateTime transDate;
  String woNumber;
  String endLineNo;
  int bundleNo;
  int bundleQty;
  bool status;
  int empId;
  int checkedQty;
  int defQty;
  String employeeName;
  String faults;

  EndLineBundleReportsListModel({
    required this.lineNo,
    required this.enDlineNo,
    required this.transDate,
    required this.woNumber,
    required this.endLineNo,
    required this.bundleNo,
    required this.bundleQty,
    required this.status,
    required this.empId,
    required this.checkedQty,
    required this.defQty,
    required this.employeeName,
    required this.faults,
  });

  factory EndLineBundleReportsListModel.fromJson(Map<String, dynamic> json) => EndLineBundleReportsListModel(
    lineNo: json["Line_No"],
    enDlineNo: json["EnDline_No"],
    transDate: DateTime.parse(json["TransDate"]),
    woNumber: json["WO_Number"],
    endLineNo: json["EndLineNo"],
    bundleNo: json["Bundle_No"],
    bundleQty: json["Bundle_Qty"],
    status: json["Status"],
    empId: json["Emp_id"],
    checkedQty: json["CheckedQty"],
    defQty: json["DefQty"],
    employeeName: json["EmployeeName"],
    faults: json["faults"],
  );

  Map<String, dynamic> toJson() => {
    "Line_No": lineNo,
    "EnDline_No": enDlineNo,
    "TransDate": transDate.toIso8601String(),
    "WO_Number": woNumber,
    "EndLineNo": endLineNo,
    "Bundle_No": bundleNo,
    "Bundle_Qty": bundleQty,
    "Status": status,
    "Emp_id": empId,
    "CheckedQty": checkedQty,
    "DefQty": defQty,
    "EmployeeName": employeeName,
    "faults": faults,
  };
}
