class ComplaintRemarksModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<ComplaintRemarkListModel> list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  ComplaintRemarksModel({
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

  factory ComplaintRemarksModel.fromJson(Map<String, dynamic> json) => ComplaintRemarksModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<ComplaintRemarkListModel>.from(json["List"].map((x) => ComplaintRemarkListModel.fromJson(x))),
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

class ComplaintRemarkListModel {
  int complainId;
  int remarksId;
  int imageId;
  String remarksByUserId;
  String remarks;
  String remarksDateTime;
  dynamic imagePath;
  dynamic imageFileName;

  ComplaintRemarkListModel({
    required this.complainId,
    required this.remarksId,
    required this.imageId,
    required this.remarksByUserId,
    required this.remarks,
    required this.remarksDateTime,
    this.imagePath,
    this.imageFileName,
  });

  factory ComplaintRemarkListModel.fromJson(Map<String, dynamic> json) => ComplaintRemarkListModel(
    complainId: json["ComplainId"],
    remarksId: json["RemarksId"],
    imageId: json["ImageId"],
    remarksByUserId: json["RemarksByUserId"],
    remarks: json["Remarks"],
    remarksDateTime: json["RemarksDateTime"],
    imagePath: json["ImagePath"],
    imageFileName: json["ImageFileName"],
  );

  Map<String, dynamic> toJson() => {
    "ComplainId": complainId,
    "RemarksId": remarksId,
    "ImageId": imageId,
    "RemarksByUserId": remarksByUserId,
    "Remarks": remarks,
    "RemarksDateTime": remarksDateTime,
    "ImagePath": imagePath,
    "ImageFileName": imageFileName,
  };
}
