class MedicineModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<MedicineListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  MedicineModel({
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

  factory MedicineModel.fromJson(Map<String, dynamic> json) => MedicineModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<MedicineListModel>.from(json["List"].map((x) => MedicineListModel.fromJson(x))),
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

class MedicineListModel {
  String itemCode;
  String itemName;

  MedicineListModel({
    required this.itemCode,
    required this.itemName,
  });

  factory MedicineListModel.fromJson(Map<String, dynamic> json) => MedicineListModel(
    itemCode: json["ItemCode"],
    itemName: json["ItemName"],
  );

  Map<String, dynamic> toJson() => {
    "ItemCode": itemCode,
    "ItemName": itemName,
  };
}
