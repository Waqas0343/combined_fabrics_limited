class ToDepartmentModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  List<ToDepartmentListModel> data;
  dynamic list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  ToDepartmentModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    this.expiredate,
    required this.data,
    this.list,
    this.iList,
    this.totalRecords,
    this.totalPagesCount,
  });

  factory ToDepartmentModel.fromJson(Map<String, dynamic> json) => ToDepartmentModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: List<ToDepartmentListModel>.from(json["Data"].map((x) => ToDepartmentListModel.fromJson(x))),
    list: json["List"],
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
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
    "List": list,
    "IList": iList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
  };
}

class ToDepartmentListModel {
  String departmentName;
  int departmentCode;

  ToDepartmentListModel({
    required this.departmentName,
    required this.departmentCode,
  });

  factory ToDepartmentListModel.fromJson(Map<String, dynamic> json) => ToDepartmentListModel(
    departmentName: json["DepartmentName"],
    departmentCode: json["DepartmentCode"],
  );

  Map<String, dynamic> toJson() => {
    "DepartmentName": departmentName,
    "DepartmentCode": departmentCode,
  };
}
