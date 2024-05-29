class FirstAidBoxMedicineIssuanceModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<FirstAidBoxMedicineIssuanceListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  FirstAidBoxMedicineIssuanceModel({
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

  factory FirstAidBoxMedicineIssuanceModel.fromJson(Map<String, dynamic> json) => FirstAidBoxMedicineIssuanceModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<FirstAidBoxMedicineIssuanceListModel>.from(json["List"].map((x) => FirstAidBoxMedicineIssuanceListModel.fromJson(x))),
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

class FirstAidBoxMedicineIssuanceListModel {
  int issuanceNo;
  String date;
  int? patientCardNo;
  dynamic patiantName;
  dynamic deptName;
  String diagnosis;
  String diagnosisBy;
  String purpose;
  List<FirstAidMedicineList> medicine;

  FirstAidBoxMedicineIssuanceListModel({
    required this.issuanceNo,
    required this.date,
    required this.patientCardNo,
    required this.patiantName,
    required this.deptName,
    required this.diagnosis,
    required this.diagnosisBy,
    required this.purpose,
    required this.medicine,
  });

  factory FirstAidBoxMedicineIssuanceListModel.fromJson(Map<String, dynamic> json) => FirstAidBoxMedicineIssuanceListModel(
    issuanceNo: json["IssuanceNo"],
    date: json["Date"],
    patientCardNo: json["PatientCardNo"],
    patiantName: json["PatiantName"],
    deptName: json["DeptName"],
    diagnosis: json["Diagnosis"],
    diagnosisBy: json["DiagnosisBy"],
    purpose: json["Purpose"],
    medicine: List<FirstAidMedicineList>.from(json["Medicine"].map((x) => FirstAidMedicineList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "IssuanceNo": issuanceNo,
    "Date": date,
    "PatientCardNo": patientCardNo,
    "PatiantName": patiantName,
    "DeptName": deptName,
    "Diagnosis": diagnosis,
    "DiagnosisBy": diagnosisBy,
    "Purpose": purpose,
    "Medicine": List<dynamic>.from(medicine.map((x) => x.toJson())),
  };
}

class FirstAidMedicineList {
  int medicineSerial;
  String medicineCode;
  String medicine;
  double qty;
  String unit;

  FirstAidMedicineList({
    required this.medicineSerial,
    required this.medicineCode,
    required this.medicine,
    required this.qty,
    required this.unit,
  });

  factory FirstAidMedicineList.fromJson(Map<String, dynamic> json) => FirstAidMedicineList(
    medicineSerial: json["MedicineSerial"],
    medicineCode: json["MedicineCode"],
    medicine: json["Medicine"],
    qty: json["Qty"] ?? 0.0,
    unit: json["Unit"]!,
  );

  Map<String, dynamic> toJson() => {
    "MedicineSerial": medicineSerial,
    "MedicineCode": medicineCode,
    "Medicine": medicine,
    "Qty": qty,
    "Unit": unit,
  };
}


