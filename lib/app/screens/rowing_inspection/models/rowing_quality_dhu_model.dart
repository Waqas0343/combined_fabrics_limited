class RowingQualityDHUModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<RowingQualityDHUListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  RowingQualityDHUModel({
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

  factory RowingQualityDHUModel.fromJson(Map<String, dynamic> json) => RowingQualityDHUModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<RowingQualityDHUListModel>.from(json["Lists"].map((x) => RowingQualityDHUListModel.fromJson(x))),
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

class RowingQualityDHUListModel {
  int line;
  DateTime elTransactionDate;
  DateTime qmTransactionDate;
  String woNumber;
  int elBundleNo;
  int qmBundleNo;
  int elBundleQty;
  int qmBundleQty;
  String elEmpid;
  String qmEmpid;
  String elInspectorName;
  String qmInspectorName;
  int elInspGarmentNo;
  int qmInspGarmentNo;
  int elFaultpcs;
  int qmFaultpcs;
  int elStichfaultpc;
  int qmStichfaultpc;
  int elOtherfaultpc;
  int qmOtherfaultpc;
  double elStichDhu;
  double qmStichDhu;
  double elOtherstchDhu;
  double qmOtherstchDhu;
  DateTime lastproducetime;
  int propcs;
  RowingQualityDHUListModel({
    required this.line,
    required this.elTransactionDate,
    required this.qmTransactionDate,
    required this.woNumber,
    required this.elBundleNo,
    required this.qmBundleNo,
    required this.elBundleQty,
    required this.qmBundleQty,
    required this.elEmpid,
    required this.qmEmpid,
    required this.elInspectorName,
    required this.qmInspectorName,
    required this.elInspGarmentNo,
    required this.qmInspGarmentNo,
    required this.elFaultpcs,
    required this.qmFaultpcs,
    required this.elStichfaultpc,
    required this.qmStichfaultpc,
    required this.elOtherfaultpc,
    required this.qmOtherfaultpc,
    required this.elStichDhu,
    required this.qmStichDhu,
    required this.elOtherstchDhu,
    required this.qmOtherstchDhu,
    required this.lastproducetime,
    required this.propcs,

  });

  factory RowingQualityDHUListModel.fromJson(Map<String, dynamic> json) => RowingQualityDHUListModel(
    line: json["Line"],
       qmTransactionDate : json["QM_Transaction_Date"] != null ? DateTime.parse(json["QM_Transaction_Date"]!) : DateTime.now(),
    elTransactionDate: json["EL_Transaction_Date"] != null ? DateTime.parse(json["EL_Transaction_Date"]!) : DateTime.now(),
    woNumber: json["WO_Number"],
    elBundleNo: json["EL_BundleNo"] ?? 0,
    qmBundleNo: json["QM_BundleNo"]??0,
    elBundleQty: json["EL_BundleQty"] ??0,
    qmBundleQty: json["QM_BundleQty"]??0,
    elEmpid: json["EL_Empid"] ?? '',
    qmEmpid: json["QM_Empid"] ??'',
    elInspectorName: json["EL_inspectorName"] ?? '',
    qmInspectorName: json["QM_inspectorName"] ??'',
    elInspGarmentNo: json["EL_InspGarmentNo"] ?? 0,
    qmInspGarmentNo: json["QM_InspGarmentNo"] ?? 0,
    elFaultpcs: json["EL_faultpcs"] ?? 0,
    qmFaultpcs: json["QM_faultpcs"]??0,
    elStichfaultpc: json["EL_Stichfaultpc"] ?? 0,
    qmStichfaultpc: json["QM_Stichfaultpc"]??0,
    elOtherfaultpc: json["EL_otherfaultpc"] ?? 0,
    qmOtherfaultpc: json["QM_otherfaultpc"] ??0,
    elStichDhu: json["EL_StichDHU"]?? 0.0,
    qmStichDhu:json["QM_StichDHU"] != null
        ? json["QM_StichDHU"]!.toDouble()
        : 0.0,
    elOtherstchDhu: json["EL_OtherstchDHU"] ?? 0,
    qmOtherstchDhu: json["QM_OtherstchDHU"]!= null
        ? json["QM_OtherstchDHU"]!.toDouble()
        : 0.0,
    lastproducetime: DateTime.parse(json["lastproducetime"]),
    propcs: json["propcs"] ?? 0,

  );

  Map<String, dynamic> toJson() => {
    "Line": line,
    "EL_Transaction_Date": elTransactionDate.toIso8601String(),
    "QM_Transaction_Date": qmTransactionDate.toIso8601String(),
    "WO_Number": woNumber,
    "EL_BundleNo": elBundleNo,
    "QM_BundleNo": qmBundleNo,
    "EL_BundleQty": elBundleQty,
    "QM_BundleQty": qmBundleQty,
    "EL_Empid": elEmpid,
    "QM_Empid": qmEmpid,
    "EL_inspectorName": elInspectorName,
    "QM_inspectorName": qmInspectorName,
    "EL_InspGarmentNo": elInspGarmentNo,
    "QM_InspGarmentNo": qmInspGarmentNo,
    "EL_faultpcs": elFaultpcs,
    "QM_faultpcs": qmFaultpcs,
    "EL_Stichfaultpc": elStichfaultpc,
    "QM_Stichfaultpc": qmStichfaultpc,
    "EL_otherfaultpc": elOtherfaultpc,
    "QM_otherfaultpc": qmOtherfaultpc,
    "EL_StichDHU": elStichDhu,
    "QM_StichDHU": qmStichDhu,
    "EL_OtherstchDHU": elOtherstchDhu,
    "QM_OtherstchDHU": qmOtherstchDhu,
    "lastproducetime": lastproducetime.toIso8601String(),
    "propcs": propcs,
  };
}
