class LotsModel<T> {
  String message;
  bool status;
  int statusCode;
  dynamic errors;
  dynamic expiredate;
  List<T>? data;
  dynamic list;
  dynamic iList;
  dynamic totalRecords;
  dynamic totalPagesCount;

  LotsModel({
    required this.message,
    required this.status,
    required this.statusCode,
    this.errors,
    this.expiredate,
    this.data,
    this.list,
    this.iList,
    this.totalRecords,
    this.totalPagesCount,
  });

  factory LotsModel.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return LotsModel(
      message: json["Message"],
      status: json["Status"],
      statusCode: json["StatusCode"],
      errors: json["Errors"],
      expiredate: json["Expiredate"],
      data: List<T>.from(json["Data"]?.map((x) => fromJson(x))),
      list: json["List"],
      iList: json["IList"],
      totalRecords: json["TotalRecords"],
      totalPagesCount: json["TotalPagesCount"],
    );
  }
}
