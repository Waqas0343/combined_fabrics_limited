import 'package:combined_fabrics_limited/app/screens/verify_documents/verify_controllers/documents_track_list_controller.dart';
import 'package:combined_fabrics_limited/app/screens/verify_documents/verify_models/verify_doc_dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../app_widgets/custom_card.dart';

class DocumentTrack extends StatelessWidget {
  const DocumentTrack({super.key});

  @override
  Widget build(BuildContext context) {
    final DocumentsTrackListController controller = Get.put(DocumentsTrackListController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Track'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return DropdownButton<DocumentVerifyAppListModel>(
                      hint: const Text("Select App"),
                      value: controller.selectedApp.value,
                      isExpanded: true,
                      items: controller.appsList.map((DocumentVerifyAppListModel app) {
                        return DropdownMenuItem<DocumentVerifyAppListModel>(
                          value: app,
                          child: Text(app.appname),
                        );
                      }).toList(),
                      onChanged: (app) {
                        controller.changeApp(app);
                      },
                    );
                  }),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    return DropdownButton<String>(
                      hint: const Text("Select Status"),
                      value: controller.selectedStatus.value,
                      isExpanded: true,
                      items: ['approved', 'pending', 'both'].map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status.capitalizeFirst!),
                        );
                      }).toList(),
                      onChanged: (status) {
                        controller.changeStatus(status!);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[,.]')),
                ],
                onChanged: (value) => controller.updateSearchQuery(value),
                decoration: const InputDecoration(
                  labelText: 'Search Document',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total documents: ${controller.filteredDocumentsTrackListModel.length}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }),
          Expanded(
            child: Obx(
                  () => controller.isLoading.value
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : controller.filteredDocumentsTrackListModel.isEmpty
                  ? const Center(
                child: Text('No documents found for the selected filters.'),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: controller.filteredDocumentsTrackListModel.length,
                itemBuilder: (context, docIndex) {
                  final item = controller.filteredDocumentsTrackListModel[docIndex];
                  List<Color> rowColors = [const Color(0xffe5f7f1), Colors.white];
                  Color rowColor = rowColors[docIndex % rowColors.length];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomCard(
                      onPressed: () {},
                      color: rowColor,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            "assets/images/cfl_logo.png",
                            width: 70,
                            height: 70,
                          ),
                        ),
                        title: Text(
                          item.docnum.toString(),
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                            text: controller.dateFormat.format(item.createdDate),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: '\n${item.sign10}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: ' @ Level ${item.authlevel}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Icon(
                          item.status == 1 ? Icons.check : Icons.pending,
                          color: item.status == 1 ? Colors.green : Colors.red,
                        ),
                        isThreeLine: false,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
