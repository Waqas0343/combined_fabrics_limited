class RollModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<RollsListModel> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  RollModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    required this.expiredate,
    this.data,
    required this.list,
    this.iList,
    this.totalRecords,
    this.totalPagesCount,
  });

  factory RollModel.fromJson(Map<String, dynamic> json) => RollModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<RollsListModel>.from(
            json["List"].map((x) => RollsListModel.fromJson(x))),
        iList: json["IList"],
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
        "TotalRecords": totalRecords,
        "TotalPagesCount": totalPagesCount,
      };
}

class RollsListModel {
  String rollNo;
  String? rollCat;
  double? kgs;
  double ecruKgs;
  int? issuanceNo;
  String? issuedDateTime;
  String? issuedPurpose;
  String? rollStatus;
  String? qualityStatus;
  String? rpStatus;
  String? inspectedBy;
  String? inspStatus;

  RollsListModel({
    required this.rollNo,
    required this.rollCat,
    required this.kgs,
    required this.ecruKgs,
    required this.issuedDateTime,
    this.issuanceNo,
    required this.issuedPurpose,
    required this.rollStatus,
    required this.qualityStatus,
    this.rpStatus,
    required this.inspectedBy,
    required this.inspStatus,
  });

  factory RollsListModel.fromJson(Map<String, dynamic> json) => RollsListModel(
        rollNo: json["RollNo"],
        rollCat: json["RollCat"],
        issuedDateTime: json["IssuedDateTime"],
        issuedPurpose: json["IssuedPurpose"],
        issuanceNo: json["IssuanceNo"],
        kgs: json["Kgs"]?.toDouble(),
        ecruKgs: json["EcruKgs"] != null ? (json["EcruKgs"] as num).toDouble() : 0.0,
        rollStatus: json["RollStatus"],
        qualityStatus: json["QualityStatus"],
        rpStatus: json["RPStatus"],
        inspectedBy: json["InspectedBy"],
        inspStatus: json["InspStatus"],
      );

  Map<String, dynamic> toJson() => {
        "RollNo": rollNo,
        "RollCat": rollCat,
        "IssuedDateTime": issuedDateTime,
        "IssuedPurpose": issuedPurpose,
        "IssuanceNo": issuanceNo,
        "Kgs": kgs,
        "EcruKgs": ecruKgs,
        "RollStatus": rollStatus,
        "QualityStatus": qualityStatus,
        "RPStatus": rpStatus,
        "InspectedBy": inspectedBy,
        "InspStatus": inspStatus,
      };
}
