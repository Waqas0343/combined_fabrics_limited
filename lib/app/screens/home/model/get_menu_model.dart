class MenuModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<MenuModelList> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  MenuModel({
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

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<MenuModelList>.from(json["List"].map((x) => MenuModelList.fromJson(x))),
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

class MenuModelList {
  int appId;
  String appCode;
  int menuId;
  int subMenuId;
  String longName;
  String shortName;
  String menuName;

  MenuModelList({
    required this.appId,
    required this.appCode,
    required this.menuId,
    required this.subMenuId,
    required this.longName,
    required this.shortName,
    required this.menuName,
  });

  factory MenuModelList.fromJson(Map<String, dynamic> json) => MenuModelList(
    appId: json["AppId"],
    appCode: json["AppCode"],
    menuId: json["MenuId"],
    subMenuId: json["SubMenuId"],
    longName: json["LongName"],
    shortName: json["ShortName"],
    menuName: json["MenuName"],
  );

  Map<String, dynamic> toJson() => {
    "AppId": appId,
    "AppCode": appCode,
    "MenuId": menuId,
    "SubMenuId": subMenuId,
    "LongName": longName,
    "ShortName": shortName,
    "MenuName": menuName,
  };
}
