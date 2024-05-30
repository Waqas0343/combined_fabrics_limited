import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../verify_models/next_levels_users.dart';
import '../verify_models/pending_documents_model.dart';

class DocumentApprovalController extends GetxController {
  var statusOptions = ['approved', 'rejected'].obs;
  var status = 'approved'.obs;
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";

  final RxList<NextLevelUsersListModel> approvedUsers =
      RxList<NextLevelUsersListModel>();

  final RxList<NextLevelUsersListModel> rejectedUsers =
      RxList<NextLevelUsersListModel>();
  final RxBool isLoading = RxBool(true);

  var selectedUser = Rx<NextLevelUsersListModel?>(null);
  var comments = ''.obs;
  late PendingDocumentsListModel pendingDocumentsListModel;
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  Rx<DateTime> dateTime = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    pendingDocumentsListModel = arguments['docItem'];
    getNextLevelUsers(pendingDocumentsListModel.applogid);
    getBelowLevelUsers(pendingDocumentsListModel.appid);
  }

  void assignUser(NextLevelUsersListModel? user) {
    selectedUser.value = user;
  }

  void updateComments(String text) {
    comments.value = text;
  }

  void submit() {
    // Implement submission logic here
    print('Status: ${status.value}');
    print('Selected User: ${selectedUser.value?.username}');
    print('Comments: ${comments.value}');
  }

  Future<void> getNextLevelUsers(int? appLogId) async {
    String param = "appLogId=$appLogId";
    isLoading(true);
    List<NextLevelUsersListModel>? responseList =
        await ApiFetch.getNextLevelUsers(param);
    isLoading(false);
    if (responseList != null) {
      approvedUsers.assignAll(responseList);
    }
  }

  Future<void> getBelowLevelUsers(int? appId) async {
    String param = "appId=$appId&userId=$employeeName";
    isLoading(true);
    List<NextLevelUsersListModel>? responseList =
        await ApiFetch.getBelowLevelUsers(param);
    isLoading(false);
    if (responseList != null) {
      rejectedUsers.assignAll(responseList);
    }
  }

  void changeStatus(String? newStatus) {
    if (newStatus != null) {
      status.value = newStatus;
      selectedUser.value = null;
    }
  }
  //
  // Future<void> updateAppLevel() async {
  //   UpdateAppLevelModel(
  //       appLogId: pendingDocumentsListModel.applogid,
  //       userId: userId,
  //       status: status.value == 'approved' ? 1 : 0,
  //       comments: comments.value,
  //       rejectLevel: rejectLevel,
  //       domainUser: '',
  //       loginUser: employeeName,
  //       computerName: '',
  //       ipAddress: '');
  //   isLoading(true);
  //   // await ApiFetch.updateAppLevel(param);
  //   isLoading(false);
  // }
}
