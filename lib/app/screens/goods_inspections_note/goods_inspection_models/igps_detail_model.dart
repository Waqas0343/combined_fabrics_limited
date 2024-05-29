import 'goods_inspection_other_department_model.dart';

class IGPDetailModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<IGPDetailListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  IGPDetailModel({
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

  factory IGPDetailModel.fromJson(Map<String, dynamic> json) => IGPDetailModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<IGPDetailListModel>.from(json["List"].map((x) => IGPDetailListModel.fromJson(x))),
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

class IGPDetailListModel {
  int igpNo;
  int igpSrNo;
  String itemName;
  String itemDescriptionCode;
  String deptName;
  int deptCode;
  int igpQty;
  GoodsInspectionOtherDepartmentListModel? selectedDepartment;

  IGPDetailListModel({
    required this.igpNo,
    required this.igpSrNo,
    required this.itemName,
    required this.itemDescriptionCode,
    required this.deptName,
    required this.deptCode,
    required this.igpQty,
    this.selectedDepartment,
  });

  factory IGPDetailListModel.fromJson(Map<String, dynamic> json) => IGPDetailListModel(
    igpNo: json["IGPNo"],
    igpSrNo: json["IGPSrNo"],
    itemName: json["ItemName"],
    itemDescriptionCode: json["ItemDescriptionCode"],
    deptName: json["DeptName"],
    deptCode: json["DeptCode"],
    igpQty: json["IGPQty"],

  );

  Map<String, dynamic> toJson() => {
    "IGPNo": igpNo,
    "IGPSrNo": igpSrNo,
    "ItemName": itemName,
    "ItemDescriptionCode": itemDescriptionCode,
    "DeptName": deptName,
    "DeptCode": deptCode,
    "IGPQty": igpQty,
  };
}