class InLineProductionHourlyReportModel {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  dynamic data;
  dynamic list;
  List<InLineProductionHourlyReportListModel> lists;
  dynamic iList;
  dynamic ieList;
  dynamic totalRecords;
  dynamic totalPagesCount;
  dynamic returnData;

  InLineProductionHourlyReportModel({
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

  factory InLineProductionHourlyReportModel.fromJson(Map<String, dynamic> json) => InLineProductionHourlyReportModel(
    message: json["Message"],
    status: json["Status"],
    statusCode: json["StatusCode"],
    errors: json["Errors"],
    expiredate: json["Expiredate"],
    data: json["Data"],
    list: json["List"],
    lists: List<InLineProductionHourlyReportListModel>.from(json["Lists"].map((x) => InLineProductionHourlyReportListModel.fromJson(x))),
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
    "List": list,
    "Lists": List<dynamic>.from(lists.map((x) => x.toJson())),
    "IList": iList,
    "IEList": ieList,
    "TotalRecords": totalRecords,
    "TotalPagesCount": totalPagesCount,
    "ReturnData": returnData,
  };
}

class InLineProductionHourlyReportListModel {
  String workorder;
  String workorderId;
  Map<String, dynamic> hourlyData; // Change to a map for dynamic keys

  InLineProductionHourlyReportListModel({
    required this.workorder,
    required this.workorderId,
    required this.hourlyData,
  });
  factory InLineProductionHourlyReportListModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      // Handle null case here, such as returning a default object or throwing an exception.
      // For example:
      throw FormatException("JSON data is null");
    }

    // Proceed with parsing JSON data
    Map<String, dynamic> hourlyData = Map.from(json); // Assuming hourly data is directly in the JSON object
    hourlyData.remove('Workorder'); // Remove known keys from the map
    hourlyData.remove('WorkorderID');
    return InLineProductionHourlyReportListModel(
      workorder: json["Workorder"],
      workorderId: json["WorkorderID"],
      hourlyData: hourlyData,
    );
  }

  toJson() {}

}
