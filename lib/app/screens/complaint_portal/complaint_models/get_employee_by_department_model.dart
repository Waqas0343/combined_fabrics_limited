class EmployeeByDepartmentModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<EmployeeByDepartmentListModel> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  EmployeeByDepartmentModel({
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

  factory EmployeeByDepartmentModel.fromJson(Map<String, dynamic> json) => EmployeeByDepartmentModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<EmployeeByDepartmentListModel>.from(json["List"].map((x) => EmployeeByDepartmentListModel.fromJson(x))),
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

class EmployeeByDepartmentListModel {
  int employeeCode;
  String employeeName;

  EmployeeByDepartmentListModel({
    required this.employeeCode,
    required this.employeeName,
  });

  factory EmployeeByDepartmentListModel.fromJson(Map<String, dynamic> json) => EmployeeByDepartmentListModel(
    employeeCode: json["EmployeeCode"],
    employeeName: json["EmployeeName"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeCode": employeeCode,
    "EmployeeName": employeeName,
  };
}
