import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:combined_fabrics_limited/app/routes/app_routes.dart';
import 'package:combined_fabrics_limited/app/screens/verify_documents/widgets/tools_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../verify_controllers/p_o_approve_screen_controller.dart';

class DocumentsAppCard extends StatelessWidget {
  const DocumentsAppCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final POApproveHomeController controller =
        Get.put(POApproveHomeController());
    return Obx(
      () => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth / 4;
                final cardHeight = cardWidth * 1;
                return GridView.builder(
                  itemCount: controller.dashboardAppList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        _calculateCrossAxisCount(constraints.maxWidth),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: cardWidth / cardHeight,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final item = controller.dashboardAppList[index];
                    Debug.log(item.appname);
                    var icon = "assets/icons/verify.svg";
                    if (item.appname == "Stock Adjustment") {
                      icon = "assets/icons/store.svg";
                    } else if (item.appname == " Over Time") {
                      icon = "assets/icons/overtime.svg";
                    } else if (item.appname == "PO Close") {
                      icon = "assets/icons/close.svg";
                    }
                    return ToolsWidget(
                      icon: icon,
                      cnt: item.documentCount,
                      title: item.appname,
                      onTap: () {
                       controller.nextScreen(item);
                      },
                    );
                  },
                );
              },
            ),
    );
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
