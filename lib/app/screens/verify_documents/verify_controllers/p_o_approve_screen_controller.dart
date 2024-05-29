import 'package:get/get.dart';
import 'package:intl/intl.dart';

class POApproveHomeController  extends GetxController{
  final List<Map<String, String>> dummyData = List.generate(10, (index) {
    final now = DateTime.now().subtract(Duration(days: index));
    return {
      'image': 'assets/icons/verify.svg',
      'title': 'Item ${index + 1}',
      'subtitle': 'This is the subtitle for item ${index + 1}',
      'date': DateFormat('yyyy-MM-dd').format(now),
      'time': DateFormat('HH:mm').format(now),
    };
  });
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}