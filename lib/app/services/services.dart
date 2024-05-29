import 'package:combined_fabrics_limited/app/services/preferences.dart';
import 'package:get/get.dart';
class Services {
  static final Services _instance = Services._();

  Services._();

  factory Services() => _instance;

  Future<void> initServices() async {
    await Get.putAsync<Preferences>(() => Preferences().initial());
  }
}
