class InspectedIGPModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<InspectedIGPListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  InspectedIGPModel({
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

  factory InspectedIGPModel.fromJson(Map<String, dynamic> json) => InspectedIGPModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<InspectedIGPListModel>.from(json["List"].map((x) => InspectedIGPListModel.fromJson(x))),
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

class InspectedIGPListModel {
  String igpDate;
  int igpNo;
  String vendor;
  String inspectedDept;
  String inspectedBy;
  String itemName;
  int lineItem;
  int acceptedQty;
  int rejectedQty;
  DateTime igpDateFilter;

  InspectedIGPListModel({
    required this.igpDate,
    required this.igpNo,
    required this.vendor,
    required this.inspectedDept,
    required this.inspectedBy,
    required this.itemName,
    required this.lineItem,
    required this.acceptedQty,
    required this.rejectedQty,
    required this.igpDateFilter,
  });

  factory InspectedIGPListModel.fromJson(Map<String, dynamic> json) => InspectedIGPListModel(
    igpDate: json["IGPDate"],
    igpNo: json["IGPNo"],
    vendor: json["Vendor"],
    inspectedDept: json["InspectedDept"],
    inspectedBy: json["InspectedBy"],
    itemName: json["ItemName"],
    lineItem: json["LineItem"],
    acceptedQty: json["AcceptedQty"],
    rejectedQty: json["RejectedQty"],
    igpDateFilter: DateTime.parse(json["IGPDateFilter"]),
  );

  Map<String, dynamic> toJson() => {
    "IGPDate": igpDate,
    "IGPNo": igpNo,
    "Vendor": vendor,
    "InspectedDept": inspectedDept,
    "InspectedBy": inspectedBy,
    "ItemName": itemName,
    "LineItem": lineItem,
    "AcceptedQty": acceptedQty,
    "RejectedQty": rejectedQty,
    "IGPDateFilter": igpDateFilter.toIso8601String(),
  };
}
