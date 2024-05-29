import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
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
import '../models/rowing_quality_end_line_bundle_reports.dart';

class EndLineBundleInspectionReportsController extends GetxController {
  final RxList<EndLineBundleReportsListModel> bundleList = RxList<EndLineBundleReportsListModel>();
  final Rxn<EndLineBundleReportsListModel?> selectedOperator = Rxn<EndLineBundleReportsListModel?>();
  final RxList<RowingQualityDHUListModel> dhuList = RxList<RowingQualityDHUListModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController selectedWorkOrderController = TextEditingController();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final TextEditingController endLineController = TextEditingController();
  final TextEditingController lineController = TextEditingController();
  DateTime dateTime = DateTime.now();
  final RxBool isLoading = RxBool(true);
  EndLineBundleReportsListModel? selected;
  final RxString selectedLinSection = 'L15'.obs;
  final RxString selectedEndLine = 'EndLine'.obs;
  RxBool autoFilterEnabled = false.obs;
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
  var isListReversed = false.obs;
  RxInt totalFaultSum = 0.obs;
  RxInt totalBundle = 0.obs;
  RxInt totalChecked = 0.obs;
  @override
  void onInit() {
    selectedEndLine.value = 'All';
    dateController.text = dateFormat.format(dateTime);
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getEndLineBundleInspection();
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

  Future<void> getEndLineBundleInspection({
    String? date,
    String? workOrder,
    String? endLine,
    int? line,
  }) async {
    isLoading(true);
    date ??= dateController.text;
    workOrder ??= '';
    line ??= 0;
    int apiValue = 2;
    if (selectedEndLine.value == 'QMP') {
      apiValue = 3;
    }
    String endLineApiValue = (selectedEndLine.value == 'All') ? '' : apiValue.toString();
    var unit = int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    String data = "Workorder=$workOrder&date=$date&Endline=$endLineApiValue&Unit=$unit";
    isLoading(true);
    bundleList.clear();
    List<EndLineBundleReportsListModel>? responseList = await ApiFetch.getRowingEndLineBundleReports(data);
    isLoading(false);
    if (responseList != null) {
      bundleList.assignAll(responseList);
    }
  }

  Future<void> pickFromDate() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(minutes: 10)),
    );
    if (date != null) {
      dateController.text = dateFormat.format(date);
      dateTime = date;
    }
  }

  Future<Uint8List> generatePdf(PdfPageFormat format, List<EndLineBundleReportsListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 25;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<EndLineBundleReportsListModel> sublist =
          data.sublist(start, end.clamp(0, data.length));
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
                        'EndLine Inspection Report',
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
                          "No #",
                          "Time",
                          "EndLine",
                          "W/O",
                          "Bundle #",
                          "Bundle Qty",
                          "Checked Qty",
                          "Defect Qty",
                          "Fault",
                          "Checked By",
                          "Bundle Status"
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
                            timeFormat.format(DateTime.parse(sublist[i].transDate.toString())),
                            sublist[i].enDlineNo.toString(),
                            sublist[i].woNumber.toString(),
                            sublist[i].bundleNo.toString(),
                            sublist[i].bundleQty.toString(),
                            sublist[i].checkedQty.toString(),
                            sublist[i].defQty.toString(),
                            sublist[i].faults.toString(),
                            sublist[i].employeeName.toString(),
                            sublist[i].bundleQty.toString() == sublist[i].checkedQty.toString()
                                ? 'Complete'
                                : 'Skipped'
                          ])
                            pw.Container(
                              alignment: pw.Alignment.centerLeft,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(
                                cellData.toString(),
                                style: const pw.TextStyle(fontSize: 7),
                              ),
                            ),
                        ],
                      ),
                    pw.TableRow(

                      children: [

                        for (var cellData in [

                          '',
                          '', '', '', '', '',
                          '',
                          'Total Defect QTY ${totalFaultSum.toStringAsFixed(0)}'
                          '',
                          '',
                          '',
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
  Future<void> exportToExcel(
      List<EndLineBundleReportsListModel> data, String reportName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      const TextCellValue('Time'),
      const TextCellValue('EndLine/Checked'),
      const TextCellValue('W/O'),
      const TextCellValue('Bundle'),
      const TextCellValue('Bundle QTY / Checked QTY'),
      const TextCellValue('Defect QTY'),
      const TextCellValue('Fault'),
      const TextCellValue('Bundle Status'),
    ]);

    for (var item in data) {
      var time = timeFormat.format(DateTime.parse(item.transDate.toString()));
      var endLineChecked =
          '${item.endLineNo.toString()} / ${item.employeeName.toString()}';
      var woNumber = item.woNumber.toString();
      var bundle = item.bundleNo.toString();
      var bundleQty =
          "${item.bundleQty.toString()} / ${item.checkedQty.toString()}";
      var defectQty = item.defQty.toString();
      var fault = item.faults.toString();
      var bundleStatus = item.bundleQty.toString() == item.checkedQty.toString()
          ? 'Complete'
          : 'Skipped';

      Debug.log(
          ' date: $time   line: $endLineChecked  workNuber: $woNumber  bundle: $bundle   bundleQty: $bundleQty defectQty: $defectQty, bundleStatus: $bundleStatus');

      sheet.appendRow([
        TextCellValue(time),
        TextCellValue(endLineChecked),
        TextCellValue(woNumber),
        TextCellValue(bundle),
        TextCellValue(bundleQty),
        TextCellValue(defectQty),
        TextCellValue(fault),
        TextCellValue(bundleStatus),
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
      await getEndLineBundleInspection(
        date: dateController.text,
        workOrder: selectedWorkOrderController.text,
        endLine: selectedEndLine.value,
        line: int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
      );
      getRowingQualityDHUList(date: dateController.text);
    } else {
      dateController.clear();
      selectedWorkOrderController.clear();
      endLineController.clear();
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
    bundleList.sort((a, b) {
      switch (property) {
        case 'transDate':
          return ascending
              ? a.transDate.compareTo(b.transDate)
              : b.transDate.compareTo(a.transDate);
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
        case 'bundleNo':
          return ascending
              ? a.bundleNo.compareTo(b.bundleNo)
              : b.bundleNo.compareTo(a.bundleNo);
        case 'bundleQty':
          return ascending
              ? a.bundleQty.compareTo(b.bundleQty)
              : b.bundleQty.compareTo(a.bundleQty);
        case 'checkedQty':
          return ascending
              ? a.checkedQty.compareTo(b.checkedQty)
              : b.checkedQty.compareTo(a.checkedQty);
        case 'defQty':
          return ascending
              ? a.defQty.compareTo(b.defQty)
              : b.defQty.compareTo(a.defQty);
        case 'faults':
          return ascending
              ? a.faults.compareTo(b.faults)
              : b.faults.compareTo(a.faults);
        case 'bundlestatus':
          String aBundle = a.bundleQty.toString() == a.checkedQty.toString()
              ? 'Complete'
              : 'Skip';
          String bBundle = b.bundleQty.toString() == b.checkedQty.toString()
              ? 'Complete'
              : 'Skip';
          return ascending
              ? aBundle.compareTo(bBundle)
              : bBundle.compareTo(aBundle);
        default:
          return 0;
      }
    });
  }

}
