import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/my_icons.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../routes/app_routes.dart';
import '../../screens/fabric_inspection/widget/table_shift_dialog_form.dart';
import '../../screens/home/home_controller.dart';
import '../../screens/home/model/get_menu_model.dart';
import '../../screens/verify_documents/widgets/tools_widget.dart';
import '../../services/preferences.dart';
import '../home_tools/tools_widget.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    String? table = Get.find<Preferences>().getString(Keys.inspectionTable);
    String? shift = Get.find<Preferences>().getString(Keys.shiftValue);
    return Obx(() {
      final userMenuList = controller.userMenuList;
      if (userMenuList.isNotEmpty) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth / 3 - 20;
            final cardHeight = cardWidth * 1;

            return GridView.builder(
              itemCount: controller.userMenuList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _calculateCrossAxisCount(constraints.maxWidth),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: cardWidth / cardHeight,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                MenuModelList menu = controller.userMenuList[index];
                String? iconData;
                Function()? onTap;
                if (menu.menuName == 'GIN') {
                  iconData = MyIcons.isStore;
                  onTap = () {
                    Get.toNamed(AppRoutes.goodsInspectionDashboard);
                  };
                } else if (menu.menuName == 'Fabric Inspection') {
                  iconData = MyIcons.isInspection;
                  onTap = () {
                    if (table == null && shift == null) {
                      Get.dialog(FormDialogBox());
                    } else {
                      Get.toNamed(AppRoutes.fabricInspectionHome);
                    }
                  };
                } else if (menu.menuName == 'Rowing Quality') {
                  iconData = MyIcons.isGarment;
                  onTap = () {
                    Get.toNamed(AppRoutes.rowingInspectionDashboard);
                  };
                } else if (menu.menuName == 'Make Complaints') {
                  iconData = MyIcons.isCreateComplaint;
                  onTap = () {
                    Get.toNamed(AppRoutes.createNewComplaint);
                  };
                } else if (menu.menuName == 'Manage Complain') {
                  iconData = MyIcons.isComplain;
                  onTap = () {
                    Get.toNamed(AppRoutes.receivedComplaints);
                  };
                } else if (menu.menuName == 'Complaint Dashboard') {
                  iconData = MyIcons.isComplain;
                  onTap = () {
                    Get.toNamed(AppRoutes.complaintPortalHome);
                  };
                } else if (menu.menuName == 'Keys Management') {
                  iconData = MyIcons.isKeysIssuance;
                  onTap = () {
                    Get.toNamed(AppRoutes.keysDashBoardScreen);
                  };
                } else if (menu.menuName == 'Medical Issuance') {
                  iconData = MyIcons.isMedicalIssuance;
                  onTap = () {
                    Get.toNamed(AppRoutes.medicineDashboardScreen);
                  };
                } else if (menu.menuName == 'Document Approval') {
                  iconData = MyIcons.isVerify;
                  onTap = () {
                    Get.toNamed(AppRoutes.verifyDocumentDashBoard);
                  };
                } else if (menu.menuName == 'Make Complaints') {
                  iconData = MyIcons.isPaint;
                  onTap = () {
                    Get.toNamed(AppRoutes.createNewComplaint);
                  };
                } else if (menu.menuName == 'Manage Complaints') {
                  iconData = MyIcons.isComplain;
                  onTap = () {
                    Get.toNamed(
                      AppRoutes.receivedComplaints,
                    );
                  };
                }

                if (menu.menuName == 'Document Approval') {
                  return VerifyDocumentToolsWidget(
                    icon: iconData ?? "",
                    title: menu.menuName,
                    onTap: onTap,
                    cnt: controller.documentCount ?? 0,
                  );
                } else {
                  return ToolsWidget(
                    icon: iconData ?? "",
                    title: menu.menuName,
                    onTap: onTap,
                  );
                }
              },
            );
          },
        );
      }
      return const CircularProgressIndicator();
    });
  }

  int _calculateCrossAxisCount(double maxWidth) {
    if (maxWidth < 600) {
      return 2;
    } else if (maxWidth < 900) {
      return 3;
    } else {
      return 4;
    }
  }
}
