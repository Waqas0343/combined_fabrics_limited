class NextLevelUsersModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<NextLevelUsersListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  NextLevelUsersModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.errors,
    required this.expiredate,
    required this.data,
    required this.list,
    required this.lists,
    required this.iList,
    required this.ieList,
    required this.totalRecords,
    required this.totalPagesCount,
    required this.returnData,
  });

  factory NextLevelUsersModel.fromJson(Map<String, dynamic> json) =>
      NextLevelUsersModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: json["List"],
        lists: json["Lists"] != null
            ? List<NextLevelUsersListModel>.from(json["Lists"]
            .map((x) => NextLevelUsersListModel.fromJson(x)))
            : [],

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
        "List": list,
        "Lists": List<dynamic>.from(lists.map((x) => x.toJson())),
        "IList": iList,
        "IEList": ieList,
        "TotalRecords": totalRecords,
        "TotalPagesCount": totalPagesCount,
        "ReturnData": returnData,
      };
}

class NextLevelUsersListModel {
  String userid;
  String username;
  int authlevel;

  NextLevelUsersListModel({
    required this.userid,
    required this.username,
    required this.authlevel,
  });

  factory NextLevelUsersListModel.fromJson(Map<String, dynamic> json) =>
      NextLevelUsersListModel(
        userid: json["USERID"],
        username: json["USERNAME"],
        authlevel: json["AUTHLEVEL"],
      );

  Map<String, dynamic> toJson() => {
        "USERID": userid,
        "USERNAME": username,
        "AUTHLEVEL": authlevel,
      };
}
