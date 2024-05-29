class GetDepartmentModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<DepartmentListModel> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  GetDepartmentModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    this.expiredate,
    this.data,
    required this.list,
    this.iList,
    this.totalRecords,
    this.totalPagesCount,
  });

  factory GetDepartmentModel.fromJson(Map<String, dynamic> json) => GetDepartmentModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<DepartmentListModel>.from(json["List"].map((x) => DepartmentListModel.fromJson(x))),
    iList: json["IList"],
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
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
  };
}

class DepartmentListModel {
  int deptCode;
  String deptName;

  DepartmentListModel({
    required this.deptCode,
    required this.deptName,
  });

  factory DepartmentListModel.fromJson(Map<String, dynamic> json) => DepartmentListModel(
    deptCode: json["DeptCode"],
    deptName: json["DeptName"],
  );

  Map<String, dynamic> toJson() => {
    "DeptCode": deptCode,
    "DeptName": deptName,
  };
}
