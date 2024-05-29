class MedicineStockModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<MedicineStockListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  MedicineStockModel({
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

  factory MedicineStockModel.fromJson(Map<String, dynamic> json) => MedicineStockModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<MedicineStockListModel>.from(json["List"].map((x) => MedicineStockListModel.fromJson(x))),
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

class MedicineStockListModel {
  String itemCode;
  String itemName;
  double stock;

  MedicineStockListModel({
    required this.itemCode,
    required this.itemName,
    required this.stock,
  });

  factory MedicineStockListModel.fromJson(Map<String, dynamic> json) => MedicineStockListModel(
    itemCode: json["ItemCode"],
    itemName: json["ItemName"],
    stock: json["Stock"],
  );

  Map<String, dynamic> toJson() => {
    "ItemCode": itemCode,
    "ItemName": itemName,
    "Stock": stock,
  };
}
