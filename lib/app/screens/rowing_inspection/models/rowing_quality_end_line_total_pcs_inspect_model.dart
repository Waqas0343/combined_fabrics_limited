class RowingQualityEndLineTotalPcsInspectModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityEndLineTotalPcsInspectListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityEndLineTotalPcsInspectModel({
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

  factory RowingQualityEndLineTotalPcsInspectModel.fromJson(Map<String, dynamic> json) => RowingQualityEndLineTotalPcsInspectModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RowingQualityEndLineTotalPcsInspectListModel>.from(json["List"].map((x) => RowingQualityEndLineTotalPcsInspectListModel.fromJson(x))),
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

class RowingQualityEndLineTotalPcsInspectListModel {
  int todayTotal;
  int totalGarment;

  RowingQualityEndLineTotalPcsInspectListModel({
    required this.todayTotal,
    required this.totalGarment,
  });

  factory RowingQualityEndLineTotalPcsInspectListModel.fromJson(Map<String, dynamic> json) => RowingQualityEndLineTotalPcsInspectListModel(
    todayTotal: json["today_total"],
    totalGarment: json["total_garment"],
  );

  Map<String, dynamic> toJson() => {
    "today_total": todayTotal,
    "total_garment": totalGarment,
  };
}
