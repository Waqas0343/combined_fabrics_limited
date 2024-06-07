import 'dart:io';
import 'package:combined_fabrics_limited/app/screens/verify_documents/verify_controllers/full_screen_pdf_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../app_assets/styles/my_colors.dart';

class FullScreenPdfView extends StatelessWidget {
  const FullScreenPdfView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FullScreenPdfViewController controller =
        Get.put(FullScreenPdfViewController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: controller.zoomIn,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: controller.zoomOut,
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.file(
            File(controller.path!),
            controller: controller.pdfViewerController,
            onDocumentLoaded: controller.onDocumentLoaded,
            onPageChanged: controller.onPageChanged,
            canShowScrollHead: true,
            pageSpacing: 8,
            interactionMode: PdfInteractionMode.pan,
            scrollDirection: PdfScrollDirection.vertical,
            pageLayoutMode: PdfPageLayoutMode.single,
            currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.5),
            otherSearchTextHighlightColor: Colors.blue.withOpacity(0.5),
            enableDoubleTapZooming: true,
            enableTextSelection: true,
            enableDocumentLinkAnnotation: true,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  backgroundColor: MyColors.fillColor,
                  onPressed: controller.previousPage,
                  child: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  backgroundColor: MyColors.fillColor,
                  onPressed: controller.nextPage,
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
