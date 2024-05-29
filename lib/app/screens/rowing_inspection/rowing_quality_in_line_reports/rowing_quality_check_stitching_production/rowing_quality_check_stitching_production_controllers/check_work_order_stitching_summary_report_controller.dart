import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import '../../../../../../app_assets/styles/my_images.dart';
import '../../../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../../server/api_fetch.dart';
import '../../../../../services/preferences.dart';
import '../../../models/rowing_quality_inline_inspection_form_model.dart';
import '../rowing_quality_check_stitching_producntion_models/rowing_quality_work_order_summary_report_model.dart';

class CheckWorkOrderWorkOrderSummaryController extends GetxController {
  final RxList<RowingQualityWorkOrderSummaryListModel> workOrderSummaryList = RxList<RowingQualityWorkOrderSummaryListModel>();
  final RxList<RowingQualityInlineInspectionFormListModel> workerAndOrderList = RxList<RowingQualityInlineInspectionFormListModel>();
  final Rxn<RowingQualityInlineInspectionFormListModel?> selectedOperator = Rxn<RowingQualityInlineInspectionFormListModel?>();
  final TextEditingController selectedWorkOrderController = TextEditingController();
  final RxBool isLoading = RxBool(true);
  late String workOrder;
  late String line;
  double stitchDhuSum = 0;
  double otherDhuSum = 0;
  RowingQualityInlineInspectionFormListModel? selected;
  RxBool autoFilterEnabled = false.obs;
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  @override
  void onInit() {
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    final arguments = Get.arguments as Map<String, dynamic>;
    if (arguments['Line'] is String) {
      line = arguments['Line'];
    } else if (arguments['Line'] is int) {
      line = arguments['Line'].toString();
    }
    workOrder = arguments['workOrder'];
    getRowingQualityRateList(WorkOrder: workOrder);
    getRowingQualityInlineInspectionFormList(line);

    super.onInit();
  }

  Future<void> getRowingQualityInlineInspectionFormList(String selectedValue) async {
    String param;
    if (selectedValue.contains('L')) {
      param = "unit=${selectedValue}";
    } else {
      param = "unit=L${selectedValue}";
    }
    isLoading(true);
    List<RowingQualityInlineInspectionFormListModel>? responseList =
        await ApiFetch.getRowingQualityInlineInspectionFormList(param);
    isLoading(false);
    if (responseList != null) {
      workerAndOrderList.assignAll(responseList);
    }
  }

  Future<void> getRowingQualityRateList({String? WorkOrder}) async {
    isLoading(true);
    String data = "WorkOrder=$WorkOrder";
    workOrderSummaryList.clear();
    List<RowingQualityWorkOrderSummaryListModel>? responseList =
        await ApiFetch.getRowingQualityWorkOrderSummaryReport(data);
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

  Future<Uint8List> generatePdf(PdfPageFormat format,
      List<RowingQualityWorkOrderSummaryListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 40;
    final int totalPages = (data.length / itemsPerPage).ceil();

    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<RowingQualityWorkOrderSummaryListModel> sublist =
          data.sublist(start, end.clamp(0, data.length));

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
                        'Work Order Summary Report',
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
                          "#",
                          "W/O",
                          "Color",
                          "Ok Cut Pcs",
                          "Ind Store",
                          "@ Print/Emd",
                          "Line",
                          "Start Date",
                          "End Date",
                          "Induction In",
                          "Out",
                          "WIP",
                          "Checked Pcs",
                          "Stitching DHU%",
                          "Other DHU%",
                        ])
                          pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              header,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
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
                            sublist[i].woOrder,
                            sublist[i].color,
                            sublist[i].okPcs.toStringAsFixed(0),
                            sublist[i].inductStock.toStringAsFixed(0),
                            '${sublist[i].printpcs.toStringAsFixed(0)}/${sublist[i].emboridrypcs.toStringAsFixed(0)}',
                            (sublist[i].lineId),
                            dateFormat.format(DateTime.parse(sublist[i].starttime.toString())),
                            dateFormat.format(DateTime.parse(sublist[i].laststitchpctime.toString())),
                            sublist[i].issuedpcs.toStringAsFixed(0),
                            sublist[i].stichOutpcs.toStringAsFixed(0),
                            sublist[i].wip.toStringAsFixed(0),
                            sublist[i].checkedpcs.toStringAsFixed(0),
                            '${sublist[i].stichDhu.toStringAsFixed(1)}%',
                            '${sublist[i].otherDhu.toStringAsFixed(1)}%',
                          ])
                            pw.Container(
                              // alignment: Alignment.center,
                              child: pw.Text(
                                cellData.toString(),
                                // Explicitly cast to String
                                style: const pw.TextStyle(fontSize: 8),
                              ),
                            ),
                        ],
                      ),
                    pw.TableRow(
                      children: [
                        for (var cellData in [
                          '',
                          '',
                          '',
                          '',
                          '',
                          '',
                          '',
                          '',
                          '',
                          '',
                          '',
                          'Total: ${stitchDhuSum.toStringAsFixed(1)}%',
                          'Total: ${otherDhuSum.toStringAsFixed(1)}%',
                        ])
                          pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              cellData.toString(),
                              style: const pw.TextStyle(fontSize: 8),
                            ),
                            padding: const pw.EdgeInsets.all(5),
                            // Add padding to each cell
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                    width:
                                        0.5), // Set border for bottom of each cell
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
        case 'woOrder':
          return ascending
              ? a.woOrder.compareTo(b.woOrder)
              : b.woOrder.compareTo(a.woOrder);
        case 'color':
          return ascending
              ? a.color.compareTo(b.color)
              : b.color.compareTo(a.color);
        case 'okPcs':
          return ascending
              ? a.okPcs.compareTo(b.okPcs)
              : b.okPcs.compareTo(a.okPcs);
        case 'inductStock':
          return ascending
              ? a.inductStock.compareTo(b.inductStock)
              : b.inductStock.compareTo(a.inductStock);
        case 'printpcs':
          return ascending
              ? a.printpcs.compareTo(b.printpcs)
              : b.printpcs.compareTo(a.printpcs);
        case 'lineId':
          return ascending
              ? a.lineId.compareTo(b.lineId)
              : b.lineId.compareTo(a.lineId);
        case 'issuedpcs':
          return ascending
              ? a.issuedpcs.compareTo(b.issuedpcs)
              : b.issuedpcs.compareTo(a.issuedpcs);
        case 'stichOutpcs':
          return ascending
              ? a.stichOutpcs.compareTo(b.stichOutpcs)
              : b.stichOutpcs.compareTo(a.stichOutpcs);
        case 'wip':
          return ascending ? a.wip.compareTo(b.wip) : b.wip.compareTo(a.wip);
        case 'checkedpcs':
          return ascending
              ? a.checkedpcs.compareTo(b.checkedpcs)
              : b.checkedpcs.compareTo(a.checkedpcs);
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

  Future<void> autoFilter() async {
    if (autoFilterEnabled.value) {
      await getRowingQualityRateList(
        WorkOrder: selectedWorkOrderController.text,
      );
    } else {
      selectedWorkOrderController.clear();
    }
  }
}
