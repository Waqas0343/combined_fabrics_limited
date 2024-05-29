class FirstAidBoxModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<FirstAidBoxListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  FirstAidBoxModel({
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

  factory FirstAidBoxModel.fromJson(Map<String, dynamic> json) => FirstAidBoxModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<FirstAidBoxListModel>.from(json["List"].map((x) => FirstAidBoxListModel.fromJson(x))),
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

class FirstAidBoxListModel {
  int id;
  int firstAidBoxNumber;
  String firstAidBoxNamed;

  FirstAidBoxListModel({
    required this.id,
    required this.firstAidBoxNumber,
    required this.firstAidBoxNamed,
  });

  factory FirstAidBoxListModel.fromJson(Map<String, dynamic> json) => FirstAidBoxListModel(
    id: json["Id"],
    firstAidBoxNumber: json["FirstAidBoxNumber"],
    firstAidBoxNamed: json["FirstAidBoxNamed"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "FirstAidBoxNumber": firstAidBoxNumber,
    "FirstAidBoxNamed": firstAidBoxNamed,
  };
}
