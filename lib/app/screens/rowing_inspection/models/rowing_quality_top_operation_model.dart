class RowingQualityTopOperationModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<RowingQualityTopOperationListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityTopOperationModel({
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

  factory RowingQualityTopOperationModel.fromJson(Map<String, dynamic> json) => RowingQualityTopOperationModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<RowingQualityTopOperationListModel>.from(json["Lists"].map((x) => RowingQualityTopOperationListModel.fromJson(x))),
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

class RowingQualityTopOperationListModel {
  String lineNo;
  String wo0Rder;
  DateTime date;
  int endLineNo;
  String operationValue;
  String deffects;
  int faultpc;
  int oprFrequncy;

  RowingQualityTopOperationListModel({
    required this.lineNo,
    required this.wo0Rder,
    required this.date,
    required this.endLineNo,
    required this.operationValue,
    required this.deffects,
    required this.faultpc,
    required this.oprFrequncy,
  });

  factory RowingQualityTopOperationListModel.fromJson(Map<String, dynamic> json) => RowingQualityTopOperationListModel(
    lineNo: json["Line_No"],
    wo0Rder: json["wo0rder"],
    date: DateTime.parse(json["Date"]),
    endLineNo: json["EndLine_No"],
    operationValue: json["operation_value"],
    deffects: json["deffects"],
    faultpc: json["faultpc"],
    oprFrequncy: json["opr_Frequncy"],
  );

  Map<String, dynamic> toJson() => {
    "Line_No": lineNo,
    "wo0rder": wo0Rder,
    "Date": date.toIso8601String(),
    "EndLine_No": endLineNo,
    "operation_value": operationValue,
    "deffects": deffects,
    "faultpc": faultpc,
    "opr_Frequncy": oprFrequncy,
  };
}

