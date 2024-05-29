import 'package:get/get_rx/src/rx_types/rx_types.dart';

class RowingQualityAllFaultsModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityAllFaultsListModel> list;
  dynamic lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityAllFaultsModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.errors,
    required this.expiredate,
    required this.data,
    required this.list,
    required this.lists,
    required this.iList,
    required this.ieList,
    required this.totalRecords,
    required this.totalPagesCount,
    required this.returnData,
  });

  factory RowingQualityAllFaultsModel.fromJson(Map<String, dynamic> json) => RowingQualityAllFaultsModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RowingQualityAllFaultsListModel>.from(json["List"].map((x) => RowingQualityAllFaultsListModel.fromJson(x))),
    lists: json["Lists"],
    iList: json["IList"],
    ieList: json["IEList"],
    totalRecords: json["TotalRecords"],
    totalPagesCount: json["TotalPagesCount"],
    returnData: json["ReturnData"],
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
    "StatusCode": statusCode,
    "Errors": errors,
    "Expiredate": expiredate,
    "Data": data,
    "List": List<dynamic>.from(list.map((x) => x.toJson())),
    "Lists": lists,
    "IList": iList,
    "IEList": ieList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
    "ReturnData": returnData,
  };
}

class RowingQualityAllFaultsListModel {
  int formNo;
  int code;
  String longname;
  String dftLongname;
  int formNoDefclsFk;
  RxInt quantity = RxInt(0);
  String areaOrDept;

  RowingQualityAllFaultsListModel({
    required this.formNo,
    required this.code,
    required this.longname,
    required this.dftLongname,
    required this.formNoDefclsFk,
    required this.quantity,
    required this.areaOrDept,
  });

  factory RowingQualityAllFaultsListModel.fromJson(Map<String, dynamic> json) => RowingQualityAllFaultsListModel(
    formNo: json["FormNo"],
    code: json["Code"],
    longname: json["Longname"],
    dftLongname: json["DftLongname"],
    formNoDefclsFk: json["FormNoDefclsFk"],
    quantity: RxInt(json["Quantity"] ?? 0),
    areaOrDept: json["AreaOrDept"],
  );

  Map<String, dynamic> toJson() => {
    "FormNo": formNo,
    "Code": code,
    "Longname": longname,
    "DftLongname": dftLongname,
    "FormNoDefclsFk": formNoDefclsFk,
    "Quantity":quantity,
    "AreaOrDept": areaOrDept,
  };
}
