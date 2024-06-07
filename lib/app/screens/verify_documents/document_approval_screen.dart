import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:combined_fabrics_limited/app/screens/verify_documents/verify_controllers/document_approval_controller.dart';
import 'package:combined_fabrics_limited/app/screens/verify_documents/verify_models/next_levels_users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../routes/app_routes.dart';
import 'full_screen_pdf_view.dart'; // Import the new screen

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
              child: SingleChildScrollView(
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
                                items: controller.statusOptions
                                    .map((String status) {
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
                              const Row(
                                children: [
                                  SizedBox(
                                    height: 24,
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
                    SizedBox(
                      height: Get.height * 0.4,
                      width: Get.width,
                      child: controller.isLoadingPdf.isFalse
                          ? SfPdfViewer.file(
                              controller.file,
                              key: ValueKey(controller.file.path),
                              canShowScrollHead: true,
                              pageSpacing: 8,
                              interactionMode: PdfInteractionMode.pan,
                              scrollDirection: PdfScrollDirection.vertical,
                              pageLayoutMode: PdfPageLayoutMode.single,
                              currentSearchTextHighlightColor:
                                  Colors.yellow.withOpacity(0.5),
                              otherSearchTextHighlightColor:
                                  Colors.blue.withOpacity(0.5),
                              enableDoubleTapZooming: true,
                              enableTextSelection: true,
                              enableDocumentLinkAnnotation: true,
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.fullScreenPdfView,
                                arguments: {'path': controller.file.path});
                          },
                          child: const Text('Expand View'),
                        ),
                      ],
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
              ),
            )),
    );
  }
}
