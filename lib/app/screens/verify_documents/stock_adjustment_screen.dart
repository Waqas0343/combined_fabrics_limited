import 'package:combined_fabrics_limited/app/app_widgets/custom_card.dart';
import 'package:combined_fabrics_limited/app/screens/verify_documents/verify_controllers/p_o_pending_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../home/home_controller.dart';

class StockAdjustmentHomeScreen extends StatelessWidget {
  const StockAdjustmentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final POPendingDocumentsController controller =
        Get.put(POPendingDocumentsController());

    return WillPopScope(
      onWillPop: () async {
        Get.find<HomeController>().getCountAllDocs();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.appName ?? ''),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: controller.searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        controller.searchQuery.value = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        controller.clearFilters();
                      },
                      child: const Icon(Icons.clear),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount:
                            controller.filteredGroupedPendingDocuments.length,
                        itemBuilder: (context, index) {
                          final lastUser = controller
                              .filteredGroupedPendingDocuments.keys
                              .toList()[index];
                          final documents = controller
                              .filteredGroupedPendingDocuments[lastUser]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                isThreeLine: false,
                                title: Text(
                                  "Assigned by $lastUser",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                leading: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.orangeAccent,
                                  child: Text(
                                    "${documents.length}",
                                    style:
                                        Get.theme.textTheme.bodySmall?.copyWith(
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
                                  Color rowColor =
                                      rowColors[index % rowColors.length];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomCard(
                                      onPressed: () {
                                        Get.toNamed(
                                          AppRoutes.documentApprovalScreen,
                                          arguments: {
                                            'currentDocumentIndex': index,
                                            'groupedPendingDocuments': controller.filteredGroupedPendingDocuments, // Pass entire map
                                            'AppName': controller.appName,
                                            'AppID': controller.appID,
                                          },
                                        );
                                      },

                                      color: rowColor,
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.asset(
                                            "assets/images/cfl_logo.png",
                                            width: 70,
                                            height: 70,
                                          ),
                                        ),
                                        title: Text(
                                          item.docnum.toString(),
                                          style: Get.textTheme.titleSmall
                                              ?.copyWith(
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
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
