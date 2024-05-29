class KeyReportModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<KeyReportListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  KeyReportModel({
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

  factory KeyReportModel.fromJson(Map<String, dynamic> json) => KeyReportModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<KeyReportListModel>.from(
            json["List"].map((x) => KeyReportListModel.fromJson(x))),
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

class KeyReportListModel {
  String keyCode;
  String keyType;
  String keyDept;
  int concernPerson;
  String monIssueTime;
  String tueIssueTime;
  String wedIssueTime;
  String thurIssueTime;
  String friIssueTime;
  String satIssueTime;
  String sunIssueTime;
  String monReturnTime;
  String tueReturnTime;
  String wedReturnTime;
  String thurReturnTime;
  String friReturnTime;
  String satReturnTime;
  String sunReturnTime;
  String monAlarmTime;
  String tueAlarmTime;
  String wedAlarmTime;
  String thurAlarmTime;
  String friAlarmTime;
  String satAlarmTime;
  String sunAlarmTime;

  KeyReportListModel({
    required this.keyCode,
    required this.keyType,
    required this.keyDept,
    required this.concernPerson,
    required this.monIssueTime,
    required this.tueIssueTime,
    required this.wedIssueTime,
    required this.thurIssueTime,
    required this.friIssueTime,
    required this.satIssueTime,
    required this.sunIssueTime,
    required this.monReturnTime,
    required this.tueReturnTime,
    required this.wedReturnTime,
    required this.thurReturnTime,
    required this.friReturnTime,
    required this.satReturnTime,
    required this.sunReturnTime,
    required this.monAlarmTime,
    required this.tueAlarmTime,
    required this.wedAlarmTime,
    required this.thurAlarmTime,
    required this.friAlarmTime,
    required this.satAlarmTime,
    required this.sunAlarmTime,
  });

  factory KeyReportListModel.fromJson(Map<String, dynamic> json) =>
      KeyReportListModel(
        keyCode: json["KeyCode"] ??'',
        keyType: json["KeyType"]  ??'',
        keyDept: json["KeyDept"] ??'',
        concernPerson: json["ConcernPerson"] ??'',
        monIssueTime: json["MonIssueTime"] ??'',
        tueIssueTime: json["TueIssueTime"] ??'',
        wedIssueTime: json["WedIssueTime"] ??'',
        thurIssueTime: json["ThurIssueTime"] ??'',
        friIssueTime: json["FriIssueTime"] ??'',
        satIssueTime: json["SatIssueTime"] ??'',
        sunIssueTime: json["SunIssueTime"] ??'',
        monReturnTime: json["MonReturnTime"] ??'',
        tueReturnTime: json["TueReturnTime"] ??'',
        wedReturnTime: json["WedReturnTime"] ??'',
        thurReturnTime: json["ThurReturnTime"] ??'',
        friReturnTime: json["FriReturnTime"] ??'',
        satReturnTime: json["SatReturnTime"] ??'',
        sunReturnTime: json["SunReturnTime"] ??'',
        monAlarmTime: json["MonAlarmTime"] ??'',
        tueAlarmTime: json["TueAlarmTime"] ??'',
        wedAlarmTime: json["WedAlarmTime"] ??'',
        thurAlarmTime: json["ThurAlarmTime"] ??'',
        friAlarmTime: json["FriAlarmTime"] ??'',
        satAlarmTime: json["SatAlarmTime"] ??'',
        sunAlarmTime: json["SunAlarmTime"] ??'',
      );

  Map<String, dynamic> toJson() => {
        "KeyCode": keyCode,
        "KeyType": keyType,
        "KeyDept": keyDept,
        "ConcernPerson": concernPerson,
        "MonIssueTime": monIssueTime,
        "TueIssueTime": tueIssueTime,
        "WedIssueTime": wedIssueTime,
        "ThurIssueTime": thurIssueTime,
        "FriIssueTime": friIssueTime,
        "SatIssueTime": satIssueTime,
        "SunIssueTime": sunIssueTime,
        "MonReturnTime": monReturnTime,
        "TueReturnTime": tueReturnTime,
        "WedReturnTime": wedReturnTime,
        "ThurReturnTime": thurReturnTime,
        "FriReturnTime": friReturnTime,
        "SatReturnTime": satReturnTime,
        "SunReturnTime": sunReturnTime,
        "MonAlarmTime": monAlarmTime,
        "TueAlarmTime": tueAlarmTime,
        "WedAlarmTime": wedAlarmTime,
        "ThurAlarmTime": thurAlarmTime,
        "FriAlarmTime": friAlarmTime,
        "SatAlarmTime": satAlarmTime,
        "SunAlarmTime": sunAlarmTime,
      };
}
