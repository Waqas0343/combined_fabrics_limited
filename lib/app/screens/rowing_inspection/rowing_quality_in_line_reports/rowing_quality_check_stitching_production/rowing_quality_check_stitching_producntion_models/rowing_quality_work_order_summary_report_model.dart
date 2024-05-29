class RowingQualityWorkOrderSummaryModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<RowingQualityWorkOrderSummaryListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityWorkOrderSummaryModel({
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

  factory RowingQualityWorkOrderSummaryModel.fromJson(Map<String, dynamic> json) => RowingQualityWorkOrderSummaryModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<RowingQualityWorkOrderSummaryListModel>.from(json["Lists"].map((x) => RowingQualityWorkOrderSummaryListModel.fromJson(x))),
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

class RowingQualityWorkOrderSummaryListModel {
  String woOrder;
  String orderId;
  String color;
  String lineId;
  double okPcs;
  double issuedpcs;
  int stichOutpcs;
  double inductStock;
  DateTime laststitchpctime;
  DateTime starttime;
  double wip;
  double emboridrypcs;
  double printpcs;
  double checkedpcs;
  double stichDhu;
  double otherDhu;


  RowingQualityWorkOrderSummaryListModel({
    required this.woOrder,
    required this.orderId,
    required this.color,
    required this.lineId,
    required this.okPcs,
    required this.issuedpcs,
    required this.stichOutpcs,
    required this.inductStock,
    required this.laststitchpctime,
    required this.starttime,
    required this.wip,
    required this.emboridrypcs,
    required this.printpcs,
    required this.checkedpcs,
    required this.stichDhu,
    required this.otherDhu,
  });

  factory RowingQualityWorkOrderSummaryListModel.fromJson(Map<String, dynamic> json) => RowingQualityWorkOrderSummaryListModel(
    woOrder: json["Wo_order"],
    orderId: json["orderID"],
    color: json["color"],
    lineId: json["lineID"],
    okPcs: json["OkPcs"],
    issuedpcs: json["Issuedpcs"],
    stichOutpcs: json["stichOutpcs"],
    inductStock: json["induct_stock"],
    laststitchpctime: DateTime.parse(json["Laststitchpctime"]),
    starttime: DateTime.parse(json["starttime"]),
    wip: json["WIP"],
    emboridrypcs: json["emboridrypcs"],
    printpcs: json["printpcs"],
    checkedpcs: json["checkedpcs"] ?? 0.0,
    stichDhu: json["StichDHU"]?.toDouble(),
    otherDhu: json["OtherDHU"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Wo_order": woOrder,
    "orderID": orderId,
    "color": color,
    "lineID": lineId,
    "OkPcs": okPcs,
    "Issuedpcs": issuedpcs,
    "stichOutpcs": stichOutpcs,
    "induct_stock": inductStock,
    "Laststitchpctime": laststitchpctime.toIso8601String(),
    "starttime": starttime.toIso8601String(),
    "WIP": wip,
    "emboridrypcs": emboridrypcs,
    "printpcs": printpcs,
    "checkedpcs": checkedpcs,
    "StichDHU": stichDhu,
    "OtherDHU": otherDhu,
  };
}
