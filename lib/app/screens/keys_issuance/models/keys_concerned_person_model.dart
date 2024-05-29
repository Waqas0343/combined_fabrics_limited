class KeyConcernedPersonModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<KeyConcernedPersonListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  KeyConcernedPersonModel({
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

  factory KeyConcernedPersonModel.fromJson(Map<String, dynamic> json) =>
      KeyConcernedPersonModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<KeyConcernedPersonListModel>.from(
            json["List"].map((x) => KeyConcernedPersonListModel.fromJson(x))),
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

class KeyConcernedPersonListModel {
  int? personId;
  int employeeCardNo;
  String employeeName;
  String designation;
  int level;

  KeyConcernedPersonListModel({
    required this.personId,
    required this.employeeCardNo,
    required this.employeeName,
    required this.designation,
    required this.level,
  });

  factory KeyConcernedPersonListModel.fromJson(Map<String, dynamic> json) =>
      KeyConcernedPersonListModel(
        personId: json["PersonId"] as int? ?? 0,
        employeeCardNo: json["EmployeeCardNo"],
        employeeName: json["EmployeeName"] ?? "Unknown Employee",
        designation: json["Designation"] ?? "Unknown Designation",
        level: json["Level"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "PersonId": personId,
        "EmployeeCardNo": employeeCardNo,
        "EmployeeName": employeeName,
        "Designation": designation,
        "Level": level,
      };
}
