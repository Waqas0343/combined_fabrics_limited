import 'package:combined_fabrics_limited/app/app_widgets/custom_card.dart';
import 'package:combined_fabrics_limited/app/screens/verify_documents/verify_controllers/p_o_pending_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class StockAdjustmentHomeScreen extends StatelessWidget {
  const StockAdjustmentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final POPendingDocumentsController controller =
        Get.put(POPendingDocumentsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Adjustment Screen'),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: controller.pendingDocumentsList.length,
                itemBuilder: (context, index) {
                  final item = controller.pendingDocumentsList[index];
                  List<Color> rowColors = [
                    const Color(0xffe5f7f1),
                    Colors.white
                  ];
                  Color rowColor = rowColors[index % rowColors.length];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.documentApprovalScreen,
                            arguments: {'docItem': item});
                      },
                      child: CustomCard(
                        color: rowColor,
                        child: ListTile(
                          leading: SvgPicture.asset("assets/icons/verify.svg",
                              width: 50, height: 50),
                          title: Text(
                            item.docnum.toString(),
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            "Assigned by ${item.lastuser}\nDate : ${controller.dateFormat.format(item.createdDate)}",
                            style: Get.textTheme.titleSmall,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 16,
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
