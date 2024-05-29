class ComplaintDashBoardModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  ComplaintDashBoardDataModel data;
  dynamic list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  ComplaintDashBoardModel({
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

  factory ComplaintDashBoardModel.fromJson(Map<String, dynamic> json) =>
      ComplaintDashBoardModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: ComplaintDashBoardDataModel.fromJson(json["Data"]),
        list: json["List"],
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
        "Data": data.toJson(),
        "List": list,
        "IList": iList,
        "IEList": ieList,
        "TotalRecords": totalRecords,
        "TotalPagesCount": totalPagesCount,
      };
}

class ComplaintDashBoardDataModel {
  int userRecieverCount;
  int userluancherCount;
  int complaintsCount;
  List<DepartmentCount> departmentCount;

  ComplaintDashBoardDataModel({
    required this.userRecieverCount,
    required this.userluancherCount,
    required this.complaintsCount,
    required this.departmentCount,
  });

  factory ComplaintDashBoardDataModel.fromJson(Map<String, dynamic> json) =>
      ComplaintDashBoardDataModel(
        userRecieverCount: json["UserRecieverCount"],
        userluancherCount: json["UserluancherCount"],
        complaintsCount: json["ComplaintsCount"],
        departmentCount: List<DepartmentCount>.from(
            json["DepartmentCount"].map((x) => DepartmentCount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "UserRecieverCount": userRecieverCount,
        "UserluancherCount": userluancherCount,
        "ComplaintsCount": complaintsCount,
        "DepartmentCount":
            List<dynamic>.from(departmentCount.map((x) => x.toJson())),
      };
}

class DepartmentCount {
  int deptCode;
  String deptName;
  int totalComplaints;
  String userIds;
  String userType;

  DepartmentCount({
    required this.deptCode,
    required this.deptName,
    required this.totalComplaints,
    required this.userIds,
    required this.userType,
  });

  factory DepartmentCount.fromJson(Map<String, dynamic> json) =>
      DepartmentCount(
        deptCode: json["DeptCode"],
        deptName: json["DeptName"],
        totalComplaints: json["TotalComplaints"],
        userIds: json["UserIds"],
        userType: json["UserType"],
      );

  Map<String, dynamic> toJson() => {
        "DeptCode": deptCode,
        "DeptName": deptName,
        "TotalComplaints": totalComplaints,
        "UserIds": userIds,
        "UserType": userType,
      };
}
