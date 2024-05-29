class InLineStatusReportModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<InLineStatusReportListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  InLineStatusReportModel({
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

  factory InLineStatusReportModel.fromJson(Map<String, dynamic> json) => InLineStatusReportModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<InLineStatusReportListModel>.from(json["List"].map((x) => InLineStatusReportListModel.fromJson(x))),
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

class InLineStatusReportListModel {
  String woOrders;
  int lineNo;
  String machineCode;
  String operationname;
  String empOperatorCode;
  String transactionDate;
  String r1FlagName;
  String r1ColorHexCode;
  String r1Hlfclr;
  String round1Faultccount;
  String r2FlagName;
  String r2ColorHexCode;
  String round2Faultccount;
  String r2Hlfclr;
  String r3FlagName;
  String r3ColorHexCode;
  String round3Faultccount;
  String r3Hlfclr;
  String r4FlagName;
  String r4ColorHexCode;
  String round4Faultccount;
  String r4Hlfclr;
  String r5FlagName;
  String r5ColorHexCode;
  String round5Faultccount;
  String r5Hlfclr;
  String r6FlagName;
  String r6ColorHexCode;
  String round6Faultccount;
  String r6Hlfclr;
  String flagDate;
  int opsequence;
  int skillLevel;
  String breakRange;
  String r1FlgDrtn;
  String r2FlgDrtn;
  String r3FlgDrtn;
  String r4FlgDrtn;
  double inspectgarmets;
  String dhuRoundwise;
  int prodpcs;

  InLineStatusReportListModel({
    required this.woOrders,
    required this.lineNo,
    required this.machineCode,
    required this.operationname,
    required this.empOperatorCode,
    required this.transactionDate,
    required this.r1FlagName,
    required this.r1ColorHexCode,
    required this.round1Faultccount,
    required this.r1Hlfclr,
    required this.r2FlagName,
    required this.r2ColorHexCode,
    required this.round2Faultccount,
    required this.r2Hlfclr,
    required this.r3FlagName,
    required this.r3ColorHexCode,
    required this.round3Faultccount,
    required this.r3Hlfclr,
    required this.r4FlagName,
    required this.r4ColorHexCode,
    required this.round4Faultccount,
    required this.r4Hlfclr,
    required this.r5FlagName,
    required this.r5ColorHexCode,
    required this.round5Faultccount,
    required this.r5Hlfclr,
    required this.r6FlagName,
    required this.r6ColorHexCode,
    required this.round6Faultccount,
    required this.r6Hlfclr,
    required this.flagDate,
    required this.opsequence,
    required this.skillLevel,
    required this.breakRange,
    required this.r1FlgDrtn,
    required this.r2FlgDrtn,
    required this.r3FlgDrtn,
    required this.r4FlgDrtn,
    required this.dhuRoundwise,
    required this.inspectgarmets,
    required this.prodpcs,
  });

  factory InLineStatusReportListModel.fromJson(Map<String, dynamic> json) => InLineStatusReportListModel(
    woOrders: json["Wo_orders"],
    lineNo: json["Line_No"],
    machineCode: json["Machine_Code"],
    operationname: json["operationname"],
    empOperatorCode: json["EMP_Operator_Code"],
    transactionDate: json["Transaction_Date"],
    r1FlagName: json["R1Flag_name"],
    r1ColorHexCode: json["R1ColorHEX_Code"],
    round1Faultccount: json["Round1faultccount"],
    r1Hlfclr: json["R1Hlfclr"] ?? " ",
    r2FlagName:json["R2Flag_name"],
    r2ColorHexCode: json["R2ColorHEX_Code"],
    round2Faultccount: json["Round2faultccount"],
    r2Hlfclr: json["R2Hlfclr"]  ?? " ",
    r3FlagName:json["R3flag_Name"],
    r3ColorHexCode: json["R3ColorHEX_Code"],
    round3Faultccount: json["Round3faultccount"],
    r3Hlfclr: json["R3Hlfclr"]  ?? " ",
    r4FlagName: json["R4flag_Name"],
    r4ColorHexCode: json["R4ColorHEX_Code"],
    round4Faultccount: json["Round4faultccount"],
    r4Hlfclr: json["R4Hlfclr"]  ?? " ",
    r5FlagName: json["R5flag_Name"],
    r5ColorHexCode: json["R5ColorHEX_Code"],
    round5Faultccount: json["Round5faultccount"],
    r5Hlfclr: json["R5Hlfclr"]  ?? " ",
    r6FlagName: json["R6flag_Name"],
    r6ColorHexCode: json["R6ColorHEX_Code"],
    round6Faultccount: json["Round6faultccount"],
    r6Hlfclr: json["R6Hlfclr"]  ?? " ",
    flagDate: json["FlagDate"],
    opsequence: json["opsequence"],
    skillLevel: json["SkillLevel"],
    breakRange: json["BreakRange"] ?? '',
    r1FlgDrtn: json["R1flgDrtn"],
    r2FlgDrtn: json["R2flgDrtn"],
    r3FlgDrtn: json["R3flgDrtn"],
    r4FlgDrtn: json["R4flgDrtn"],
    dhuRoundwise: json["DHU_Roundwise"],
      inspectgarmets: json["inspectgarmets"],
      prodpcs: json["prodpcs"]
  );

  Map<String, dynamic> toJson() => {
    "Wo_orders": woOrders,
    "Line_No": lineNo,
    "Machine_Code": machineCode,
    "operationname": operationname,
    "EMP_Operator_Code": empOperatorCode,
    "Transaction_Date": transactionDate,
    "R1Flag_name": r1FlagName,
    "R1ColorHEX_Code": r1ColorHexCode,
    "Round1faultccount": round1Faultccount,
    "R1Hlfclr": r1Hlfclr,
    "R2Flag_name": r2FlagName,
    "R2ColorHEX_Code": r2ColorHexCode,
    "Round2faultccount": round2Faultccount,
    "R2Hlfclr": r2Hlfclr,
    "R3flag_Name": r3FlagName,
    "R3ColorHEX_Code": r3ColorHexCode,
    "Round3faultccount": round3Faultccount,
    "R3Hlfclr": r3Hlfclr,
    "R4flag_Name": r4FlagName,
    "R4ColorHEX_Code": r4ColorHexCode,
    "Round4faultccount": round4Faultccount,
    "R4Hlfclr": r4Hlfclr,
    "R5flag_Name": r5FlagName,
    "R5ColorHEX_Code": r5ColorHexCode,
    "Round5faultccount": round5Faultccount,
    "R5Hlfclr": r5Hlfclr,
    "R6flag_Name": r6FlagName,
    "R6ColorHEX_Code": r6ColorHexCode,
    "Round6faultccount": round6Faultccount,
    "R6Hlfclr": r6Hlfclr,
    "FlagDate": flagDate,
    "opsequence": opsequence,
    "SkillLevel": skillLevel,
    "BreakRange": breakRange,
    "R1flgDrtn": r1FlgDrtn,
    "R2flgDrtn":r2FlgDrtn,
    "R3flgDrtn": r3FlgDrtn,
    "R4flgDrtn": r4FlgDrtn,
    "DHU_Roundwise": dhuRoundwise,
    "inspectgarmets": inspectgarmets,
    "prodpcs": prodpcs,
  };

}

