class RowingQualityBundleModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityBundleListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityBundleModel({
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
    required this.returnData,
  });

  factory RowingQualityBundleModel.fromJson(Map<String, dynamic> json) => RowingQualityBundleModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<RowingQualityBundleListModel>.from(json["List"].map((x) => RowingQualityBundleListModel.fromJson(x))),
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
    "IList": iList,
    "IEList": ieList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
    "ReturnData": returnData,
  };
}

class RowingQualityBundleListModel {
  String woDetails;
  int bundlenumber;
  int bundlePcsOk;

  RowingQualityBundleListModel({
    required this.woDetails,
    required this.bundlenumber,
    required this.bundlePcsOk,
  });

  factory RowingQualityBundleListModel.fromJson(Map<String, dynamic> json) => RowingQualityBundleListModel(
    woDetails: json["wo_details"],
    bundlenumber: json["bundlenumber"],
    bundlePcsOk: json["BundlePcsOk"],
  );

  Map<String, dynamic> toJson() => {
    "wo_details":woDetails,
    "bundlenumber": bundlenumber,
    "BundlePcsOk": bundlePcsOk,
  };
}
