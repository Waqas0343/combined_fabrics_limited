import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
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
import '../models/rowing_quality_flag_color_model.dart';
import '../models/rowing_quality_in_line_flag_with_dhu_report.dart';
import '../models/rowing_quality_inline_inspection_form_model.dart';

class InLineFlagReportsController extends GetxController {
  final RxList<RowingQualityInlineInspectionFormListModel> workerAndOrderList = RxList<RowingQualityInlineInspectionFormListModel>();
  final Rxn<RowingQualityInlineInspectionFormListModel?> selectOperatorAccordingToUnit = Rxn<RowingQualityInlineInspectionFormListModel?>();
  final Rxn<RowingQualityInLineFlagWithDHUListModel?> selectedOperator = Rxn<RowingQualityInLineFlagWithDHUListModel?>();
  final RxList<RowingQualityInLineFlagWithDHUListModel> reportsFlagList = RxList<RowingQualityInLineFlagWithDHUListModel>();
  final RxList<FlagColorListModel> flagColorList = RxList<FlagColorListModel>();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController empCodeController = TextEditingController();
  final TextEditingController operationController = TextEditingController();
  final TextEditingController flagController = TextEditingController();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final TextEditingController workOrderController = TextEditingController();
  Rx<FlagColorListModel?> selectedFlag = Rx<FlagColorListModel?>(null);
  RowingQualityInLineFlagWithDHUListModel? selected;
  RowingQualityInlineInspectionFormListModel? selectedOperatorAccordingToUnit;
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
  @override
  void onInit() {
    fromDateController.text = dateFormat.format(dateTime);
    toDateController.text = dateFormat.format(dateTime);
    getRowingQualityInlineInspectionFormList(selectedLinSection.value);
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getRowingQualityFlagWithDhuReportList();
    getRowingQualityFlag();
    super.onInit();
  }

  Future<void> getRowingQualityFlagWithDhuReportList({
    String? fromDate,
    String? todate,
    String? empcode,
    String? opration,
    String? flags,
    int? linSection,
  }) async {
    isLoading(true);
    fromDate ??= fromDateController.text;
    todate ??= toDateController.text;
    empcode ??= '';
    opration ??= '';
    flags ??= '';
    linSection ??= 0;
    String encodedFlag = Uri.encodeQueryComponent(flags ?? '');
    var line = int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    String data = "FromDate=$fromDate&Todate=$todate&empcode=$empcode&opration=$opration&flag=$encodedFlag&line=${line}";
    isLoading(true);
    reportsFlagList.clear();
    List<RowingQualityInLineFlagWithDHUListModel>? responseList = await ApiFetch.getRowingQualityFlagWithDhuReport(data);
    isLoading(false);
    if (responseList != null) {
      reportsFlagList.assignAll(responseList);
    }
  }
  Future<void> getRowingQualityInlineInspectionFormList(String selectedValue) async {
    String param = "unit=$selectedValue";
    isLoading(true);
    List<RowingQualityInlineInspectionFormListModel>? responseList = await ApiFetch.getRowingQualityInlineInspectionFormList(param);
    isLoading(false);
    if (responseList != null) {
      workerAndOrderList.assignAll(responseList);
    }
  }
  Future<void> getRowingQualityFlag() async {
    isLoading(true);
    List<FlagColorListModel>? responseList = await ApiFetch.getRowingQualityFlagColor();
    isLoading(false);
    if (responseList != null) {
      flagColorList.assignAll(responseList);
    }
  }

  Future<Uint8List> generatePdf(PdfPageFormat format, List<RowingQualityInLineFlagWithDHUListModel> data)  async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 25;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      pdf.addPage(
        pw.Page(
          pageFormat: format.copyWith(
            marginLeft: 10,
            marginRight: 10,
            marginBottom: 10,
            marginTop: 10,
          ).landscape,
          build: (context) {
            final int start = (page - 1) * itemsPerPage;
            final int end = start + itemsPerPage;
            final List<RowingQualityInLineFlagWithDHUListModel> sublist =
            data.sublist(start, end.clamp(0, data.length));
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
                        'Daily 7.0 Flag Report Detail',
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
                          "Line#",
                          "No",
                          "Date",
                          "Operator",
                          "Operator Name",
                          "Work Order",
                          "Operation",
                          "Round",
                          "Tag",
                          "Check",
                          "Total Flt",
                          "DHU%",
                          "Faults",
                          "Reason",
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
                            sublist[i].lineNo.toString(),
                            (start + i + 1).toString(),
                            dateFormat.format(DateTime.parse(sublist[i].transactionDate.toString())),
                            sublist[i].empOperatorCode.toString(),
                            sublist[i].inspectername.toString(),
                            sublist[i].woOrders.toString(),
                            sublist[i].operationname.toString(),
                            sublist[i].roundNo.toString(),
                            sublist[i].flag.toString(),
                            sublist[i].inspGarmentNo.toString(),
                            sublist[i].faultpcs.toString(),
                           '${ sublist[i].dhu.toStringAsFixed(1)}%',
                            sublist[i].cFaults.toString(),
                            sublist[i].reasons.toString(),
                          ])
                            pw.Container(
                              alignment: cellData == sublist[i].operationname ? pw.Alignment.centerLeft : pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(
                                cellData,
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
  Future<void> exportToExcel(
      List<RowingQualityInLineFlagWithDHUListModel> data,  String reportName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      const TextCellValue('Date'),
      const TextCellValue('Operator'),
      const TextCellValue('Operator Name'),
      const TextCellValue('W/O'),
      const TextCellValue('Operation'),
      const TextCellValue('Tag'),
      const TextCellValue('Check'),
      const TextCellValue('Total Flt'),
      const TextCellValue('DHU'),
      const TextCellValue('Faults')
    ]);

    for (var item in data) {
      var date =
          dateFormat.format(DateTime.parse(item.transactionDate.toString()));
      var empOperatorCode = item.empOperatorCode.toString();
      var inspectername = item.inspectername.toString();
      var woOrders = item.woOrders.toString();
      var operationname = item.operationname.toString();
      var flag = item.flag.toString();
      var inspGarmentNo = item.inspGarmentNo.toString();
      var faultpcs = item.faultpcs.toString();
      var dhu = item.dhu.toString();
      var bundleStatus = item.cFaults.toString();

      Debug.log(
          'date: $date   empOperatorCode: $empOperatorCode  inspectername: $inspectername  woOrders: $woOrders   operationname: $operationname flag: $flag, inspGarmentNo: $inspGarmentNo  faultpcs :$faultpcs  dhu: $dhu  bundleStatus: $bundleStatus');

      sheet.appendRow([
        TextCellValue(date),
        TextCellValue(empOperatorCode),
        TextCellValue(inspectername),
        TextCellValue(woOrders),
        TextCellValue(operationname),
        TextCellValue(flag),
        TextCellValue(inspGarmentNo),
        TextCellValue(faultpcs),
        TextCellValue(dhu),
        TextCellValue(bundleStatus),
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

  String currentSortedProperty = '';
  bool currentAscending = true;
  void sortData(String property, bool ascending) {
    if (currentSortedProperty == property && currentAscending == ascending) {
      ascending = !ascending;
    }
    currentSortedProperty = property;
    currentAscending = ascending;
    reportsFlagList.sort((a, b) {
      switch (property) {
        case 'transactionDate':
          return ascending
              ? a.transactionDate.compareTo(b.transactionDate)
              : b.transactionDate.compareTo(a.transactionDate);
        case 'lineNo':
          return ascending
              ? a.lineNo.compareTo(b.lineNo)
              : b.lineNo.compareTo(a.lineNo);

        case 'empoperationcode':
          return ascending
              ? a.empOperatorCode.compareTo(b.empOperatorCode)
              : b.empOperatorCode.compareTo(a.empOperatorCode);
        case 'inspectername':
          return ascending
              ? a.inspectername.compareTo(b.inspectername)
              : b.inspectername.compareTo(a.inspectername);
        case 'workorder':
          return ascending
              ? a.woOrders.compareTo(b.woOrders)
              : b.woOrders.compareTo(a.woOrders);
        case 'operationname':
          return ascending
              ? a.operationname.compareTo(b.operationname)
              : b.operationname.compareTo(a.operationname);
        case 'flag':
          return ascending
              ? a.flag.compareTo(b.flag)
              : b.flag.compareTo(a.flag);
        case 'inspGarmentNo':
          return ascending
              ? a.inspGarmentNo.compareTo(b.inspGarmentNo)
              : b.inspGarmentNo.compareTo(a.inspGarmentNo);
        case 'faultpices':
          return ascending
              ? a.faultpcs.compareTo(b.faultpcs)
              : b.faultpcs.compareTo(a.faultpcs);
        case 'dhu':
          return ascending
              ? a.dhu.compareTo(b.dhu)
              : b.dhu.compareTo(a.dhu);
        case 'cFaults':
          return ascending
              ? a.cFaults.compareTo(b.cFaults)
              : b.cFaults.compareTo(a.cFaults);
        case 'reasons':
          return ascending
              ? a.reasons.compareTo(b.reasons)
              : b.reasons.compareTo(a.reasons);
        default:
          return 0;
      }
    });
  }

  void setAutoFilter(bool value) {
    autoFilterEnabled.value = value;
    Get.find<Preferences>().setBool(Keys.autoFilter, value);
  }

  Future<void> autoFilter() async {
    if (autoFilterEnabled.value) {
      await getRowingQualityFlagWithDhuReportList(
        fromDate: fromDateController.text,
        todate: toDateController.text,
        empcode: empCodeController.text,
        opration: operationController.text,
        flags:  selectedFlag.value?.shortName ?? '',
        linSection: int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
      );
    } else {
      fromDateController.clear();
      toDateController.clear();
      empCodeController.clear();
      operationController.clear();
    }
  }
}
