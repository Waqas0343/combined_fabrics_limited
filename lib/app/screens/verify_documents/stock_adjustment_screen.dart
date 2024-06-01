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
        title: Text(controller.appName ?? ''),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: controller.groupedPendingDocuments.length,
                itemBuilder: (context, index) {
                  final lastUser =
                      controller.groupedPendingDocuments.keys.toList()[index];
                  final documents =
                      controller.groupedPendingDocuments[lastUser]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        isThreeLine: false,
                        title: Text(
                          "Assigned by $lastUser",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.orangeAccent,
                          child: Text(
                            "${documents.length}",
                            style: Get.theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final item = documents[index];
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
                                    arguments: {
                                      'docItem': item,
                                      'AppName': controller.appName
                                    });
                              },
                              child: CustomCard(
                                color: rowColor,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: SvgPicture.asset(
                                      "assets/icons/document.svg",
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  title: Text(
                                    item.docnum.toString(),
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Text(
                                      "Date: ${controller.dateFormat.format(item.createdDate)}"),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                  isThreeLine: false,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}