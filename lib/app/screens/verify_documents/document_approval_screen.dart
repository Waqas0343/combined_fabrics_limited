import 'package:combined_fabrics_limited/app/screens/verify_documents/verify_controllers/document_approval_controller.dart';
import 'package:combined_fabrics_limited/app/screens/verify_documents/verify_models/next_levels_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

class DocumentApprovalScreen extends StatelessWidget {
  const DocumentApprovalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DocumentApprovalController controller =
        Get.put(DocumentApprovalController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.appName ?? '',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const Text(
                  'Assigned by ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  controller.pendingDocumentsListModel.lastuser,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.description, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Document Name: ${controller.pendingDocumentsListModel.docnum}',
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.date_range, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        controller.dateFormat.format(
                            controller.pendingDocumentsListModel.createdDate),
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.assignment_turned_in,
                                    size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  "Status",
                                  style: Get.textTheme.titleSmall?.copyWith(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            DropdownButton<String>(
                              hint: Text(
                                "Select Status",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  color: Colors.grey[700],
                                ),
                              ),
                              value: controller.status.value,
                              isExpanded: true,
                              items:
                                  controller.statusOptions.map((String status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                controller.changeStatus(newValue);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person_add, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  "Assign New User",
                                  style: Get.textTheme.titleSmall?.copyWith(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            DropdownButton<NextLevelUsersListModel>(
                              hint: Text(
                                "Select User",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  color: Colors.grey[700],
                                ),
                              ),
                              value: controller.selectedUser.value,
                              isExpanded: true,
                              items: controller.status.value == 'approved'
                                  ? controller.approvedUsers
                                      .map((NextLevelUsersListModel user) {
                                      return DropdownMenuItem<
                                          NextLevelUsersListModel>(
                                        value: user,
                                        child: Text(user.username),
                                      );
                                    }).toList()
                                  : controller.rejectedUsers
                                      .map((NextLevelUsersListModel user) {
                                      return DropdownMenuItem<
                                          NextLevelUsersListModel>(
                                        value: user,
                                        child: Text(user.username),
                                      );
                                    }).toList(),
                              onChanged: (NextLevelUsersListModel? newValue) {
                                controller.assignUser(newValue);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(
                      () => controller.pdfUrl.isNotEmpty
                          ? PDFView(
                              filePath: controller.pdfUrl.value,
                              enableSwipe: true,
                              swipeHorizontal: false,
                              fitPolicy: FitPolicy.WIDTH,
                              autoSpacing: false,
                              pageFling: true,
                              onRender: (_pages) {
                                controller.pages.value = _pages!;
                                controller.isReady.value = true;
                              },
                              onError: (error) {
                                print(error.toString());
                              },
                              onPageError: (page, error) {
                                print('$page: ${error.toString()}');
                              },
                              onViewCreated:
                                  (PDFViewController pdfViewController) {
                                controller.pdfViewController =
                                    pdfViewController;
                              },
                            )
                          : const Center(
                              child: Text("No PDF available"),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Comments',
                      border: OutlineInputBorder(),
                    ),
                    style: Get.textTheme.titleSmall?.copyWith(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    onChanged: controller.updateComments,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          controller.submit();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                        ),
                        icon: const Icon(Icons.save,
                            size: 18, color: Colors.white),
                        label: Text(
                          'Submit',
                          style: Get.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
    );
  }
}
