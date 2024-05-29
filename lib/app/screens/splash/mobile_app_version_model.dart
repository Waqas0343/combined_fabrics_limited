class MobileVersionModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  List<MobileVersionListModel> list;
  dynamic lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  MobileVersionModel({
    required this.message,
    required this.status,
    required this.statusCode,
    required this.errors,
    required this.expiredate,
    required this.data,
    required this.list,
    required this.lists,
    required this.iList,
    required this.ieList,
    required this.totalRecords,
    required this.totalPagesCount,
    required this.returnData,
  });

  factory MobileVersionModel.fromJson(Map<String, dynamic> json) => MobileVersionModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: List<MobileVersionListModel>.from(json["List"].map((x) => MobileVersionListModel.fromJson(x))),
    lists: json["Lists"],
    iList: json["IList"],
    ieList: json["IEList"],
    totalRecords: json["TotalRecords"],
    totalPagesCount: json["TotalPagesCount"],
    returnData: json["ReturnData"],
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
    "StatusCode": statusCode,
    "Errors": errors,
    "Expiredate": expiredate,
    "Data": data,
    "List": List<dynamic>.from(list.map((x) => x.toJson())),
    "Lists": lists,
    "IList": iList,
    "IEList": ieList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
    "ReturnData": returnData,
  };
}

class MobileVersionListModel {
  int id;
  dynamic moduleCode;
  String moduleName;
  String publishVersion;
  dynamic revision;
  dynamic status;
  dynamic created;
  dynamic createdBy;
  dynamic remarks;

  MobileVersionListModel({
    required this.id,
    required this.moduleCode,
    required this.moduleName,
    required this.publishVersion,
    required this.revision,
    required this.status,
    required this.created,
    required this.createdBy,
    required this.remarks,
  });

  factory MobileVersionListModel.fromJson(Map<String, dynamic> json) => MobileVersionListModel(
    id: json["Id"],
    moduleCode: json["ModuleCode"],
    moduleName: json["ModuleName"],
    publishVersion: json["PublishVersion"],
    revision: json["Revision"],
    status: json["Status"],
    created: json["Created"],
    createdBy: json["CreatedBy"],
    remarks: json["Remarks"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "ModuleCode": moduleCode,
    "ModuleName": moduleName,
    "PublishVersion": publishVersion,
    "Revision": revision,
    "Status": status,
    "Created": created,
    "CreatedBy": createdBy,
    "Remarks": remarks,
  };
}
