class RowingQualityTopFaultWithoutOperationModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<RowingQualityTopFaultWithoutOperationListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityTopFaultWithoutOperationModel({
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

  factory RowingQualityTopFaultWithoutOperationModel.fromJson(Map<String, dynamic> json) => RowingQualityTopFaultWithoutOperationModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<RowingQualityTopFaultWithoutOperationListModel>.from(json["Lists"].map((x) => RowingQualityTopFaultWithoutOperationListModel.fromJson(x))),
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

class RowingQualityTopFaultWithoutOperationListModel {
  DateTime transactionDate;
  int lineNo;
  String woNumber;
  String endLine;
  int stichfaultpc;
  int otherfaultpc;
  int faultCounts;
  int faultsFrequency;
  String fault;

  RowingQualityTopFaultWithoutOperationListModel({
    required this.transactionDate,
    required this.lineNo,
    required this.woNumber,
    required this.endLine,
    required this.stichfaultpc,
    required this.otherfaultpc,
    required this.faultCounts,
    required this.faultsFrequency,
    required this.fault,
  });

  factory RowingQualityTopFaultWithoutOperationListModel.fromJson(Map<String, dynamic> json) => RowingQualityTopFaultWithoutOperationListModel(
    transactionDate: DateTime.parse(json["Transaction_Date"]),
    lineNo: json["Line_No"],
    woNumber: json["WO_Number"],
    endLine: json["EndLine"],
    stichfaultpc: json["Stichfaultpc"],
    otherfaultpc: json["otherfaultpc"],
    faultCounts: json["Fault_Counts"],
    faultsFrequency: json["FaultsFrequency"],
    fault: json["Fault"],
  );

  Map<String, dynamic> toJson() => {
    "Transaction_Date": transactionDate.toIso8601String(),
    "Line_No": lineNo,
    "WO_Number": woNumber,
    "EndLine": endLine,
    "Stichfaultpc": stichfaultpc,
    "otherfaultpc": otherfaultpc,
    "Fault_Counts": faultCounts,
    "FaultsFrequency": faultsFrequency,
    "Fault": fault,
  };
}
