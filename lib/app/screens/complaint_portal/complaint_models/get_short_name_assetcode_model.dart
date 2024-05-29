class ShortNameAssetCodeModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<ShortNameAssetCodeListModel> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  ShortNameAssetCodeModel({
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

  factory ShortNameAssetCodeModel.fromJson(Map<String, dynamic> json) =>
      ShortNameAssetCodeModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<ShortNameAssetCodeListModel>.from(
            json["List"].map((x) => ShortNameAssetCodeListModel.fromJson(x))),
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

class ShortNameAssetCodeListModel {
  String assetCode;
  String shortName;

  ShortNameAssetCodeListModel({
    required this.assetCode,
    required this.shortName,
  });

  factory ShortNameAssetCodeListModel.fromJson(Map<String, dynamic> json) =>
      ShortNameAssetCodeListModel(
        assetCode: json["AssetCode"],
        shortName: json["ShortName"],
      );

  Map<String, dynamic> toJson() => {
        "AssetCode": assetCode,
        "ShortName": shortName,
      };
}
