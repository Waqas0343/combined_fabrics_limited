class WorkOrderProductionStitchingModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<WorkOrderProductionStitchingListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  WorkOrderProductionStitchingModel({
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

  factory WorkOrderProductionStitchingModel.fromJson(Map<String, dynamic> json) => WorkOrderProductionStitchingModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<WorkOrderProductionStitchingListModel>.from(json["Lists"].map((x) => WorkOrderProductionStitchingListModel.fromJson(x))),
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

class WorkOrderProductionStitchingListModel {
  DateTime time;
  double woNumber;
  String colour;
  double unitNo;
  double issuedpcs;
  int stichOut;
  int checkedPcs;
  double stichDhu;
  double otherDhu;

  WorkOrderProductionStitchingListModel({
    required this.time,
    required this.woNumber,
    required this.colour,
    required this.unitNo,
    required this.issuedpcs,
    required this.stichOut,
    required this.checkedPcs,
    required this.stichDhu,
    required this.otherDhu,
  });

  factory WorkOrderProductionStitchingListModel.fromJson(Map<String, dynamic> json) => WorkOrderProductionStitchingListModel(
    time: DateTime.parse(json["time"]),
    woNumber: json["wo_number"],
    colour: json["Colour"],
    unitNo: json["UnitNo"],
    issuedpcs: json["Issuedpcs"],
    stichOut: json["Stich_Out"],
    checkedPcs: json["Checked_pcs"] ?? 0,
    stichDhu: json["Stich_DHU"] ?? 0.0,
    otherDhu: json["Other_DHU"] ?? 0.0 ,
  );

  Map<String, dynamic> toJson() => {
    "time": time.toIso8601String(),
    "wo_number": woNumber,
    "Colour": colour,
    "UnitNo": unitNo,
    "Issuedpcs": issuedpcs,
    "Stich_Out": stichOut,
    "Checked_pcs": checkedPcs,
    "Stich_DHU": stichDhu,
    "Other_DHU": otherDhu,
  };
}
