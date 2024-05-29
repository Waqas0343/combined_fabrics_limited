class SubMenuModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<SubMenuModelList> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  SubMenuModel({
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

  factory SubMenuModel.fromJson(Map<String, dynamic> json) => SubMenuModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<SubMenuModelList>.from(json["List"].map((x) => SubMenuModelList.fromJson(x))),
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

class SubMenuModelList {
  int menuId;
  int subMenuId;
  String menuName;

  SubMenuModelList({
    required this.menuId,
    required this.subMenuId,
    required this.menuName,
  });

  factory SubMenuModelList.fromJson(Map<String, dynamic> json) => SubMenuModelList(
    menuId: json["MenuId"],
    subMenuId: json["SubMenuId"],
    menuName: json["MenuName"],
  );

  Map<String, dynamic> toJson() => {
    "MenuId": menuId,
    "SubMenuId": subMenuId,
    "MenuName": menuName,
  };
}
