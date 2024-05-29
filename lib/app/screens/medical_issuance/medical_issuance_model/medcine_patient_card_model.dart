class PatientCardModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  PatientCardDataModel data;
  dynamic list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  PatientCardModel({
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

  factory PatientCardModel.fromJson(Map<String, dynamic> json) =>
      PatientCardModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: PatientCardDataModel.fromJson(json["Data"]),
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

class PatientCardDataModel {
  int empCode;
  int deptCode;
  String empName;
  String deptName;

  PatientCardDataModel({
    required this.empCode,
    required this.deptCode,
    required this.empName,
    required this.deptName,
  });

  factory PatientCardDataModel.fromJson(Map<String, dynamic> json) =>
      PatientCardDataModel(
        empCode: json["EmpCode"] ?? 0,
        deptCode: json["DeptCode"] ?? 0,
        empName: json["EmpName"] ?? '',
        deptName: json["DeptName"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "EmpCode": empCode,
        "DeptCode": deptCode,
        "EmpName": empName,
        "DeptName": deptName,
      };
}
