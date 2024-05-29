class GoodsInspectionOtherDepartmentModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<GoodsInspectionOtherDepartmentListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  GoodsInspectionOtherDepartmentModel({
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

  factory GoodsInspectionOtherDepartmentModel.fromJson(
          Map<String, dynamic> json) =>
      GoodsInspectionOtherDepartmentModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<GoodsInspectionOtherDepartmentListModel>.from(json["List"].map((x) => GoodsInspectionOtherDepartmentListModel.fromJson(x))),
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

class GoodsInspectionOtherDepartmentListModel {
  int deptCode;
  String deptName;

  GoodsInspectionOtherDepartmentListModel({
    required this.deptCode,
    required this.deptName,
  });

  factory GoodsInspectionOtherDepartmentListModel.fromJson(
          Map<String, dynamic> json) =>
      GoodsInspectionOtherDepartmentListModel(
        deptCode: json["DeptCode"],
        deptName: json["DeptName"],
      );

  Map<String, dynamic> toJson() => {
        "DeptCode": deptCode,
        "DeptName": deptName,
      };
}
