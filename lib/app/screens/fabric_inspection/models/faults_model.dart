import 'package:get/get.dart';

class FaultsModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  DateTime expiredate;
  dynamic data;
  List<FaultsListModel> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  FaultsModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    required this.expiredate,
    this.data,
    required this.list,
    this.iList,
    this.totalRecords,
    this.totalPagesCount,
  });

  factory FaultsModel.fromJson(Map<String, dynamic> json) => FaultsModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: DateTime.parse(json["Expiredate"]),
        data: json["Data"],
        list: List<FaultsListModel>.from(
            json["List"].map((x) => FaultsListModel.fromJson(x))),
        iList: json["IList"],
        totalRecords: json["TotalRecords"],
        totalPagesCount: json["TotalPagesCount"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Status": status,
        "StatusCode": statusCode,
        "Errors": errors,
        "Expiredate": expiredate.toIso8601String(),
        "Data": data,
        "List": List<dynamic>.from(list.map((x) => x.toJson())),
        "IList": iList,
        "TotalRecords": totalRecords,
        "TotalPagesCount": totalPagesCount,
      };
}

class FaultsListModel {
  int faultCode;
  int faultNameCode;
  String faultName;
  RxInt faultCount = 0.obs;

  FaultsListModel({
    required this.faultCode,
    required this.faultNameCode,
    required this.faultName,
    required this.faultCount,
  });

  factory FaultsListModel.fromJson(Map<String, dynamic> json) =>
      FaultsListModel(
        faultCode: json["FaultCode"],
        faultNameCode: json["FaultNameCode"],
        faultName: json["FaultName"],
        faultCount: RxInt(json["FaultCount"]),
      );

  Map<String, dynamic> toJson() => {
        "FaultCode": faultCode,
        "FaultNameCode": faultNameCode,
        "FaultName": faultName,
        "FaultCount": faultCount.value,
      };
}
