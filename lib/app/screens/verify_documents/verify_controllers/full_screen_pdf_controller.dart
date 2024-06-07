import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FullScreenPdfViewController extends GetxController {
  final PdfViewerController pdfViewerController = PdfViewerController();
  var totalPages = 0.obs;
  var currentPage = 1.obs;
  String? path;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    path = arguments['path'];
  }

  void onDocumentLoaded(PdfDocumentLoadedDetails details) {
    totalPages.value = details.document.pages.count;
  }

  void onPageChanged(PdfPageChangedDetails details) {
    currentPage.value = details.newPageNumber;
  }

  void zoomIn() {
    pdfViewerController.zoomLevel += 0.25;
  }

  void zoomOut() {
    pdfViewerController.zoomLevel -= 0.25;
  }

  void nextPage() {
    pdfViewerController.nextPage();
  }

  void previousPage() {
    pdfViewerController.previousPage();
  }
}
