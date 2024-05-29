import 'dart:typed_data';
import 'package:get/get_rx/get_rx.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import '../../../../../../app_assets/styles/my_images.dart';
import '../../../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../../server/api_fetch.dart';
import '../../../models/get_rowing_quality_work_order_stitching_dhu_model.dart';

class CheckWorkOrderStitchingSummaryDetailReportController extends GetxController{
  final RxList<WorkOrderProductionStitchingListModel> workOrderSummaryList = RxList<WorkOrderProductionStitchingListModel>();
  final RxBool isLoading = RxBool(true);
  late String workOrder;
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  RxDouble stichDhuSum = 0.0.obs;
  RxDouble otherDhuSum =0.0.obs;
  @override
  void onInit() {
    workOrder = Get.arguments['workOrder'];
    getRowingQualityRateList(WorkOrder: workOrder);
    super.onInit();
  }

  Future<void> getRowingQualityRateList({String? WorkOrder}) async {
    isLoading(true);
    String data = "WorkOrder=$WorkOrder";
    workOrderSummaryList.clear();
    List<WorkOrderProductionStitchingListModel>? responseList = await ApiFetch.getRowingQualityWorkOrderProductionStitchingReport(data);
    isLoading(false);
    if (responseList != null) {
      workOrderSummaryList.assignAll(responseList);
    } else {
      Get.snackbar(
        "Message",
        'No Bundle Exist For This',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  Future<Uint8List> generatePdf(PdfPageFormat format, List<WorkOrderProductionStitchingListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 40;
    final int totalPages = (data.length / itemsPerPage).ceil();

    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<WorkOrderProductionStitchingListModel> sublist =
      data.sublist(start, end.clamp(0, data.length));
      double stichDhuSum = 0;
      double otherDhuSum = 0;
      for (var model in sublist) {
        stichDhuSum += model.stichDhu;
        otherDhuSum += model.otherDhu;
      }
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.copyWith(),
          orientation: PageOrientation.landscape,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 20.0),
                  padding: const pw.EdgeInsets.symmetric(vertical: 10.0),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Image(logoImage, width: 60, height: 60),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        'Work Order Summary Detail Report',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                // Table
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        for (var header in [
                          "No #",
                          "Date",
                          "Line",
                          "Color",
                          "Induction",
                          "Induct\nOut",
                          "Check Pcs",
                          "EndLine\nStitching\nDHU %",
                          "Other\nDHU %",
                        ])
                          pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              header,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Table rows
                    for (var i = 0; i < sublist.length; i++)
                      pw.TableRow(
                        children: [
                          for (var cellData in [
                            (start + i + 1).toString(),
                            dateFormat.format(DateTime.parse(sublist[i].time.toString())),
                            sublist[i].unitNo.toStringAsFixed(0),
                            sublist[i].colour,
                            sublist[i].issuedpcs.toStringAsFixed(0),
                            sublist[i].stichOut.toString(),
                            sublist[i].checkedPcs,
                            '${ sublist[i].stichDhu.toStringAsFixed(1)} %',
                            '${sublist[i].otherDhu.toStringAsFixed(1)} %',
                          ])
                            pw.Container(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                cellData.toString(),
                                style: const pw.TextStyle(fontSize: 8),
                              ),
                            ),
                        ],
                      ),
                    pw.TableRow(
                      children: [
                        for (var cellData in [
                          '',
                          '', '', '', '', '', '',
                          'Total: ${stichDhuSum.toStringAsFixed(1)}%',
                          'Total: ${otherDhuSum.toStringAsFixed(1)}%',
                        ])
                          pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              cellData.toString(),
                              style: const pw.TextStyle(fontSize: 8),
                            ),
                            padding: const pw.EdgeInsets.all(5),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(width: 0.5),
                              ),
                            ),
                          ),
                      ],
                    ),

                  ],
                ),
              ],
            );
          },
        ),
      );
    }
    return pdf.save();
  }


  Future<void> previewPdf(Uint8List pdfData) async {
    await Printing.sharePdf(
        bytes: pdfData, filename: 'Work Order Summary Detail Report.pdf');
  }

  String currentSortedProperty = '';
  bool currentAscending = true;
  void sortData(String property, bool ascending) {
    if (currentSortedProperty == property && currentAscending == ascending) {
      ascending = !ascending;
    }
    currentSortedProperty = property;
    currentAscending = ascending;
    workOrderSummaryList.sort((a, b) {
      switch (property) {
        case 'time':
          return ascending
              ? a.time.compareTo(b.time)
              : b.time.compareTo(a.time);
        case 'unitNo':
          return ascending
              ? a.unitNo.compareTo(b.unitNo)
              : b.unitNo.compareTo(a.unitNo);
        case 'issuedpcs':
          return ascending
              ? a.issuedpcs.compareTo(b.issuedpcs)
              : b.issuedpcs.compareTo(a.issuedpcs);
        case 'stichOut':
          return ascending
              ? a.stichOut.compareTo(b.stichOut)
              : b.stichOut.compareTo(a.stichOut);
        case 'checkedPcs':
          return ascending
              ? a.checkedPcs.compareTo(b.checkedPcs)
              : b.checkedPcs.compareTo(a.checkedPcs);
        case 'stichDhu':
          return ascending
              ? a.stichDhu.compareTo(b.stichDhu)
              : b.stichDhu.compareTo(a.stichDhu);
        case 'otherDhu':
          return ascending
              ? a.otherDhu.compareTo(b.otherDhu)
              : b.otherDhu.compareTo(a.otherDhu);
        default:
          return 0;
      }
    });
  }

}
