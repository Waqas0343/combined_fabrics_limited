class RowingQualityEmployeeStitchPcsModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RowingQualityEmployeeStitchPcsListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityEmployeeStitchPcsModel({
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
    required this.returnData,
  });

  factory RowingQualityEmployeeStitchPcsModel.fromJson(
          Map<String, dynamic> json) =>
      RowingQualityEmployeeStitchPcsModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<RowingQualityEmployeeStitchPcsListModel>.from(json["List"]
            .map((x) => RowingQualityEmployeeStitchPcsListModel.fromJson(x))),
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
        "List": List<dynamic>.from(list.map((x) => x.toJson())),
        "IList": iList,
        "IEList": ieList,
        "TotalRecords": totalRecords,
        "TotalPagesCount": totalPagesCount,
        "ReturnData": returnData,
      };
}

class RowingQualityEmployeeStitchPcsListModel {
  String workorder;
  int stichpcs;
  DateTime tRansdate;
  String machineName;
  int workerId;
  String oprationName;
  String operationId;
  String lineNo;
  int opsequence;
  String? r1Color;
  String? r1Datetime;
  String? r2Color;
  String r2Datetime;
  String? r3Color;
  String r3Datetime;
  String? r4Color;
  String r4Datetime;
  String r5Color;
  String r5Datetime;
  int wip;

  RowingQualityEmployeeStitchPcsListModel({
    required this.workorder,
    required this.stichpcs,
    required this.tRansdate,
    required this.machineName,
    required this.workerId,
    required this.oprationName,
    required this.operationId,
    required this.lineNo,
    required this.opsequence,
    required this.r1Color,
    required this.r1Datetime,
    required this.r2Color,
    required this.r2Datetime,
    required this.r3Color,
    required this.r3Datetime,
    required this.r4Color,
    required this.r4Datetime,
    required this.r5Color,
    required this.r5Datetime,
    required this.wip,
  });

  factory RowingQualityEmployeeStitchPcsListModel.fromJson(
          Map<String, dynamic> json) =>
      RowingQualityEmployeeStitchPcsListModel(
        workorder: json["Workorder"],
        stichpcs: json["stichpcs"],
        tRansdate: DateTime.parse(json["TRansdate"]),
        machineName: json["machineName"],
        workerId: json["WorkerID"],
        oprationName: json["oprationName"],
        operationId:
            json["operationID"] != null ? json["operationID"].toString() : "",
        lineNo: json["line_No"],
        opsequence: json["opsequence"],
        r1Color: json["R1Color"] ?? '',
        r1Datetime: json["R1datetime"],
        r2Color: json["R2Color"] ?? '',
        r2Datetime: json["R2datetime"] ?? '',
        r3Color: json["R3Color"] ?? '',
        r3Datetime: json["R3datetime"] ?? '',
        r4Color: json["R4Color"]  ?? '',
        r4Datetime: json["R4datetime"] ?? '',
        r5Color: json["R5Color"] ?? '',
        r5Datetime: json["R5datetime"] ?? '',
        wip: json["Wip"],
      );

  Map<String, dynamic> toJson() => {
        "Workorder": workorder,
        "stichpcs": stichpcs,
        "TRansdate": tRansdate.toIso8601String(),
        "machineName": machineName,
        "WorkerID": workerId,
        "oprationName": oprationName,
        "operationID": operationId,
        "line_No": lineNo,
        "opsequence": opsequence,
        "R1Color": r1Color,
        "R1datetime": r1Datetime,
        "R2Color": r2Color,
        "R2datetime": r2Datetime,
        "R3Color": r3Color,
        "R3datetime": r3Datetime,
        "R4Color": r4Color,
        "R4datetime": r4Datetime,
        "R5Color": r5Color,
        "R5datetime": r5Datetime,
        "Wip": wip,
      };
}
