class DiseaseModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<DiseaseListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  DiseaseModel({
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

  factory DiseaseModel.fromJson(Map<String, dynamic> json) => DiseaseModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<DiseaseListModel>.from(json["List"].map((x) => DiseaseListModel.fromJson(x))),
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

class DiseaseListModel {
  int diseaseId;
  String diseaseName;

  DiseaseListModel({
    required this.diseaseId,
    required this.diseaseName,
  });

  factory DiseaseListModel.fromJson(Map<String, dynamic> json) => DiseaseListModel(
    diseaseId: json["DiseaseId"],
    diseaseName: json["DiseaseName"],
  );

  Map<String, dynamic> toJson() => {
    "DiseaseId": diseaseId,
    "DiseaseName": diseaseName,
  };
}
