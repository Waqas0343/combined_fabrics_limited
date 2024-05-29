class LotDetailModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<LotDetailModelList> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  LotDetailModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    this.expiredate,
    this.data,
    required this.list,
    this.iList,
    this.totalRecords,
    this.totalPagesCount,
  });

  factory LotDetailModel.fromJson(Map<String, dynamic> json) => LotDetailModel(
        message: json["Message"],
        status: json["Status"],
        statusCode: json["StatusCode"],
        errors: json["Errors"],
        expiredate: json["Expiredate"],
        data: json["Data"],
        list: List<LotDetailModelList>.from(
            json["List"].map((x) => LotDetailModelList.fromJson(x))),
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

class LotDetailModelList {
  String workOrderNo;
  String lotNo;
  String color;
  String fabric;
  String diaGg;
  String kgs;
  String ecruKgs;
  int rolls;
  String rpStatus;

  LotDetailModelList({
    required this.workOrderNo,
    required this.lotNo,
    required this.color,
    required this.fabric,
    required this.diaGg,
    required this.kgs,
    required this.ecruKgs,
    required this.rolls,
    required this.rpStatus,
  });

  factory LotDetailModelList.fromJson(Map<String, dynamic> json) =>
      LotDetailModelList(
        workOrderNo: json["WorkOrderNo"],
        lotNo: json["LotNo"],
        color: json["Color"],
        fabric: json["Fabric"],
        diaGg: json["DiaGG"],
        kgs: json["Kgs"],
        ecruKgs: json["EcruKgs"],
        rolls: json["Rolls"],
        rpStatus: json["RPStatus"] ??" ",
      );

  Map<String, dynamic> toJson() => {
        "WorkOrderNo": workOrderNo,
        "LotNo": lotNo,
        "Color": color,
        "Fabric": fabric,
        "DiaGG": diaGg,
        "Kgs": kgs,
        "EcruKgs": ecruKgs,
        "Rolls": rolls,
        "RPStatus": rpStatus,
      };
}
