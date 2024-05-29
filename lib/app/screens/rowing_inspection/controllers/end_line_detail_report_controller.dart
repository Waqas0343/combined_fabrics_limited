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
import '../models/rowing_quality_dhu_model.dart';
import '../models/rowing_quality_end_line_report_detail_model.dart';

class EndLineDetailReportController extends GetxController {
  final RxList<RowingQualityReportDetailListModel> workerAndOrderList = RxList<RowingQualityReportDetailListModel>();
  final Rxn<RowingQualityReportDetailListModel?> selectedOperator = Rxn<RowingQualityReportDetailListModel?>();
  final RxList<RowingQualityDHUListModel> dhuSummaryList = RxList<RowingQualityDHUListModel>();
  final RxList<RowingQualityReportDetailListModel> reportList = RxList<RowingQualityReportDetailListModel>();
  final TextEditingController workOrderController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final TextEditingController defectiveFaultController = TextEditingController();
  var selectedComparisonOperator = '>'.obs;
  DateTime dateTime = DateTime.now();
  final RxBool isLoading = RxBool(true);
  RxBool autoFilterEnabled = false.obs;
  RxInt totalBundle = 0.obs;
  RxInt totalChecked = 0.obs;
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
  RowingQualityReportDetailListModel? selected;

  @override
  void onInit() {
    selectedEndLine.value = 'All';
    dateController.text = dateFormat.format(dateTime);
    autoFilterEnabled.value =
        Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getRowingQualityEndLineDetailList();
    getRowingQualityDHUListSummary();
    super.onInit();
  }

  Future<void> getRowingQualityDHUListSummary({
    String? date,
  }) async {
    isLoading(true);
    date ??= dateController.text;
    int selectedLine =
        int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    String data = "Fromdate=$date&Todate=$date&lineno=$selectedLine";
    try {
      dhuSummaryList.clear();
      List<RowingQualityDHUListModel>? responseList =
          await ApiFetch.getRowingQualityDHUDetail(data);
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

  Future<void> getRowingQualityEndLineDetailList({
    String? Date,
    String? Unit,
    String? endline,
    String? WorkOrder,
    String? defectiveFault,
  }) async {
    isLoading(true);
    Date ??= dateController.text;
    Unit ??= selectedLinSection.value;
    int apiValue = 2;
    if (selectedEndLine.value == 'QMP') {
      apiValue = 3;
    }
    String endLineApiValue =
        (selectedEndLine.value == 'All') ? '' : apiValue.toString();
    WorkOrder ??= '';
    defectiveFault ??= '';
    String encodedComparisonOperator =
        Uri.encodeComponent(selectedComparisonOperator.value);
    String data = "date=$Date&Unit=$Unit&endline=$endLineApiValue&WorkOrder=$WorkOrder&faultpcs=$defectiveFault&Agg_sing=$encodedComparisonOperator";
    reportList.clear();
    try {
      List<RowingQualityReportDetailListModel>? responseList =
          await ApiFetch.getRowingEndLineReportsDetail(data);
      isLoading(false);
      if (responseList != null) {
        reportList.assignAll(responseList);
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

  Future<Uint8List> generatePdf(
      PdfPageFormat format,
      List<RowingQualityReportDetailListModel> data,
      List<RowingQualityDHUListModel> dhuSummaryList) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 35;
    final int totalPages = (data.length / itemsPerPage).ceil();

    // Summary report page
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
                      'EndLine Work Order Wise Summary Report',
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
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      for (var header in [
                        "W/o",
                        "Prod Pcs",
                        "EndLin\nChecked Pcs",
                        "EndLine\nDefects",
                        "EndLine\nS.Def/S.DHU %",
                        "EndLine\nO.Def/O.DHU %",
                        "QMP\nChecked Pcs",
                        "QMP\nDefects",
                        "QMP\nS.D/S.DHU%",
                        "QMP\nO.Def/O.DHU%",
                        "Total Checked"
                      ])
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(
                            header,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 7),
                          ),
                        ),
                    ],
                  ),
                  for (var dhuSummary in dhuSummaryList)
                    pw.TableRow(
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            dhuSummary.woNumber,
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            dhuSummary.elBundleQty.toString(),
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            dhuSummary.elInspGarmentNo.toString(),
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            dhuSummary.elFaultpcs.toString(),
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            '${dhuSummary.elStichfaultpc.toString()} /${dhuSummary.elStichDhu.toStringAsFixed(1)}%',
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            '${dhuSummary.elOtherfaultpc.toString()} /${dhuSummary.elOtherstchDhu.toStringAsFixed(1)}%',
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            dhuSummary.qmInspGarmentNo.toString(),
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            dhuSummary.qmFaultpcs.toString(),
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            '${dhuSummary.qmStichfaultpc.toString()} /${dhuSummary.qmStichDhu.toStringAsFixed(1)}%',
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            '${dhuSummary.qmOtherfaultpc.toString()} /${dhuSummary.qmOtherstchDhu.toStringAsFixed(1)}%',
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            (dhuSummary.elInspGarmentNo +
                                dhuSummary.qmInspGarmentNo)
                                .toStringAsFixed(0),
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

    // Detail report pages
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<RowingQualityReportDetailListModel> sublist =
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
                        'EndLine Detail Report',
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
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        for (var header in [
                          "No#",
                          "Date",
                          "Line#",
                          "EndLine",
                          "Inspector",
                          "B#/Pcs/Checked",
                          "Ok Pcs",
                          "Defect Pcs",
                          "Defect-Detail",
                          "Operation",
                          "Operator",
                          "M/C"
                        ])
                          pw.Container(
                            alignment: pw.Alignment.center,
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Text(
                              header,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 7),
                            ),
                          ),
                      ],
                    ),
                    for (var i = 0; i < sublist.length; i++)
                      pw.TableRow(
                        children: [
                          for (var cellData in [
                            (start + i + 1).toString(),
                            "${dateFormat.format(DateTime.parse(sublist[i].transactionDate.toString()))}\t\t${timeFormat.format(DateTime.parse(sublist[i].transactionDate.toString()))}",
                            sublist[i].lineNo.toString(),
                            sublist[i].endLineNo.toString(),
                            sublist[i].inspecter.toString(),
                            "${sublist[i].bundleNo.toString()} / ${sublist[i].totalpcs.toString()} / ${sublist[i].checkpc.toString()}",
                            sublist[i].checkpc.toString(),
                            sublist[i].faultpc.toString(),
                            sublist[i].faults.toString(),
                            sublist[i].operationValue.toString(),
                            sublist[i].opretor.toString(),
                            sublist[i].machine.toString()
                          ])
                            pw.Container(
                              alignment: cellData == sublist[i].faults
                                  ? pw.Alignment.centerLeft
                                  : pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(2),
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

  ///todo:    File Export into Excel
  Future<void> exportToExcel(
      List<RowingQualityReportDetailListModel> data, String reportName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      const TextCellValue('Date'),
      const TextCellValue('Line'),
      const TextCellValue('EndLine'),
      const TextCellValue('Inspector'),
      const TextCellValue('Bundle#'),
      const TextCellValue('Bundle QTY / CheckedPcs'),
      const TextCellValue('Defect Pcs'),
      const TextCellValue('DefectDetail'),
      const TextCellValue('Operation'),
      const TextCellValue('Operator'),
      const TextCellValue('Machine'),
      const TextCellValue('Inspector')
    ]);

    for (var item in data) {
      var date =
          "${dateFormat.format(DateTime.parse(item.transactionDate.toString()))} ${timeFormat.format(DateTime.parse(item.transactionDate.toString()))}";
      var line = item.lineNo.toString();
      var endLine = item.endLineNo.toString();
      var inspector = item.inspecter.toString();
      var bundle = item.bundleNo.toString();
      var bundleChecked =
          "${item.totalpcs.toString()} / ${item.checkpc.toString()}"; // Treat null values as zero\
      var faultpc = item.faultpc.toString();
      var defectDetail = item.faults.toString();
      var operation = item.operationValue.toString();
      var operator = item.opretor.toString();
      var machine = item.machine.toString();
      var inspectorD = item.inspecter.toString();

      Debug.log(
          ' date: $date   line: $line  endLine: $endLine  inspector: $inspector   bundle: $bundle bundleChecked: $bundleChecked, checkedPcs:  $defectDetail  operation: $operation   operator: $operator  machine: $machine');

      sheet.appendRow([
        TextCellValue(date),
        TextCellValue(line),
        TextCellValue(endLine),
        TextCellValue(inspector),
        TextCellValue(bundle),
        TextCellValue(bundleChecked),
        TextCellValue(faultpc),
        TextCellValue(defectDetail.toString()),
        TextCellValue(operation.toString()),
        TextCellValue(operator.toString()),
        TextCellValue(machine.toString()),
        TextCellValue(inspectorD.toString()),
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
      getRowingQualityEndLineDetailList(
          Date: dateController.text.isNotEmpty ? dateController.text : '',
          Unit: selectedLinSection.value.isNotEmpty
              ? selectedLinSection.value
              : '',
          endline: selectedEndLine.value,
          WorkOrder: workOrderController.text.isNotEmpty
              ? workOrderController.text
              : '',
          defectiveFault: defectiveFaultController.text);
      getRowingQualityDHUListSummary(date: dateController.text);
    } else {
      dateController.clear();
      selectedLinSection.value = '';
      workOrderController.clear();
      defectiveFaultController.clear();
    }
  }

  void setSelectedComparisonOperator(String newValue) {
    selectedComparisonOperator.value = newValue;
  }

  String currentSortedProperty = '';
  bool currentAscending = true;

  void sortData(String property, bool ascending) {
    if (currentSortedProperty == property && currentAscending == ascending) {
      ascending = !ascending;
    }
    currentSortedProperty = property;
    currentAscending = ascending;
    reportList.sort((a, b) {
      switch (property) {
        case 'transactionDate':
          return ascending
              ? a.transactionDate.compareTo(b.transactionDate)
              : b.transactionDate.compareTo(a.transactionDate);
        case 'endLineNo':
          return ascending
              ? a.endLineNo.compareTo(b.endLineNo)
              : b.endLineNo.compareTo(a.endLineNo);
        case 'woorder':
          return ascending
              ? a.wo0Rder.compareTo(b.wo0Rder)
              : b.wo0Rder.compareTo(a.wo0Rder);
        case 'faultpc':
          return ascending
              ? a.faultpc.compareTo(b.faultpc)
              : b.faultpc.compareTo(a.faultpc);
        case 'faults':
          return ascending
              ? a.faults.compareTo(b.faults)
              : b.faults.compareTo(a.faults);
        case 'operationValue':
          return ascending
              ? a.operationValue.compareTo(b.operationValue)
              : b.operationValue.compareTo(a.operationValue);
        case 'opretor':
          return ascending
              ? a.opretor!.compareTo(b.opretor!)
              : b.opretor!.compareTo(a.opretor!);
        case 'machine':
          return ascending
              ? a.machine!.compareTo(b.machine!)
              : b.machine!.compareTo(a.machine!);
        case 'inspecter':
          return ascending
              ? a.inspecter.compareTo(b.inspecter)
              : b.inspecter.compareTo(a.inspecter);
        default:
          return 0;
      }
    });
  }
}
