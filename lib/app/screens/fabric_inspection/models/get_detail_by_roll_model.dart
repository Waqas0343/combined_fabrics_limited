class RollDetailModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  RollDetailModelData data;
  dynamic list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  RollDetailModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    this.expiredate,
    required this.data,
    this.list,
    this.iList,
    this.totalRecords,
    this.totalPagesCount,
  });

  factory RollDetailModel.fromJson(Map<String, dynamic> json) => RollDetailModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: RollDetailModelData.fromJson(json["Data"]),
    list: json["List"],
    iList: json["IList"],
    totalRecords: json["TotalRecords"],
    totalPagesCount: json["TotalPagesCount"],
  );
}

class RollDetailModelData {
  dynamic rollNo;
  String rollCategory;
  dynamic workOrderNo;
  dynamic lotNo;
  dynamic color;
  dynamic fabric;
  double minWidth;
  double maxWidth;
  int gsm;
  String inspectionShift;
  int inspectedByCode;
  String inspectionTableNo;
  String qualityStatus;
  String rollMarkingStatus;
  String userId;
  double meter;
  double weight;
  dynamic elongation;
  dynamic remarks;
  dynamic startTime;
  dynamic endTime;
  dynamic rpStatus;

  RollDetailModelData({
    this.rollNo,
    required this.rollCategory,
    this.workOrderNo,
    this.lotNo,
    this.color,
    this.fabric,
    required this.minWidth,
    required this.maxWidth,
    required this.gsm,
    required this.inspectionShift,
    required this.inspectedByCode,
    required this.inspectionTableNo,
    required this.qualityStatus,
    required this.rollMarkingStatus,
    required this.userId,
    required this.meter,
    required this.weight,
    this.elongation,
    this.remarks,
    this.startTime,
    this.endTime,
    this.rpStatus,
  });

  factory RollDetailModelData.fromJson(Map<String, dynamic> json) => RollDetailModelData(
    rollNo: json["RollNo"] ?? '',
    rollCategory: json["RollCategory"] ?? '',
    workOrderNo: json["WorkOrderNo"] ?? '',
    lotNo: json["LotNo"] ?? '',
    color: json["Color"] ?? '',
    fabric: json["Fabric"] ?? '',
    minWidth: (json["MinWidth"] as num?)?.toDouble() ?? 0.0,
    maxWidth: (json["MaxWidth"] as num?)?.toDouble() ?? 0.0,
    gsm: json["Gsm"] ?? 0,
    inspectionShift: json["InspectionShift"] ?? '',
    inspectedByCode: json["InspectedByCode"] ?? '',
    inspectionTableNo: json["InspectionTableNo"] ?? '',
    qualityStatus: json["QualityStatus"] ?? '',
    rollMarkingStatus: json["RollMarkingStatus"] ?? '',
    userId: json["UserId"] ?? '',
    meter: (json["Meter"] as num?)?.toDouble() ?? 0.0,
    weight: (json["Weight"] as num?)?.toDouble() ?? 0.0,
    elongation: json["Elongation"] ?? '',
    remarks: json["Remarks"] ?? '',
    startTime: json["StartTime"] ?? '',
    endTime: json["EndTime"] ?? '',
    rpStatus: json["RpStatus"] ?? '',
  );

}
