import 'package:get/get.dart';

class RowingQualityFaultModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityFaultListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  RowingQualityFaultModel({
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

  factory RowingQualityFaultModel.fromJson(Map<String, dynamic> json) => RowingQualityFaultModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RowingQualityFaultListModel>.from(json["List"].map((x) => RowingQualityFaultListModel.fromJson(x))),
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

class RowingQualityFaultListModel {
  int formNo;
  int code;
  String longname;
  String dftLongname;
  RxInt quantity = RxInt(0);
  int formNoDefclsFk;

  RowingQualityFaultListModel({
    required this.formNo,
    required this.code,
    required this.longname,
    required this.dftLongname,
    required this.quantity,
    required this.formNoDefclsFk,
  });

  factory RowingQualityFaultListModel.fromJson(Map<String, dynamic> json) => RowingQualityFaultListModel(
    formNo: json["FormNo"],
    code: json["Code"],
    longname: json["Longname"],
    dftLongname: json["DftLongname"],
    quantity: RxInt(json["Quantity"] ?? 0),
    formNoDefclsFk: json["FormNoDefclsFk"],

  );

  Map<String, dynamic> toJson() => {
    "FormNo": formNo,
    "Code": code,
    "Longname": longname,
    "DftLongname":dftLongname,
    "Quantity":quantity,
    "FormNoDefclsFk": formNoDefclsFk,
  };
}



