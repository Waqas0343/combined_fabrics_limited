class ComplaintStatusModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<ComplaintStatusListModel> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  ComplaintStatusModel({
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

  factory ComplaintStatusModel.fromJson(Map<String, dynamic> json) =>
      ComplaintStatusModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<ComplaintStatusListModel>.from(
            json["List"].map((x) => ComplaintStatusListModel.fromJson(x))),
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

class ComplaintStatusListModel {
  int statusId;
  String statusName;
  String status;

  ComplaintStatusListModel({
    required this.statusId,
    required this.statusName,
    required this.status,
  });

  factory ComplaintStatusListModel.fromJson(Map<String, dynamic> json) =>
      ComplaintStatusListModel(
        statusId: json["StatusId"],
        statusName: json["StatusName"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "StatusId": statusId,
        "StatusName": statusName,
        "Status": status,
      };
}
