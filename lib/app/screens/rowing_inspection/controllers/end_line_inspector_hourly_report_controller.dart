import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../app_assets/styles/my_images.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rowing_end_line_inspector_hourly_report_model.dart';
import '../models/rowing_quality_dhu_model.dart';

class RowingEndLineInspectorHourlyReportController extends GetxController {
  final Rxn<EndLineInspectorHourlyReportListModel?> selectedOperator = Rxn<EndLineInspectorHourlyReportListModel?>();
  final RxList<EndLineInspectorHourlyReportListModel> hourlyReportList = RxList<EndLineInspectorHourlyReportListModel>();
  final RxList<RowingQualityDHUListModel> dhuList = RxList<RowingQualityDHUListModel>();
  final TextEditingController dateController = TextEditingController();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final TextEditingController workOrderController = TextEditingController();
  final TextEditingController endLineController = TextEditingController();
  EndLineInspectorHourlyReportListModel? selected;
  DateTime dateTime = DateTime.now();
  final RxBool isLoading = RxBool(true);
  RxBool autoFilterEnabled = false.obs;
  final RxString selectedLinSection = 'L15'.obs;
  final RxString selectedEndLine = 'EndLine'.obs;
  final List<String> lineSectionName = [
    'L5',
    'L12',
    'L15',
    'L25',
  ];
  final List<String> endLineName = [
    'EndLine',
    'QMP',
  ];
  RxInt totalFaultSum = 0.obs;
  @override
  void onInit() {
    selectedEndLine.value = 'All';
    dateController.text = dateFormat.format(dateTime);
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getRowingQualityFlagWithDhuReportList();
    getRowingQualityDHUList();

    super.onInit();
  }

  Future<void> getRowingQualityDHUList({
    String? date,
  }) async {
    isLoading(true);
    date ??= dateController.text;
    int selectedLine = int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    String data = "Fromdate=$date&Todate=$date&lineno=$selectedLine";
    try {
      dhuList.clear();
      List<RowingQualityDHUListModel>? responseList = await ApiFetch.getRowingQualityDHUDetail(data);
      isLoading(false);
      if (responseList != null) {
        dhuList.assignAll(responseList);
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

  Future<void> getRowingQualityFlagWithDhuReportList({
    String? date,
    String? endLine,
    String? workOrder,
    int? Unit,
  }) async {
    isLoading(true);
    date ??= dateController.text;
    Unit ??= int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    int apiValue = 2;
    if (selectedEndLine.value == 'QMP') {
      apiValue = 3;
    }
    String endLineApiValue = (selectedEndLine.value == 'All') ? '' : apiValue.toString();
    isLoading(true);
    hourlyReportList.clear();
    String data = "Workorder=${workOrderController.text}&date=${dateController.text}&Endline=$endLineApiValue&lineNo=$Unit";
    isLoading(true);
    List<EndLineInspectorHourlyReportListModel>? responseList = await ApiFetch.getRowingQualityInspectorHourlyReport(data);
    isLoading(false);
    if (responseList != null) {
      hourlyReportList.assignAll(responseList);
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
    hourlyReportList.sort((a, b) {
      switch (property) {

        case 'transDate':
          return ascending
              ? a.transDate.compareTo(b.transDate)
              : b.transDate.compareTo(a.transDate);
        case 'timeRound':
          return ascending
              ? a.timeRound.compareTo(b.timeRound)
              : b.timeRound.compareTo(a.timeRound);
        case 'lineNo':
          return ascending
              ? a.lineNo.compareTo(b.lineNo)
              : b.lineNo.compareTo(a.lineNo);
        case 'enDlineNo':
          return ascending
              ? a.enDlineNo.compareTo(b.enDlineNo)
              : b.enDlineNo.compareTo(a.enDlineNo);
        case 'woNumber':
          return ascending
              ? a.woNumber.compareTo(b.woNumber)
              : b.woNumber.compareTo(a.woNumber);
        case 'bundleQty':
          return ascending
              ? a.bundleQty.compareTo(b.bundleQty)
              : b.bundleQty.compareTo(a.bundleQty);
        case 'checkedQty':
          return ascending
              ? a.checkedQty.compareTo(b.checkedQty )
              : b.checkedQty.compareTo(a.checkedQty );
        case 'faultpcs':
          return ascending
              ? a.faultpcs.compareTo(b.faultpcs )
              : b.faultpcs.compareTo(a.faultpcs );

        default:
          return 0;
      }
    });
  }

  Future<void> pickFromDate() async {
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

  Future<Uint8List> generatePdf(PdfPageFormat format,
      List<EndLineInspectorHourlyReportListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 30;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<EndLineInspectorHourlyReportListModel> sublist = data.sublist(start, end.clamp(0, data.length));
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
                        'EndLine Inspection Hourly Reports',
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
                  columnWidths: {
                    0: const pw.FlexColumnWidth(0.9), // No #
                    1: const pw.FlexColumnWidth(1.4), // Time
                    2: const pw.FlexColumnWidth(1.4), // EndLine
                    3: const pw.FlexColumnWidth(1), // W/O
                    4: const pw.FlexColumnWidth(1.5), // Bundle #
                    5: const pw.FlexColumnWidth(2.0), // Bundle Qty
                    6: const pw.FlexColumnWidth(1.5), // Checked Qty
                    7: const pw.FlexColumnWidth(1), // Defect Qty
                    8: const pw.FlexColumnWidth(2), // Checked By
                  },
                  children: [
                    // Table header
                    pw.TableRow(
                      children: [
                        for (var header in [
                          "No #",
                          "Date",
                          "Time",
                          "Line",
                          "Inspection",
                          "W/O",
                          "Bundle QTY",
                          "Checked QTY",
                          "Fault Pcs",
                        ])
                          pw.Container(
                            alignment: pw.Alignment.center,
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              header,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 7),
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
                            dateFormat.format(DateTime.parse(
                                sublist[i].transDate.toString())),
                            sublist[i].timeRound.toString(),
                            sublist[i].lineNo.toString(),
                            sublist[i].enDlineNo.toString(),
                            sublist[i].woNumber.toString(),
                            sublist[i].bundleQty.toString(),
                            sublist[i].checkedQty.toString(),
                            sublist[i].faultpcs.toString(),
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

  Future<void> previewPdf(Uint8List pdfData) async {
    await Printing.sharePdf(bytes: pdfData, filename: 'your_pdf_filename.pdf');
  }

  /// todo: Report export into excel
  Future<void> exportToExcel(List<EndLineInspectorHourlyReportListModel> data,
      String reportName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      const TextCellValue('Date'),
      const TextCellValue('Time'),
      const TextCellValue('Line'),
      const TextCellValue('Inspection'),
      const TextCellValue('W/O'),
      const TextCellValue('Bundle QTY'),
      const TextCellValue('Checked QTY'),
      const TextCellValue('Fault Pcs'),
    ]);

    for (var item in data) {
      var date = dateFormat.format(DateTime.parse(item.transDate.toString()));
      var timeRound = item.timeRound.toString();
      var line = item.lineNo.toString();
      var inspection = item.enDlineNo.toString();
      var workOrder = item.woNumber.toString();
      var bundleQTY = item.bundleQty.toString();
      var checkedQTY = item.checkedQty.toString();
      var faultPcs = item.faultpcs.toString();

      Debug.log(
          ' date: $date   line: $timeRound  workNuber: $line  inspection: $inspection   workOrder: $workOrder bundleQTY: $bundleQTY, faultPcs: $faultPcs');

      sheet.appendRow([
        TextCellValue(date),
        TextCellValue(timeRound),
        TextCellValue(line),
        TextCellValue(inspection),
        TextCellValue(workOrder),
        TextCellValue(bundleQTY),
        TextCellValue(checkedQTY),
        TextCellValue(faultPcs),
      ]);
    }
    try {
      var bytes = excel.encode();

      var directory = await getApplicationDocumentsDirectory();
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      var fileName =
          '${reportName.replaceAll(' ', '_')}_$timestamp.xlsx'; // Use report name in the file name
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

  Future<void> autoFilter() async {
    if (autoFilterEnabled.value) {
      await getRowingQualityFlagWithDhuReportList(
        date: dateController.text,
        workOrder: workOrderController.text,
        endLine: selectedEndLine.value,
        Unit: int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),

      );
      getRowingQualityDHUList(
        date: dateController.text,
      );
    } else {
      dateController.clear();
      workOrderController.clear();
      endLineController.clear();
    }
  }
}
