class ComplaintAssigneeModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<ComplaintAssigneeListModel> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  ComplaintAssigneeModel({
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

  factory ComplaintAssigneeModel.fromJson(Map<String, dynamic> json) => ComplaintAssigneeModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<ComplaintAssigneeListModel>.from(json["List"].map((x) => ComplaintAssigneeListModel.fromJson(x))),
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

class ComplaintAssigneeListModel {
  int departmentCode;
  int employeeCode;
  String employeeName;

  ComplaintAssigneeListModel({
    required this.departmentCode,
    required this.employeeCode,
    required this.employeeName,
  });

  factory ComplaintAssigneeListModel.fromJson(Map<String, dynamic> json) => ComplaintAssigneeListModel(
    departmentCode: json["DepartmentCode"],
    employeeCode: json["EmployeeCode"],
    employeeName: json["EmployeeName"],
  );

  Map<String, dynamic> toJson() => {
    "DepartmentCode": departmentCode,
    "EmployeeCode": employeeCode,
    "EmployeeName": employeeName,
  };
}
