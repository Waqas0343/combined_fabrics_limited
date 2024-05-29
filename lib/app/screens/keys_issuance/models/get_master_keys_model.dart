import 'keys_concerned_person_model.dart';

class MasterKeysModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<MasterKeysListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  MasterKeysModel({
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

  factory MasterKeysModel.fromJson(Map<String, dynamic> json) =>
      MasterKeysModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<MasterKeysListModel>.from(
            json["List"].map((x) => MasterKeysListModel.fromJson(x))),
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

class MasterKeysListModel {
  int keyId;
  String keyCode;
  String keyType;
  String keyDeptName;
  String? keyDetail;
  int keyDeptCode;
  int noOfKeys;
  List<KeyConcernedPersonListModel> keyConcernPersons;
  List<KeyTimeTable> keyTimeTable;
  List<KeyDeparment> keyDeparment;

  MasterKeysListModel({
    required this.keyId,
    required this.keyCode,
    required this.keyType,
    required this.keyDetail,
    required this.keyDeptName,
    required this.keyDeptCode,
    required this.noOfKeys,
    required this.keyConcernPersons,
    required this.keyTimeTable,
    required this.keyDeparment,
  });

  factory MasterKeysListModel.fromJson(Map<String, dynamic> json) =>
      MasterKeysListModel(
        keyId: json["KeyId"],
        keyCode: json["KeyCode"],
        keyDetail: json["KeyDetail"],
        keyType: json["KeyType"]!,
        keyDeptName: json["KeyDeptName"],
        keyDeptCode: json["KeyDeptCode"],
        noOfKeys: json["NoOfKeys"],
        keyConcernPersons: List<KeyConcernedPersonListModel>.from(
            json["KeyConcernPersons"]
                .map((x) => KeyConcernedPersonListModel.fromJson(x))),
        keyTimeTable: List<KeyTimeTable>.from(
            json["KeyTimeTable"].map((x) => KeyTimeTable.fromJson(x))),
        keyDeparment: List<KeyDeparment>.from(
            json["KeyDeparment"].map((x) => KeyDeparment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "KeyId": keyId,
        "KeyCode": keyCode,
        "KeyType": keyType,
        "KeyDetail": keyDetail,
        "KeyDeptName": keyDeptName,
        "KeyDeptCode": keyDeptCode,
        "NoOfKeys": noOfKeys,
        "KeyConcernPersons":
            List<dynamic>.from(keyConcernPersons.map((x) => x.toJson())),
        "KeyTimeTable": List<dynamic>.from(keyTimeTable.map((x) => x.toJson())),
        "KeyDeparment": List<dynamic>.from(keyDeparment.map((x) => x.toJson())),
      };
}

class KeyTimeTable {
  int? timeTableId;
  int? keyId;
  String? keyCode;
  String weekDay;
  String issueTime;
  String returnTime;
  String alarmTime;

  KeyTimeTable({
    required this.timeTableId,
    required this.keyId,
    required this.keyCode,
    required this.weekDay,
    required this.issueTime,
    required this.returnTime,
    required this.alarmTime,
  });

  factory KeyTimeTable.fromJson(Map<String, dynamic> json) => KeyTimeTable(
        timeTableId: json["TimeTableId"],
        keyId: json["KeyId"],
        keyCode: json["KeyCode"],
        weekDay: json["WeekDay"],
        issueTime: json["IssueTime"],
        returnTime: json["ReturnTime"],
        alarmTime: json["AlarmTime"],
      );

  Map<String, dynamic> toJson() => {
        "TimeTableId": timeTableId,
        "KeyId": keyId,
        "KeyCode": keyCode,
        "WeekDay": weekDay,
        "IssueTime": issueTime,
        "ReturnTime": returnTime,
        "AlarmTime": alarmTime,
      };
}

class KeyDeparment {
  int keyId;
  int deptCode;
  String deptName;
  int? subDeptId;

  KeyDeparment({
    required this.keyId,
    required this.deptCode,
    required this.deptName,
    this.subDeptId,
  });

  factory KeyDeparment.fromJson(Map<String, dynamic> json) => KeyDeparment(
        keyId: json["KeyId"],
        deptCode: json["DeptCode"],
        deptName: json["DeptName"],
        subDeptId: json["SubDeptId"],
      );

  Map<String, dynamic> toJson() => {
        "KeyId": keyId,
        "DeptCode": deptCode,
        "DeptName": deptName,
        "SubDeptId": subDeptId,
      };
}
