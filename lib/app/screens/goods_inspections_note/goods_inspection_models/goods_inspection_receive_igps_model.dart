class ReceiveIGPModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<ReceiveIGPListModel> list;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  ReceiveIGPModel({
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

  factory ReceiveIGPModel.fromJson(Map<String, dynamic> json) => ReceiveIGPModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<ReceiveIGPListModel>.from(json["List"].map((x) => ReceiveIGPListModel.fromJson(x))),
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

class ReceiveIGPListModel {
  String date;
  int igpNo;
  dynamic receivingStatus;
  dynamic receivedBy;
  dynamic receivingDate;
  DateTime filterDate;

  ReceiveIGPListModel({
    required this.date,
    required this.igpNo,
    required this.receivingStatus,
    required this.receivedBy,
    required this.receivingDate,
    required this.filterDate,
  });

  factory ReceiveIGPListModel.fromJson(Map<String, dynamic> json) => ReceiveIGPListModel(
    date: json["Date"],
    igpNo: json["IGPNo"],
    receivingStatus: json["ReceivingStatus"],
    receivedBy: json["ReceivedBy"],
    receivingDate: json["ReceivingDate"],
    filterDate: DateTime.parse(json["FilterDate"]),
  );

  Map<String, dynamic> toJson() => {
    "Date": date,
    "IGPNo": igpNo,
    "ReceivingStatus": receivingStatus,
    "ReceivedBy": receivedBy,
    "ReceivingDate": receivingDate,
    "FilterDate": filterDate.toIso8601String(),
  };
}