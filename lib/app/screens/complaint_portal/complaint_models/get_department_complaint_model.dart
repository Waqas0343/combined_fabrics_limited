class DepartmentComplaintModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<DepartmentComplaintListModel> list;
  dynamic iList;
  int totalRecords;
  int totalPagesCount;

  DepartmentComplaintModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    this.expiredate,
    this.data,
    required this.list,
    this.iList,
    required this.totalRecords,
    required this.totalPagesCount,
  });

  factory DepartmentComplaintModel.fromJson(Map<String, dynamic> json) => DepartmentComplaintModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<DepartmentComplaintListModel>.from(json["List"].map((x) => DepartmentComplaintListModel.fromJson(x))),
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

class DepartmentComplaintListModel {
  int cmpNo;
  int fromDeptCode;
  String fromDept;
  String fromDeptSn;
  int toDeptCode;
  String toDept;
  String toDeptSn;
  String detail;
  String dateTime;
  int priorityId;
  String priority;
  int statusId;
  String status;
  String complaintBy;
  String planStartDate;
  String planEndDate;
  String actualStartDate;
  String actualEndDate;
  dynamic demandNo;
  dynamic demandSrno;

  DepartmentComplaintListModel({
    required this.cmpNo,
    required this.fromDeptCode,
    required this.fromDept,
    required this.fromDeptSn,
    required this.toDeptCode,
    required this.toDept,
    required this.toDeptSn,
    required this.detail,
    required this.dateTime,
    required this.priorityId,
    required this.priority,
    required this.statusId,
    required this.status,
    required this.complaintBy,
    required this.planStartDate,
    required this.planEndDate,
    required this.actualStartDate,
    required this.actualEndDate,
    required this.demandNo,
    required this.demandSrno,
  });

  factory DepartmentComplaintListModel.fromJson(Map<String, dynamic> json) => DepartmentComplaintListModel(
    cmpNo: json["CmpNo"],
    fromDeptCode: json["FromDeptCode"],
    fromDept: json["FromDept"],
    fromDeptSn: json["FromDeptSN"],
    toDeptCode: json["ToDeptCode"],
    toDept: json["ToDept"],
    toDeptSn: json["ToDeptSN"],
    detail: json["Detail"],
    dateTime: json["DateTime"],
    priorityId: json["PriorityId"],
    priority: json["Priority"],
    statusId: json["StatusId"],
    status: json["Status"],
    complaintBy: json["ComplaintBy"],
    planStartDate: json["PlanStartDate"],
    planEndDate: json["PlanEndDate"],
    actualStartDate: json["ActualStartDate"],
    actualEndDate: json["ActualEndDate"],
    demandNo: json["DemandNo"],
    demandSrno: json["DemandSrno"],
  );

  Map<String, dynamic> toJson() => {
    "CmpNo": cmpNo,
    "FromDeptCode": fromDeptCode,
    "FromDept": fromDept,
    "FromDeptSN": fromDeptSn,
    "ToDeptCode": toDeptCode,
    "ToDept": toDept,
    "ToDeptSN": toDeptSn,
    "Detail": detail,
    "DateTime": dateTime,
    "PriorityId": priorityId,
    "Priority": priority,
    "StatusId": statusId,
    "Status": status,
    "ComplaintBy": complaintBy,
    "PlanStartDate": planStartDate,
    "PlanEndDate": planEndDate,
    "ActualStartDate": actualStartDate,
    "ActualEndDate": actualEndDate,
    "DemandNo": demandNo,
    "DemandSrno": demandSrno,
  };
}
