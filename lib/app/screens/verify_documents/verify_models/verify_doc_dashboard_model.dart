class DocumentVerifyAppModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<DocumentVerifyAppListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  DocumentVerifyAppModel({
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

  factory DocumentVerifyAppModel.fromJson(Map<String, dynamic> json) =>
      DocumentVerifyAppModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: json["List"],
        lists: json["Lists"] != null
            ? List<DocumentVerifyAppListModel>.from(json["Lists"]
                .map((x) => DocumentVerifyAppListModel.fromJson(x)))
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

class DocumentVerifyAppListModel {
  int appid;
  String appname;
  int parentappid;
  int documentCount;
  String cspid;
  String apptable;
  String reportpath;
  String apppk;
  String reportpara;
  dynamic reportpara1;
  dynamic apppk1;
  dynamic reportpath1;
  dynamic emails;
  bool aprAlerts;
  bool rejAlerts;
  String rejEmail;
  int priority;

  DocumentVerifyAppListModel({
    required this.appid,
    required this.appname,
    required this.parentappid,
    required this.documentCount,
    required this.cspid,
    required this.apptable,
    required this.reportpath,
    required this.apppk,
    required this.reportpara,
    required this.reportpara1,
    required this.apppk1,
    required this.reportpath1,
    required this.emails,
    required this.aprAlerts,
    required this.rejAlerts,
    required this.rejEmail,
    required this.priority,
  });

  factory DocumentVerifyAppListModel.fromJson(Map<String, dynamic> json) =>
      DocumentVerifyAppListModel(
        appid: json["APPID"],
        appname: json["APPNAME"],
        parentappid: json["PARENTAPPID"],
        documentCount: json["DocumentCount"],
        cspid: json["CSPID"],
        apptable: json["APPTABLE"],
        reportpath: json["REPORTPATH"],
        apppk: json["APPPK"],
        reportpara: json["REPORTPARA"],
        reportpara1: json["REPORTPARA1"],
        apppk1: json["APPPK1"],
        reportpath1: json["REPORTPATH1"],
        emails: json["Emails"],
        aprAlerts: json["AprAlerts"],
        rejAlerts: json["RejAlerts"],
        rejEmail: json["rejEmail"],
        priority: json["priority"],
      );

  Map<String, dynamic> toJson() => {
        "APPID": appid,
        "APPNAME": appname,
        "PARENTAPPID": parentappid,
        "documentCount": documentCount,
        "CSPID": cspid,
        "APPTABLE": apptable,
        "REPORTPATH": reportpath,
        "APPPK": apppk,
        "REPORTPARA": reportpara,
        "REPORTPARA1": reportpara1,
        "APPPK1": apppk1,
        "REPORTPATH1": reportpath1,
        "Emails": emails,
        "AprAlerts": aprAlerts,
        "RejAlerts": rejAlerts,
        "rejEmail": rejEmail,
        "priority": priority,
      };
}
