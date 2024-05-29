class PatientModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<PatientListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  PatientModel({
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

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<PatientListModel>.from(
            json["List"].map((x) => PatientListModel.fromJson(x))),
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

class PatientListModel {
  int issuanceNo;
  String date;
  int patientCardNo;
  String patiantName;
  String? deptName;
  String diagnosis;
  String diagnosisBy;
  List<PatientMedicineModel> medicine;

  PatientListModel({
    required this.issuanceNo,
    required this.date,
    required this.patientCardNo,
    required this.patiantName,
    required this.deptName,
    required this.diagnosis,
    required this.diagnosisBy,
    required this.medicine,
  });

  factory PatientListModel.fromJson(Map<String, dynamic> json) =>
      PatientListModel(
        issuanceNo: json["IssuanceNo"],
        date: json["Date"],
        patientCardNo: json["PatientCardNo"] ?? 0,
        patiantName: json["PatiantName"] ?? "",
        deptName: json["DeptName"],
        diagnosis: json["Diagnosis"],
        diagnosisBy: json["DiagnosisBy"],
        medicine: List<PatientMedicineModel>.from(
            json["Medicine"].map((x) => PatientMedicineModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "IssuanceNo": issuanceNo,
        "Date": date,
        "PatientCardNo": patientCardNo,
        "PatiantName": patiantName,
        "DeptName": deptName,
        "Diagnosis": diagnosis,
        "DiagnosisBy": diagnosisBy,
        "Medicine": List<dynamic>.from(medicine.map((x) => x.toJson())),
      };
}

class PatientMedicineModel {
  int medicineSerial;
  String medicineCode;
  String medicine;
  int qty;
  String? unit;

  PatientMedicineModel({
    required this.medicineSerial,
    required this.medicineCode,
    required this.medicine,
    required this.qty,
    this.unit,
  });

  factory PatientMedicineModel.fromJson(Map<String, dynamic> json) =>
      PatientMedicineModel(
        medicineSerial: json["MedicineSerial"],
        medicineCode: json["MedicineCode"],
        medicine: json["Medicine"],
        qty: (json["Qty"] as num).toInt(),
        unit: json["Unit"],
      );

  Map<String, dynamic> toJson() => {
        "MedicineSerial": medicineSerial,
        "MedicineCode": medicineCode,
        "Medicine": medicine,
        "Qty": qty,
        "Unit": unit,
      };
}
