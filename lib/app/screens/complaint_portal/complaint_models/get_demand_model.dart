class DemandModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<DemandListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  DemandModel({
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

  factory DemandModel.fromJson(Map<String, dynamic> json) => DemandModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<DemandListModel>.from(json["List"].map((x) => DemandListModel.fromJson(x))),
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

class DemandListModel {
  int demandNo;
  int srNo;
  String demandDate;
  String item;
  String unit;
  String stock;
  String demandQty;
  String pr;
  String prDate;
  String po;
  String poDate;
  String poQty;
  String igp;
  String igpDate;
  String igpQty;
  String grn;
  String grnDate;
  String grnQty;
  String issueNo;
  int issued;

  DemandListModel({
    required this.demandNo,
    required this.srNo,
    required this.demandDate,
    required this.item,
    required this.unit,
    required this.stock,
    required this.demandQty,
    required this.pr,
    required this.prDate,
    required this.po,
    required this.poDate,
    required this.poQty,
    required this.igp,
    required this.igpDate,
    required this.igpQty,
    required this.grn,
    required this.grnDate,
    required this.grnQty,
    required this.issueNo,
    required this.issued,
  });

  factory DemandListModel.fromJson(Map<String, dynamic> json) => DemandListModel(
    demandNo: json["DemandNo"],
    srNo: json["SrNo"],
    demandDate: json["DemandDate"],
    item: json["Item"],
    unit: json["Unit"],
    stock: json["Stock"],
    demandQty: json["DemandQty"],
    pr: json["Pr"],
    prDate: json["PrDate"],
    po: json["Po"],
    poDate: json["PoDate"],
    poQty: json["PoQty"],
    igp: json["IGP"],
    igpDate: json["IGPDate"],
    igpQty: json["IGPQty"],
    grn: json["GRN"],
    grnDate: json["GRNDate"],
    grnQty: json["GRNQty"],
    issueNo: json["IssueNo"],
    issued: json["Issued"],
  );

  Map<String, dynamic> toJson() => {
    "DemandNo": demandNo,
    "SrNo": srNo,
    "DemandDate": demandDate,
    "Item": item,
    "Unit": unit,
    "Stock": stock,
    "DemandQty": demandQty,
    "Pr": pr,
    "PrDate": prDate,
    "Po": po,
    "PoDate": poDate,
    "PoQty": poQty,
    "IGP": igp,
    "IGPDate": igpDate,
    "IGPQty": igpQty,
    "GRN": grn,
    "GRNDate": grnDate,
    "GRNQty": grnQty,
    "IssueNo": issueNo,
    "Issued": issued,
  };
}
