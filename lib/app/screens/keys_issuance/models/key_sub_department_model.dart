class SubDepartmentModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<SubDepartmentListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  SubDepartmentModel({
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

  factory SubDepartmentModel.fromJson(Map<String, dynamic> json) => SubDepartmentModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<SubDepartmentListModel>.from(json["List"].map((x) => SubDepartmentListModel.fromJson(x))),
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

class SubDepartmentListModel {
  int subDeptId;
  String subDeptName;
  dynamic isActive;

  SubDepartmentListModel({
    required this.subDeptId,
    required this.subDeptName,
    required this.isActive,
  });

  factory SubDepartmentListModel.fromJson(Map<String, dynamic> json) => SubDepartmentListModel(
    subDeptId: json["SubDeptId"],
    subDeptName: json["SubDeptName"],
    isActive: json["IsActive"],
  );

  Map<String, dynamic> toJson() => {
    "SubDeptId": subDeptId,
    "SubDeptName": subDeptName,
    "IsActive": isActive,
  };
}
