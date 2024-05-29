class CheckWorkOrderRateModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<CheckWorkOrderRateListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  CheckWorkOrderRateModel({
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

  factory CheckWorkOrderRateModel.fromJson(Map<String, dynamic> json) => CheckWorkOrderRateModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<CheckWorkOrderRateListModel>.from(json["Lists"].map((x) => CheckWorkOrderRateListModel.fromJson(x))),
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

class CheckWorkOrderRateListModel {
  double pkAutono;
  String woDetails;
  String operationname;
  double rate;
  double gRate;
  String status;
  double deptCode;
  double headcode;
  String headname;
  String department;
  String active;
  String desce;
  String remarks;
  double opsequence;
  double oppcs;
  double opsamminutes;
  String machinetype;
  double? threads;
  double samrate;
  String operationType;

  CheckWorkOrderRateListModel({
    required this.pkAutono,
    required this.woDetails,
    required this.operationname,
    required this.rate,
    required this.gRate,
    required this.status,
    required this.deptCode,
    required this.headcode,
    required this.headname,
    required this.department,
    required this.active,
    required this.desce,
    required this.remarks,
    required this.opsequence,
    required this.oppcs,
    required this.opsamminutes,
    required this.machinetype,
    required this.threads,
    required this.samrate,
    required this.operationType,
  });

  factory CheckWorkOrderRateListModel.fromJson(Map<String, dynamic> json) => CheckWorkOrderRateListModel(
    pkAutono: json["Pk_autono"],
    woDetails: json["wo_details"],
    operationname: json["operationname"],
    rate: json["rate"]?.toDouble(),
    gRate: json["g_rate"],
    status:json["status"],
    deptCode: json["dept_code"],
    headcode: json["headcode"],
    headname: json["headname"],
    department: json["department"],
    active: json["Active"],
    desce: json["desce"],
    remarks: json["remarks"],
    opsequence: json["opsequence"],
    oppcs: json["oppcs"],
    opsamminutes: json["opsamminutes"]?.toDouble(),
    machinetype: json["machinetype"],
    threads: json["threads"],
    samrate: json["samrate"],
    operationType: json["OperationType"],
  );

  Map<String, dynamic> toJson() => {
    "Pk_autono": pkAutono,
    "wo_details": woDetails,
    "operationname": operationname,
    "rate": rate,
    "g_rate": gRate,
    "status": status,
    "dept_code": deptCode,
    "headcode": headcode,
    "headname": headname,
    "department": department,
    "Active": active,
    "desce": desce,
    "remarks": remarks,
    "opsequence": opsequence,
    "oppcs": oppcs,
    "opsamminutes": opsamminutes,
    "machinetype": machinetype,
    "threads": threads,
    "samrate": samrate,
    "OperationType": operationType,
  };
}