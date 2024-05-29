class KeysModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  KeyDashBoardModel data;
  dynamic list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  KeysModel({
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

  factory KeysModel.fromJson(Map<String, dynamic> json) => KeysModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: KeyDashBoardModel.fromJson(json["Data"]),
    list: json["List"],
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
    "Data": data.toJson(),
    "List": list,
    "IList": iList,
    "IEList": ieList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
  };
}

class KeyDashBoardModel {
  int totalKey;
  int keyOut;
  int keyIn;
  List<KeysListModel> keysData;

  KeyDashBoardModel({
    required this.totalKey,
    required this.keyOut,
    required this.keyIn,
    required this.keysData,
  });

  factory KeyDashBoardModel.fromJson(Map<String, dynamic> json) => KeyDashBoardModel(
    totalKey: json["TotalKey"],
    keyOut: json["KeyOut"],
    keyIn: json["KeyIN"],
    keysData: List<KeysListModel>.from(json["KeysData"].map((x) => KeysListModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "TotalKey": totalKey,
    "KeyOut": keyOut,
    "KeyIN": keyIn,
    "KeysData": List<dynamic>.from(keysData.map((x) => x.toJson())),
  };
}

class KeysListModel {
  String keyCode;
  String keyType;
  String keyDept;
  String keyStatus;
  List<KeysDetail> keysDetails;

  KeysListModel({
    required this.keyCode,
    required this.keyType,
    required this.keyDept,
    required this.keyStatus,
    required this.keysDetails,
  });

  factory KeysListModel.fromJson(Map<String, dynamic> json) => KeysListModel(
    keyCode: json["KeyCode"],
    keyType: json["KeyType"],
    keyDept: json["KeyDept"],
    keyStatus: json["KeyStatus"],
    keysDetails: List<KeysDetail>.from(json["KeysDetails"].map((x) => KeysDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "KeyCode": keyCode,
    "KeyType": keyType,
    "KeyDept": keyDept,
    "KeyStatus": keyStatus,
    "KeysDetails": List<dynamic>.from(keysDetails.map((x) => x.toJson())),
  };
}

class KeysDetail {
  String entryDate;
  int keyIssueCardNo;
  String keyIssueTo;
  String keyIssueDate;
  int? keyReturnCardNo;
  String? keyReturnBy;
  String? keyReturnDate;
  String? status;
  String remarks;
  bool isActive;

  KeysDetail({
    required this.entryDate,
    required this.keyIssueCardNo,
    required this.keyIssueTo,
    required this.keyIssueDate,
    required this.keyReturnCardNo,
    required this.keyReturnBy,
    required this.keyReturnDate,
    required this.status,
    required this.remarks,
    required this.isActive,
  });

  factory KeysDetail.fromJson(Map<String, dynamic> json) => KeysDetail(
    entryDate: json["EntryDate"],
    keyIssueCardNo: json["KeyIssueCardNo"],
    keyIssueTo: json["KeyIssueTo"] ?? '',
    keyIssueDate:  json["KeyIssueDate"] ?? "",
    keyReturnCardNo: json["KeyReturnCardNo"],
    keyReturnBy: json["KeyReturnBy"],
    keyReturnDate: json["KeyReturnDate"],
    status: json["Status"],
    remarks: json["Remarks"],
    isActive: json["IsActive"],
  );

  Map<String, dynamic> toJson() => {
    "EntryDate": entryDate,
    "KeyIssueCardNo": keyIssueCardNo,
    "KeyIssueTo": keyIssueTo,
    "KeyIssueDate": keyIssueDate,
    "KeyReturnCardNo": keyReturnCardNo,
    "KeyReturnBy": keyReturnBy,
    "KeyReturnDate": keyReturnDate,
    "Status": status,
    "Remarks": remarks,
    "IsActive": isActive,
  };
}
