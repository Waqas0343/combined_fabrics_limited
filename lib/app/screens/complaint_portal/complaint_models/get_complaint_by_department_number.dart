class GetComplaintByNoModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  GetComplaintByNoDataModel data;
  dynamic list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  GetComplaintByNoModel({
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

  factory GetComplaintByNoModel.fromJson(Map<String, dynamic> json) => GetComplaintByNoModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: GetComplaintByNoDataModel.fromJson(json["Data"]),
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
    "Data": data.toJson(),
    "List": list,
    "IList": iList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
  };
}

class GetComplaintByNoDataModel {
  int complaintId;
  String fromDepartment;
  String toDepartment;
  int fromDepartmentCode;
  int toDepartmentCode;
  String detail;
  String dateTime;
  String complaintPriority;
  String complaintStatus;
  int statusId;
  String userId;
  String planStartDate;
  String planEndDate;
  String actualStartDate;
  String actualEndDate;
  int demandNo;
  int srNo;

  GetComplaintByNoDataModel({
    required this.complaintId,
    required this.fromDepartment,
    required this.toDepartment,
    required this.fromDepartmentCode,
    required this.toDepartmentCode,
    required this.detail,
    required this.dateTime,
    required this.complaintPriority,
    required this.complaintStatus,
    required this.statusId,
    required this.userId,
    required this.planStartDate,
    required this.planEndDate,
    required this.actualStartDate,
    required this.actualEndDate,
    required this.demandNo,
    required this.srNo,
  });

  factory GetComplaintByNoDataModel.fromJson(Map<String, dynamic> json) => GetComplaintByNoDataModel(
    complaintId: json["ComplaintId"],
    fromDepartment: json["FromDepartment"],
    toDepartment: json["ToDepartment"],
    fromDepartmentCode: json["FromDepartmentCode"],
    toDepartmentCode: json["ToDepartmentCode"],
    detail: json["Detail"],
    dateTime: json["DateTime"],
    complaintPriority: json["ComplaintPriority"],
    complaintStatus: json["ComplaintStatus"],
    statusId: json["StatusId"],
    userId: json["UserId"],
    planStartDate: json["PlanStartDate"],
    planEndDate: json["PlanEndDate"],
    actualStartDate: json["ActualStartDate"],
    actualEndDate: json["ActualEndDate"],
    demandNo: json["DemandNo"] ?? 0,
    srNo: json["SrNo"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "ComplaintId": complaintId,
    "FromDepartment": fromDepartment,
    "ToDepartment": toDepartment,
    "FromDepartmentCode": fromDepartmentCode,
    "ToDepartmentCode": toDepartmentCode,
    "Detail": detail,
    "DateTime": dateTime,
    "ComplaintPriority": complaintPriority,
    "ComplaintStatus": complaintStatus,
    "StatusId": statusId,
    "UserId": userId,
    "PlanStartDate": planStartDate,
    "PlanEndDate": planEndDate,
    "ActualStartDate": actualStartDate,
    "ActualEndDate": actualEndDate,
    "DemandNo": demandNo,
    "SrNo": srNo,
  };
}
