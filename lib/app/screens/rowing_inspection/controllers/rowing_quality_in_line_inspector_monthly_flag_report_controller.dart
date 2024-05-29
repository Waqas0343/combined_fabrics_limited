import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../app_assets/styles/my_images.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rowing_operator_monthly_flag_report_model.dart';
import '../models/rowing_quality_flag_color_model.dart';
import '../models/rowing_quality_inline_inspection_form_model.dart';

class InLineInspectorMonthlyFlagReportController extends GetxController{
  final RxList<RowingQualityInlineInspectionFormListModel> workerAndOrderList = RxList<RowingQualityInlineInspectionFormListModel>();
  final Rxn<RowingQualityInlineInspectionFormListModel?> selectOperatorAccordingToUnit = Rxn<RowingQualityInlineInspectionFormListModel?>();
  final RxList<InLineInspectorMonthlyFlagReportListModel> monthlyReportList = RxList<InLineInspectorMonthlyFlagReportListModel>();
  final Rxn<InLineInspectorMonthlyFlagReportListModel?> selectedOperator = Rxn<InLineInspectorMonthlyFlagReportListModel?>();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController lineOrderController = TextEditingController();
  final TextEditingController operatorController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final RxList<FlagColorListModel> flagColorList = RxList<FlagColorListModel>();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  Rx<FlagColorListModel?> selectedFlag = Rx<FlagColorListModel?>(null);
  final RxBool isLoading = RxBool(true);
  DateTime dateTime = DateTime.now();
  RxBool autoFilterEnabled = false.obs;
  final RxString selectedLinSection = 'L15'.obs;
  InLineInspectorMonthlyFlagReportListModel? selected;
  RowingQualityInlineInspectionFormListModel? selectedOperatorAccordingToUnit;
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
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getRowingQualityInlineInspectionFormList(selectedLinSection.value);
    getRowingQualityFlag();
    getRowingQualityMonthlyFlagReport();
    super.onInit();
  }

  Future<void> getRowingQualityMonthlyFlagReport({
    String? fromDate,
    String? toDate,
    int? line,
    String? operator,
    String? flags, // Change the type to List<String>
  }) async {
    isLoading(true);
    fromDate ??= '';
    toDate ??= '';
    line ??= 0;
    operator ??= '';
    flags ??= '';
    String encodedFlag = Uri.encodeQueryComponent(flags ?? '');
    var unit = int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    String data = "FromDate=${fromDateController.text}&Todate=${toDateController.text}&lineno=$unit&flag=$encodedFlag&empcode=$operator";
    isLoading(true);
    monthlyReportList.clear();
    List<InLineInspectorMonthlyFlagReportListModel>? responseList = await ApiFetch.getRowingQualityOperatorMonthlyFlagReport(data);
    isLoading(false);
    if (responseList != null) {
      monthlyReportList.assignAll(responseList);
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

  Future<void> getRowingQualityFlag() async {
    isLoading(true);
    List<FlagColorListModel>? responseList = await ApiFetch.getRowingQualityFlagColor();
    isLoading(false);
    if (responseList != null) {
      flagColorList.assignAll(responseList);
    }
  }
  void setAutoFilter(bool value) {
    autoFilterEnabled.value = value;
    Get.find<Preferences>().setBool(Keys.autoFilter, value);
  }
  String currentSortedProperty = '';
  bool currentAscending = true;
  void sortData(String property, bool ascending) {
    if (currentSortedProperty == property && currentAscending == ascending) {
      ascending = !ascending;
    }
    currentSortedProperty = property;
    currentAscending = ascending;
    monthlyReportList.sort((a, b) {
      switch (property) {
        case 'transactionDate':
          return ascending
              ? a.transactionDate.compareTo(b.transactionDate)
              : b.transactionDate.compareTo(a.transactionDate);
        case 'line':
          return ascending
              ? a.lineNo.compareTo(b.lineNo)
              : b.lineNo.compareTo(a.lineNo);
        case 'red':
          return ascending
              ? a.red.compareTo(b.red)
              : b.red.compareTo(a.red);
        case 'empoperationcode':
          return ascending
              ? a.empOperatorCode.compareTo(b.empOperatorCode)
              : b.empOperatorCode.compareTo(a.empOperatorCode);
        case 'operation':
          return ascending
              ? a.operationname.compareTo(b.operationname)
              : b.operationname.compareTo(a.operationname);
        case 'work-order':
          return ascending
              ? a.woDetails.compareTo(b.woDetails)
              : b.woDetails.compareTo(a.woDetails);
        case 'redNoflg':
          return ascending
              ? a.redNoflg.compareTo(b.redNoflg )
              : b.redNoflg.compareTo(a.redNoflg );
        case 'yellowNoflg':
          return ascending
              ? a.yellowNoflg.compareTo(b.yellowNoflg )
              : b.yellowNoflg.compareTo(a.yellowNoflg );
        case 'redyellow':
          return ascending
              ? a.redNoflg.compareTo(b.redNoflg )
              : b.redNoflg.compareTo(a.redNoflg );
        case 'remarks':
          return ascending
              ? a.remarks.compareTo(b.remarks )
              : b.remarks.compareTo(a.remarks );
        default:
          return 0;
      }
    });
  }





  Future<Uint8List> generatePdf(PdfPageFormat format, List<InLineInspectorMonthlyFlagReportListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 22;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<InLineInspectorMonthlyFlagReportListModel> sublist = data.sublist(start, end.clamp(0, data.length));
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
                        'InLine Inspector Monthly Flag Detail Report',
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
                          "Flag",
                          "OperatorCode-Name",
                          "Operation",
                          "W/O",
                          "No. Red Flag",
                          "No. Yellow Flag",
                          "Total Flag",
                          "Reason"
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
                            dateFormat.format(DateTime.parse(sublist[i].transactionDate.toString())),
                            sublist[i].lineNo.toString(),
                            sublist[i].red.toString().isNotEmpty ? sublist[i].red.toString() :sublist[i].yellow.toString(),
                            "${sublist[i].empOperatorCode.toString()} - ${sublist[i].employeeName.toString()}",
                            sublist[i].operationname.toString(),
                            sublist[i].woDetails.toString(),
                            sublist[i].redNoflg.toString(),
                            sublist[i].yellowNoflg.toString(),
                            sublist[i].redNoflg + sublist[i].yellowNoflg,
                            sublist[i].remarks.toString(),
                          ])
                            pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(
                                cellData.toString(), // Convert to String
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
      List<InLineInspectorMonthlyFlagReportListModel> data,  String reportName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      const TextCellValue('Date'),
      const TextCellValue('Line'),
      const TextCellValue('Flag'),
      const TextCellValue('OperatorCode-Name'),
      const TextCellValue('Operation'),
      const TextCellValue('W/O'),
      const TextCellValue('No. Red Flag'),
      const TextCellValue('No. Yellow Flag'),
      const TextCellValue('Total Flag'),
      const TextCellValue('Reason')
    ]);

    for (var item in data) {
      var date =
      dateFormat.format(DateTime.parse(item.transactionDate.toString()));
      var empOperatorCode = item.lineNo.toString();
      var inspectername = item.red.isNotEmpty ? item.red.toString():item.yellow;
      var woOrders = '${item.empOperatorCode.toString()} - ${item.employeeName.toString()}';
      var operationname = item.operationname.toString();
      var flag = item.woDetails.toString();
      var inspGarmentNo = item.redNoflg.toString();
      var faultpcs = item.yellowNoflg.toString();
      var dhu =  item.redNoflg.toString() + item.yellowNoflg.toString();
      var bundleStatus = item.remarks.toString();

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

  Future<void> autoFilter() async {
    if (autoFilterEnabled.value) {
      await getRowingQualityMonthlyFlagReport(
        fromDate: fromDateController.text,
        toDate: toDateController.text,
        line: int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
        operator: operatorController.text,
        flags: selectedFlag.value?.shortName ?? '',
      );
    } else {
      operatorController.clear();
      fromDateController.clear();
      toDateController.clear();
      lineOrderController.clear();
    }
  }







}