class FlagColorModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<FlagColorListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  FlagColorModel({
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

  factory FlagColorModel.fromJson(Map<String, dynamic> json) => FlagColorModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<FlagColorListModel>.from(json["List"].map((x) => FlagColorListModel.fromJson(x))),
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

class FlagColorListModel {
  String shortName;
  String longName;
  String colorHexCode;
  bool isActive;

  FlagColorListModel({
    required this.shortName,
    required this.longName,
    required this.colorHexCode,
    required this.isActive,
  });

  factory FlagColorListModel.fromJson(Map<String, dynamic> json) => FlagColorListModel(
    shortName: json["ShortName"],
    longName: json["LongName"],
    colorHexCode: json["ColorHexCode"],
    isActive: json["IsActive"],
  );

  Map<String, dynamic> toJson() => {
    "ShortName": shortName,
    "LongName": longName,
    "ColorHexCode": colorHexCode,
    "IsActive": isActive,
  };
}
