class DocumentHistory {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<DocumentHistoryList> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  DocumentHistory({
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

  factory DocumentHistory.fromJson(Map<String, dynamic> json) => DocumentHistory(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<DocumentHistoryList>.from(json["Lists"].map((x) => DocumentHistoryList.fromJson(x))),
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

class DocumentHistoryList {
  int applogid;
  int autoid;
  String userid;
  DateTime audtdatetime;
  String computername;
  String domainuser;
  int status;
  String comments;
  String loginuserid;
  String? ipAddress;
  dynamic dStatus;
  int? docId;
  String username;

  DocumentHistoryList({
    required this.applogid,
    required this.autoid,
    required this.userid,
    required this.audtdatetime,
    required this.computername,
    required this.domainuser,
    required this.status,
    required this.comments,
    required this.loginuserid,
    required this.ipAddress,
    required this.dStatus,
    required this.docId,
    required this.username,
  });

  factory DocumentHistoryList.fromJson(Map<String, dynamic> json) => DocumentHistoryList(
    applogid: json["APPLOGID"],
    autoid: json["AUTOID"],
    userid: json["USERID"],
    audtdatetime: DateTime.parse(json["AUDTDATETIME"]),
    computername: json["COMPUTERNAME"],
    domainuser: json["DOMAINUSER"],
    status: json["STATUS"],
    comments: json["COMMENTS"],
    loginuserid: json["LOGINUSERID"],
    ipAddress: json["IpAddress"],
    dStatus: json["dStatus"],
    docId: json["DocID"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "APPLOGID": applogid,
    "AUTOID": autoid,
    "USERID": userid,
    "AUDTDATETIME": audtdatetime.toIso8601String(),
    "COMPUTERNAME": computername,
    "DOMAINUSER": domainuser,
    "STATUS": status,
    "COMMENTS": comments,
    "LOGINUSERID": loginuserid,
    "IpAddress": ipAddress,
    "dStatus": dStatus,
    "DocID": docId,
    "username": username,
  };
}
