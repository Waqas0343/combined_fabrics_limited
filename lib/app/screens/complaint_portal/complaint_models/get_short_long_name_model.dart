class ShortNameLongNameAssetModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  AssetCodeModel data;
  dynamic list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  ShortNameLongNameAssetModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    this.expiredate,
    required this.data,
    this.list,
    this.iList,
    this.totalRecords,
    this.totalPagesCount,
  });

  factory ShortNameLongNameAssetModel.fromJson(Map<String, dynamic> json) => ShortNameLongNameAssetModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: AssetCodeModel.fromJson(json["Data"]),
    list: json["List"],
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
    "Data": data.toJson(),
    "List": list,
    "IList": iList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
  };
}

class AssetCodeModel {
  String assetCode;
  String shortName;
  String longName;

  AssetCodeModel({
    required this.assetCode,
    required this.shortName,
    required this.longName,
  });

  factory AssetCodeModel.fromJson(Map<String, dynamic> json) => AssetCodeModel(
    assetCode: json["AssetCode"],
    shortName: json["ShortName"],
    longName: json["LongName"],
  );

  Map<String, dynamic> toJson() => {
    "AssetCode": assetCode,
    "ShortName": shortName,
    "LongName": longName,
  };
}
