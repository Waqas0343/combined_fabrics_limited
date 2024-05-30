class PendingDocumentsModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<PendingDocumentsListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  PendingDocumentsModel({
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

  factory PendingDocumentsModel.fromJson(Map<String, dynamic> json) =>
      PendingDocumentsModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: json["List"],
        lists: json["Lists"] != null
            ? List<PendingDocumentsListModel>.from(
                json["Lists"].map((x) => PendingDocumentsListModel.fromJson(x)))
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

class PendingDocumentsListModel {
  int applogid;
  int appid;
  int docnum;
  int authlevel;
  int status;
  String sign1;
  dynamic sign2;
  dynamic sign3;
  dynamic sign4;
  dynamic sign5;
  dynamic sign6;
  dynamic sign7;
  dynamic sign8;
  dynamic sign9;
  dynamic sign10;
  String department;
  DateTime createdDate;
  dynamic userid;
  dynamic completionDate;
  String lastuser;

  PendingDocumentsListModel({
    required this.applogid,
    required this.appid,
    required this.docnum,
    required this.authlevel,
    required this.status,
    required this.sign1,
    required this.sign2,
    required this.sign3,
    required this.sign4,
    required this.sign5,
    required this.sign6,
    required this.sign7,
    required this.sign8,
    required this.sign9,
    required this.sign10,
    required this.department,
    required this.createdDate,
    required this.userid,
    required this.completionDate,
    required this.lastuser,
  });

  factory PendingDocumentsListModel.fromJson(Map<String, dynamic> json) =>
      PendingDocumentsListModel(
        applogid: json["APPLOGID"],
        appid: json["APPID"],
        docnum: json["DOCNUM"],
        authlevel: json["AUTHLEVEL"],
        status: json["STATUS"],
        sign1: json["SIGN1"],
        sign2: json["SIGN2"],
        sign3: json["SIGN3"],
        sign4: json["SIGN4"],
        sign5: json["SIGN5"],
        sign6: json["SIGN6"],
        sign7: json["SIGN7"],
        sign8: json["SIGN8"],
        sign9: json["SIGN9"],
        sign10: json["SIGN10"],
        department: json["DEPARTMENT"],
        createdDate: DateTime.parse(json["CreatedDate"]),
        userid: json["USERID"],
        completionDate: json["CompletionDate"],
        lastuser: json["LASTUSER"],
      );

  Map<String, dynamic> toJson() => {
        "APPLOGID": applogid,
        "APPID": appid,
        "DOCNUM": docnum,
        "AUTHLEVEL": authlevel,
        "STATUS": status,
        "SIGN1": sign1,
        "SIGN2": sign2,
        "SIGN3": sign3,
        "SIGN4": sign4,
        "SIGN5": sign5,
        "SIGN6": sign6,
        "SIGN7": sign7,
        "SIGN8": sign8,
        "SIGN9": sign9,
        "SIGN10": sign10,
        "DEPARTMENT": department,
        "CreatedDate": createdDate.toIso8601String(),
        "USERID": userid,
        "CompletionDate": completionDate,
        "LASTUSER": lastuser,
      };
}
