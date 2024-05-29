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

class EndLineInspectorSummaryReportController extends GetxController {
  final Rxn<RowingQualityDHUListModel?> selectedOperator = Rxn<RowingQualityDHUListModel?>();
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
  RowingQualityDHUListModel? selected;
  @override
  void onInit() {
    DateTime threeDaysAgo = DateTime.now().subtract(Duration(days: 3));
    fromDateController.text = dateFormat.format(threeDaysAgo);
    dateController.text = dateFormat.format(dateTime);
    toDateController.text = dateFormat.format(dateTime);
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getRowingQualityDHUListSummary();
    super.onInit();

  }
  Future<void> getRowingQualityDHUListSummary({
    String? FromDate,
    String? ToDate,
    String? workOrder,
    int? selectedLine,
  }) async {
    isLoading(true);
    FromDate ??= fromDateController.text;
    ToDate ??= toDateController.text;
    int selectedLine = int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    workOrder ??= '';
    String data = "Fromdate=$FromDate&Todate=$ToDate&lineno=$selectedLine&WorkOrder=$workOrder";
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

  Future<Uint8List> generatePdf(PdfPageFormat format, List<RowingQualityDHUListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 13;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<RowingQualityDHUListModel> sublist = data.sublist(start, end.clamp(0, data.length));
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
                        'EEndLine Date Wise Summary Reports',
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
                          "Line",
                          "W/O",
                          "EL\nEmpCode / Name",
                          "EL\nCheck Pcs",
                          "EL\nDef Pcs",
                          "EL\nS.D / S.DHU%",
                          "EL\nO.D / O. DHU%",
                          "QMP\nEmp / Name",
                          "QMP\nCheck Pcs",
                          "QMP\nDefPcs",
                          "QMP\nS.D/S.DHU%",
                          "QMP\nO.D /O.DHU%",
                          "Total\nChecked",

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
                            sublist[i].line.toString(),
                            sublist[i].woNumber.toString(),
                           '${sublist[i].elEmpid.toString()} / ${sublist[i].elInspectorName.toString()}',
                            sublist[i].elInspGarmentNo.toString(),
                            sublist[i].elFaultpcs.toString(),
                            '${sublist[i].elStichfaultpc.toString()} / ${sublist[i].elStichDhu.toString()}',
                            '${sublist[i].elOtherfaultpc.toString()} / ${sublist[i].elOtherstchDhu.toString()}',
                            '${sublist[i].qmEmpid.toString()} / ${sublist[i].qmInspectorName.toString()}',
                            sublist[i].qmInspGarmentNo.toString(),
                            sublist[i].qmFaultpcs.toString(),
                            '${sublist[i].qmStichfaultpc.toString()} / ${sublist[i].qmStichDhu.toString()}',
                            '${sublist[i].qmOtherfaultpc.toString()} / ${sublist[i].qmOtherstchDhu.toString()}',
                            (sublist[i].elInspGarmentNo+sublist[i].qmInspGarmentNo),

                          ])
                            pw.Container(
                              alignment: cellData == sublist[i].elEmpid ? pw.Alignment.centerLeft : pw.Alignment.center,
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
  Future<void> exportToExcel(List<RowingQualityDHUListModel> data,  String reportName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      const TextCellValue('Line'),
      const TextCellValue('W/O'),
      const TextCellValue('EL\nEmpCode / Name'),
      const TextCellValue('EL\nCheck Pcs'),
      const TextCellValue('EL\nDef Pcs'),
      const TextCellValue('EL\nS.D / S.DHU%'),
      const TextCellValue('EL\nO.D / O. DHU%'),
      const TextCellValue('QMP\nEmp / Name'),
      const TextCellValue('QMP\nCheck Pcs'),
      const TextCellValue('QMP\nDefPcs'),
      const TextCellValue('QMP\nS.D/S.DHU%'),
      const TextCellValue('QMP\nO.D /O.DHU%'),
    ]);

    for (var item in data) {
      var line = item.line.toString();
      var woNumber = item.woNumber.toString();
      var empName = '${item.elEmpid.toString()} / ${item.elInspectorName.toString()}';
      var elInspPcs = item.elInspGarmentNo.toString();
      var elFaultpcs = item.elFaultpcs.toString();
      var stitchDHU =  '${item.elStichfaultpc.toString()} / ${item.elStichDhu.toString()}';
      var otherDHU =  '${item.elOtherfaultpc.toString()} / ${item.elOtherstchDhu.toString()}';
      var qmpEmpName = '${item.qmEmpid.toString()} / ${item.qmInspectorName.toString()}';
      var qmpInspPcs =  item.qmInspGarmentNo.toString();
      var qmpFaultPcs =  item.qmFaultpcs.toString();
      var qmpStDHU =  '${item.qmStichfaultpc.toString()} / ${item.qmStichDhu.toString()}';
      var qmpOthDHU =  '${item.qmOtherfaultpc.toString()} / ${item.qmOtherstchDhu.toString()}';

      Debug.log(' line: $line  workNuber: $woNumber  checkPcs: $empName   defectPcs: $elInspPcs stitchingDHU: $stitchDHU, otherDHU: $otherDHU');

      sheet.appendRow([
        TextCellValue(line),
        TextCellValue(woNumber),
        TextCellValue(empName),
        TextCellValue(elInspPcs),
        TextCellValue(elFaultpcs.toString()),
        TextCellValue(stitchDHU),
        TextCellValue(otherDHU),
        TextCellValue(qmpEmpName),
        TextCellValue(qmpInspPcs),
        TextCellValue(qmpFaultPcs),
        TextCellValue(qmpStDHU),
        TextCellValue(qmpOthDHU),
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
      getRowingQualityDHUListSummary(
        FromDate: fromDateController.text,
        ToDate: toDateController.text,
        workOrder: selectedWorkOrderController.text,
        selectedLine: int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
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
    dhuSummaryList.sort((a, b) {
      switch (property) {
        case 'transactionDate':
          return ascending
              ? a.line.compareTo(b.line)
              : b.line.compareTo(a.line);
        case 'woNumber':
          return ascending
              ? a.woNumber.compareTo(b.woNumber)
              : b.woNumber.compareTo(a.woNumber);
        case 'elEmpid':
          return ascending
              ? a.elEmpid.compareTo(b.elEmpid)
              : b.elEmpid.compareTo(a.elEmpid);
        case 'woNumber':
          return ascending
              ? a.woNumber.compareTo(b.woNumber)
              : b.woNumber.compareTo(a.woNumber);
        case 'elInspGarmentNo':
          return ascending
              ? a.elInspGarmentNo.compareTo(b.elInspGarmentNo)
              : b.elInspGarmentNo.compareTo(a.elInspGarmentNo);
        case 'elFaultpcs':
          return ascending
              ? a.elFaultpcs.compareTo(b.elFaultpcs)
              : b.elFaultpcs.compareTo(a.elFaultpcs);
        case 'elOtherfaultpc':
          return ascending
              ? a.elOtherfaultpc.compareTo(b.elOtherfaultpc)
              : b.elOtherfaultpc.compareTo(a.elOtherfaultpc);
        case 'elStichDhu':
          return ascending
              ? a.elStichDhu.compareTo(b.elStichDhu)
              : b.elStichDhu.compareTo(a.elStichDhu);
        case 'elOtherstchDhu':
          return ascending
              ? a.elOtherstchDhu.compareTo(b.elOtherstchDhu)
              : b.elOtherstchDhu.compareTo(a.elOtherstchDhu);
        case 'qmInspectorName':
          return ascending
              ? a.qmInspectorName.compareTo(b.qmInspectorName)
              : b.qmInspectorName.compareTo(a.qmInspectorName);

        case 'qmInspGarmentNo':
          return ascending
              ? a.qmInspGarmentNo.compareTo(b.qmInspGarmentNo)
              : b.qmInspGarmentNo.compareTo(a.qmInspGarmentNo);
        case 'qmFaultpcs':
          return ascending
              ? a.qmFaultpcs.compareTo(b.qmFaultpcs)
              : b.qmFaultpcs.compareTo(a.qmFaultpcs);

        case 'qmStichDhu':
          return ascending
              ? a.qmStichDhu.compareTo(b.qmStichDhu)
              : b.qmStichDhu.compareTo(a.qmStichDhu);
        case 'qmOtherstchDhu':
          return ascending
              ? a.qmOtherstchDhu.compareTo(b.qmOtherstchDhu)
              : b.qmOtherstchDhu.compareTo(a.qmOtherstchDhu);
        default:
          return 0;
      }
    });
  }

}
