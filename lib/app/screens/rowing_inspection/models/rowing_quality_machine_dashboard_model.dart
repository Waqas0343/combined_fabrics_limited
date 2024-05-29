class RowingQualityMachineDashboardModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityMachineDashboardListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  RowingQualityMachineDashboardModel({
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

  factory RowingQualityMachineDashboardModel.fromJson(Map<String, dynamic> json) => RowingQualityMachineDashboardModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RowingQualityMachineDashboardListModel>.from(json["List"].map((x) => RowingQualityMachineDashboardListModel.fromJson(x))),
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

class RowingQualityMachineDashboardListModel {
  int formNo;
  int lineNo;
  int empOperatorCode;
  String machineCode;
  String longName;
  String colorHexCode;
  DateTime created;
  String createdBy;
  DateTime updated;
  dynamic updatedBy;

  RowingQualityMachineDashboardListModel({
    required this.formNo,
    required this.lineNo,
    required this.empOperatorCode,
    required this.machineCode,
    required this.longName,
    required this.colorHexCode,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
  });

  factory RowingQualityMachineDashboardListModel.fromJson(Map<String, dynamic> json) => RowingQualityMachineDashboardListModel(
    formNo: json["FormNo"],
    lineNo: json["Line_No"],
    empOperatorCode: json["EMP_Operator_Code"],
    machineCode: json["Machine_Code"],
    longName: json["Long_Name"]  ?? "",
    colorHexCode: json["Color_HEX_Code"] ??'',
    created: DateTime.parse(json["created"]),
    createdBy: json["created_by"],
    updated: DateTime.parse(json["updated"]),
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "FormNo": formNo,
    "Line_No": lineNo,
    "EMP_Operator_Code": empOperatorCode,
    "Machine_Code": machineCode,
    "Long_Name": longName,
    "Color_HEX_Code":colorHexCode,
    "created": created.toIso8601String(),
    "created_by": createdBy,

    "updated": updated.toIso8601String(),
    "updated_by": updatedBy,
  };
}
