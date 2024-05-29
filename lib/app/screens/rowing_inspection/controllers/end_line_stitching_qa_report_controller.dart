import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import '../../../../app_assets/styles/my_images.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rowing_quality_dhu_model.dart';
import '../models/rowing_quality_endline_qa_stitching_model.dart';

class EndLineStitchingQAReportController extends GetxController {
  final Rxn<EndLineQAStitchingReportListModel?> selectedOperator = Rxn<EndLineQAStitchingReportListModel?>();
  final RxList<EndLineQAStitchingReportListModel> stitchingQAList =RxList<EndLineQAStitchingReportListModel>();
  final RxList<RowingQualityDHUListModel> dhuSummaryList =RxList<RowingQualityDHUListModel>();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final TextEditingController workOrderController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController selectedWorkOrderController = TextEditingController();
  DateTime dateTime = DateTime.now();
  final RxBool isLoading = RxBool(true);
  RxBool autoFilterEnabled = false.obs;
  final RxString selectedLinSection = 'L15'.obs;
  final List<String> lineSectionName = [
    'L5',
    'L12',
    'L15',
    'L25',
  ];
  EndLineQAStitchingReportListModel? selected;
  @override
  void onInit() {
    dateController.text = dateFormat.format(dateTime);
    fromDateController.text = dateFormat.format(dateTime);
    toDateController.text = dateFormat.format(dateTime);
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getRowingQualityEndLineQAStitching();
    getRowingQualityDHUListSummary();
    super.onInit();

  }
  Future<void> getRowingQualityDHUListSummary({
    String? FromDate,
    String? ToDate,
  }) async {
    isLoading(true);
    FromDate ??= fromDateController.text;
    ToDate ??= toDateController.text;
    int selectedLine = int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    String data = "Fromdate=$FromDate&Todate=$ToDate&lineno=$selectedLine";
    try {
      dhuSummaryList.clear();
      List<RowingQualityDHUListModel>? responseList = await ApiFetch.getRowingQualityDHUDetail(data);
      isLoading(false);
      if (responseList != null) {
        dhuSummaryList.assignAll(responseList);
      }
    } catch (e) {
      Get.snackbar(
        "Message",
        'No Bundle Exist For This',
        snackPosition: SnackPosition.BOTTOM,
      );

      isLoading(false);
    }
  }

  Future<void> getRowingQualityEndLineQAStitching({
    String? FromDate,
    String? ToDate,
    String? WorkOrder,
    int? Unit,
  })  async {
    isLoading(true);
    FromDate ??= fromDateController.text;
    ToDate ??= toDateController.text;
    Unit ??= int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    WorkOrder ??= '';
    isLoading(true);
    stitchingQAList.clear();
    String data = "Fromdate=$FromDate&Todate=$ToDate&WorkOrder=$WorkOrder&lineNo=$Unit";
    stitchingQAList.clear();
    try {
      List<EndLineQAStitchingReportListModel>? responseList = await ApiFetch.getRowingQualityEndLineQAStitchingReport(data);
      isLoading(false);
      if (responseList != null) {
        stitchingQAList.assignAll(responseList);
      }
    } catch (e) {
      Get.snackbar(
        "Message",
        'No Bundle Exist For This',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading(false);
    }
  }

  Future<void> pickDate(TextEditingController dateController) async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(minutes: 10),
      ),
    );

    if (date != null) {
      dateController.text = dateFormat.format(date);
      dateTime = date;
    }
  }

  Future<Uint8List> generatePdf(PdfPageFormat format, List<EndLineQAStitchingReportListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 13;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<EndLineQAStitchingReportListModel> sublist = data.sublist(start, end.clamp(0, data.length));
      pdf.addPage(
        pw.Page(
          pageFormat: format.copyWith(
            marginLeft: 10,
            marginRight: 10,
            marginBottom: 10,
            marginTop: 10,
          ).landscape,
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
                        'EndLine Stitching QA Report',
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
                    // Table header
                    pw.TableRow(
                      children: [
                        for (var header in [
                          "No",
                          "Date",
                          "Line",
                          "W/O",
                          "Offline Pcs",
                          "Checked\nPcs",
                          "Def Pcs",
                          "St. DHU %",
                          "Oth DHU %",
                          "QMP\nChecked",
                          "QMP\nDef\nPcs",
                          "QMP\nOth. Def",
                          "QMP St\nDHU %",
                          "QMP Oth\nDHU %",
                          "Total\nChecked"
                        ])
                          pw.Container(
                            alignment: pw.Alignment.center,
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              header,
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7),
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
                            dateFormat.format(DateTime.parse(sublist[i].transactionDate.toString())),
                            sublist[i].line.toString(),
                            sublist[i].woNumber.toString(),
                            sublist[i].offLinepcs.toString(),
                            sublist[i].e2InspGarmentNo.toString(),
                            sublist[i].e2Faultpcs.toString(),
                            '${ sublist[i].e2StichDhu.toStringAsFixed(1)}%',
                            '${sublist[i].e2Otherstch.toStringAsFixed(1)}%',
                            sublist[i].qMpInspGarmentNo.toString(),
                            sublist[i].qmpFaultpcs.toString(),
                            sublist[i].qmpOtherfaultpc.toString(),
                            '${sublist[i].qmpStichDhu.toStringAsFixed(1)}%',
                            '${sublist[i].qmpOtherstch.toStringAsFixed(1)}%',
                            (sublist[i].e2InspGarmentNo+sublist[i].qMpInspGarmentNo),

                          ])
                            pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(
                                cellData.toString(),
                                style: const pw.TextStyle(fontSize: 7),
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
///todo: Preview Report
  Future<void> previewPdf(Uint8List pdfData) async {
    await Printing.sharePdf(bytes: pdfData, filename: 'your_pdf_filename.pdf');
  }
  /// todo: Report export into excel
  Future<void> exportToExcel(List<EndLineQAStitchingReportListModel> data,  String reportName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      const TextCellValue('Date'),
      const TextCellValue('Line'),
      const TextCellValue('W/O'),
      const TextCellValue('Offline Pcs'),
      const TextCellValue('EL. Checked Pcs'),
      const TextCellValue('EL. Def Pcs'),
      const TextCellValue('EL. Other Def Pcs'),
      const TextCellValue('EL. St. DHU%'),
      const TextCellValue('EL. Oth DHU %'),
      const TextCellValue('QMP. Checked'),
      const TextCellValue('QMP. Def Pcs'),
      const TextCellValue('QMP. Oth. Def'),
      const TextCellValue('QMP. St DHU %'),
      const TextCellValue('QMP. Oth DHU %'),
    ]);

    for (var item in data) {
      var date = dateFormat.format(DateTime.parse(item.transactionDate.toString()));
      var line = item.line.toString();
      var woNumber = item.woNumber.toString();
      var checkedPcs = item.offLinepcs.toString();
      var defectPcs = item.e2InspGarmentNo.toString();
      var e2Faultpcs = item.e2Faultpcs.toString();
      var e2Otherfaultpc = item.e2Otherfaultpc.toString();
      var e2StichDhu = item.e2StichDhu.toString();
      var e2Otherstch = item.e2Otherstch.toString();
      var qMpInspGarmentNo = item.qMpInspGarmentNo.toString();
      var qmpFaultpcs = item.qmpFaultpcs.toString();
      var qmpOtherfaultpc = item.qmpOtherfaultpc.toString();
      var qmpStichDhu = item.qmpStichDhu.toString();
      var qmpOtherstch = item.qmpOtherstch.toString();

      Debug.log(' date: $date   line: $line  workNuber: $woNumber  checkPcs: $checkedPcs   defectPcs: $defectPcs');

      sheet.appendRow([
        TextCellValue(date),
        TextCellValue(line),
        TextCellValue(woNumber),
        TextCellValue(checkedPcs),
        TextCellValue(defectPcs),
        TextCellValue(e2Faultpcs),
        TextCellValue(e2Otherfaultpc.toString()),
        TextCellValue(e2StichDhu.toString()),
        TextCellValue(e2Otherstch.toString()),
        TextCellValue(qMpInspGarmentNo.toString()),
        TextCellValue(qmpFaultpcs.toString()),
        TextCellValue(qmpOtherfaultpc.toString()),
        TextCellValue(qmpStichDhu.toString()),
        TextCellValue(qmpOtherstch.toString()),
      ]);
    }
    try {
      var bytes = excel.encode();

      var directory = await getApplicationDocumentsDirectory();
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      var fileName = '${reportName.replaceAll(' ', '_')}_$timestamp.xlsx'; // Use report name in the file name
      var file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes!);
      Get.snackbar(
        "Message",
        "Excel file successfully saved. with name of $fileName Check Your Document",
        snackPosition: SnackPosition.BOTTOM,
      );
      Debug.log('Excel file successfully saved.');
    } catch (e, s) {
      Debug.log('Error occurred while saving the Excel file: $e');
      Debug.log('Error occurred while saving the Excel file: $s');
    }
  }

  void setAutoFilter(bool value) {
    autoFilterEnabled.value = value;
    Get.find<Preferences>().setBool(Keys.autoFilter, value);
  }
  void autoFilter() {
    if (autoFilterEnabled.value) {
      getRowingQualityEndLineQAStitching(
        FromDate: fromDateController.text,
        ToDate: toDateController.text,
        WorkOrder: selectedWorkOrderController.text,
        Unit: int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
      );
      getRowingQualityDHUListSummary(
          FromDate: fromDateController.text,
              ToDate: toDateController.text
      );
    } else {
      fromDateController.clear();
      toDateController.clear();
      selectedWorkOrderController.clear();
    }
  }
  String currentSortedProperty = '';
  bool currentAscending = true;
  void sortData(String property, bool ascending) {
    if (currentSortedProperty == property && currentAscending == ascending) {
      ascending = !ascending;
    }
    currentSortedProperty = property;
    currentAscending = ascending;
    stitchingQAList.sort((a, b) {
      switch (property) {
        case 'transactionDate':
          return ascending
              ? a.transactionDate.compareTo(b.transactionDate)
              : b.transactionDate.compareTo(a.transactionDate);
        case 'offLinepcs':
          return ascending
              ? a.offLinepcs.compareTo(b.offLinepcs)
              : b.offLinepcs.compareTo(a.offLinepcs);
        case 'line':
          return ascending
              ? a.line.compareTo(b.line)
              : b.line.compareTo(a.line);
        case 'woNumber':
          return ascending
              ? a.woNumber.compareTo(b.woNumber)
              : b.woNumber.compareTo(a.woNumber);
        case 'offLinepcs':
          return ascending
              ? a.offLinepcs.compareTo(b.offLinepcs)
              : b.offLinepcs.compareTo(a.offLinepcs);
        case 'e1InspGarmentNo':
          return ascending
              ? a.e1InspGarmentNo.compareTo(b.e1InspGarmentNo)
              : b.e1InspGarmentNo.compareTo(a.e1InspGarmentNo);
        case 'e1Faultpcs':
          return ascending
              ? a.e1InspGarmentNo.compareTo(b.e1InspGarmentNo)
              : b.e1InspGarmentNo.compareTo(a.e1InspGarmentNo);
        case 'e1Otherfaultpc':
          return ascending
              ? a.e1Otherfaultpc.compareTo(b.e1Otherfaultpc)
              : b.e1Otherfaultpc.compareTo(a.e1Otherfaultpc);
        case 'e1StichDhu':
          return ascending
              ? a.e1StichDhu.compareTo(b.e1StichDhu)
              : b.e1StichDhu.compareTo(a.e1StichDhu);
        case 'otherstch':
          return ascending
              ? a.e1Otherstch.compareTo(b.e1Otherstch)
              : b.e1Otherstch.compareTo(a.e1Otherstch);

        case 'qMpInspGarmentNo':
          return ascending
              ? a.qMpInspGarmentNo.compareTo(b.qMpInspGarmentNo)
              : b.qMpInspGarmentNo.compareTo(a.qMpInspGarmentNo);
        case 'qmpFaultpcs':
          return ascending
              ? a.qmpFaultpcs.compareTo(b.qmpFaultpcs)
              : b.qmpFaultpcs.compareTo(a.qmpFaultpcs);

        case 'qmpOtherfaultpc':
          return ascending
              ? a.qmpOtherfaultpc.compareTo(b.qmpOtherfaultpc)
              : b.qmpOtherfaultpc.compareTo(a.qmpOtherfaultpc);
        case 'qmpStichDhu':
          return ascending
              ? a.qmpStichDhu.compareTo(b.qmpStichDhu)
              : b.qmpStichDhu.compareTo(a.qmpStichDhu);
        case 'qmpOtherstch':
          return ascending
              ? a.qmpOtherstch.compareTo(b.qmpOtherstch)
              : b.qmpOtherstch.compareTo(a.qmpOtherstch);

        default:
          return 0;
      }
    });
  }

}
