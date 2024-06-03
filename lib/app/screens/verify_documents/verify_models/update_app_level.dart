class UpdateAppLevelModel {
  int appLogId;
  String userId;
  String selectedUser;
  int status;
  String comments;
  int rejectLevel;
  String domainUser;
  String loginUser;
  String computerName;
  String ipAddress;

  UpdateAppLevelModel({
    required this.appLogId,
    required this.userId,
    required this.selectedUser,
    required this.status,
    required this.comments,
    required this.rejectLevel,
    required this.domainUser,
    required this.loginUser,
    required this.computerName,
    required this.ipAddress,
  });

  factory UpdateAppLevelModel.fromJson(Map<String, dynamic> json) =>
      UpdateAppLevelModel(
        appLogId: json["AppLogID"],
        userId: json["UserID"],
        selectedUser: json["SelectedUser"],
        status: json["Status"],
        comments: json["Comments"],
        rejectLevel: json["RejectLevel"],
        domainUser: json["DomainUser"],
        loginUser: json["LoginUser"],
        computerName: json["ComputerName"],
        ipAddress: json["IpAddress"],
      );

  Map<String, dynamic> toJson() => {
        "AppLogID": appLogId,
        "UserID": userId,
        "SelectedUser": selectedUser,
        "Status": status,
        "Comments": comments,
        "RejectLevel": rejectLevel,
        "DomainUser": domainUser,
        "LoginUser": loginUser,
        "ComputerName": computerName,
        "IpAddress": ipAddress,
      };
}
