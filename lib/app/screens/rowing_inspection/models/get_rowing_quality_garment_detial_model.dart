class RowingQualityGarmentDetialModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityPendingGarmentDetailListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  RowingQualityGarmentDetialModel({
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
  });

  factory RowingQualityGarmentDetialModel.fromJson(Map<String, dynamic> json) => RowingQualityGarmentDetialModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RowingQualityPendingGarmentDetailListModel>.from(json["List"].map((x) => RowingQualityPendingGarmentDetailListModel.fromJson(x))),
    iList: json["IList"],
    ieList: json["IEList"],
    totalRecords: json["TotalRecords"],
    totalPagesCount: json["TotalPagesCount"],
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
  };
}

class RowingQualityPendingGarmentDetailListModel {
  int formNo;
  String lineNo;
  int roundNo;
  String woDetails;
  String employeeName;
  String operationname;
  int garmetCount;
  String flag;

  RowingQualityPendingGarmentDetailListModel({
    required this.formNo,
    required this.lineNo,
    required this.roundNo,
    required this.woDetails,
    required this.employeeName,
    required this.operationname,
    required this.garmetCount,
    required this.flag,
  });

  factory RowingQualityPendingGarmentDetailListModel.fromJson(Map<String, dynamic> json) => RowingQualityPendingGarmentDetailListModel(
    formNo: json["FormNo"],
    lineNo: json["Line_No"],
    roundNo: json["Round_No"],
    woDetails: json["wo_details"],
    employeeName: json["EmployeeName"],
    operationname: json["operationname"],
    garmetCount: json["Garmet_count"],
    flag: json["Flag"],
  );

  Map<String, dynamic> toJson() => {
    "FormNo": formNo,
    "Line_No": lineNo,
    "Round_No": roundNo,
    "wo_details": woDetails,
    "EmployeeName": employeeName,
    "operationname": operationname,
    "Garmet_count": garmetCount,
    "Flag": flag,
  };
}
