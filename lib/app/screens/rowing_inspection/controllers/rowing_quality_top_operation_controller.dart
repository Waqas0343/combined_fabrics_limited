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
import '../models/rowing_quality_dhu_model.dart';
import '../models/rowing_quality_top_operation_model.dart';

class RowingQualityTopOperationController extends GetxController{
  final RxList<RowingQualityTopOperationListModel>operatorProductionList = RxList<RowingQualityTopOperationListModel>();
  final Rxn<RowingQualityTopOperationListModel?> selectedOperation = Rxn<RowingQualityTopOperationListModel?>();
  final RxList<RowingQualityDHUListModel> dhuList = RxList<RowingQualityDHUListModel>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController workOrderController = TextEditingController();
  final TextEditingController defectiveFaultController = TextEditingController();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final RxBool isLoading = RxBool(true);
  DateTime dateTime = DateTime.now();
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
  RowingQualityTopOperationListModel? selected;
  @override
  void onInit() {
    selectedEndLine.value = 'All';
    dateController.text = dateFormat.format(dateTime);
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getRowingQualityDHUList();
    getRowingQualityTopOperatorReport();
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

  Future<void> getRowingQualityTopOperatorReport({
    String? Date,
    String? Unit,
    String? endline,
    String? WorkOrder,
    int? defectiveFault,
  }) async {
    isLoading(true);
    Date ??= dateController.text;
    Unit ??= selectedLinSection.value;
    int apiValue = 2;
    if (selectedEndLine.value == 'QMP') {
      apiValue = 3;
    }
    String endLineApiValue = (selectedEndLine.value == 'All') ? '' : apiValue.toString();
    WorkOrder ??= '';
    defectiveFault ??= 5;
    String data = "date=${dateController.text}&WorkOrder=$WorkOrder&Unit=$selectedLinSection&endline=$endLineApiValue&TopRows=$defectiveFault";
    operatorProductionList.clear();
    List<RowingQualityTopOperationListModel>? responseList = await ApiFetch.getRowingQualityTopOperatorReport(data);
    isLoading(false);
    if (responseList != null) {
      operatorProductionList.assignAll(responseList);
    } else {
      Get.snackbar(
        "Message",
        'No Bundle Exist For This',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void reverseList() {
    operatorProductionList.assignAll(operatorProductionList.reversed.toList());
  }
  void setAutoFilter(bool value) {
    autoFilterEnabled.value = value;
    Get.find<Preferences>().setBool(Keys.autoFilter, value);
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


  Future<Uint8List> generatePdf(PdfPageFormat format, List<RowingQualityTopOperationListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 15;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<RowingQualityTopOperationListModel> sublist = data.sublist(start, end.clamp(0, data.length));
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
                        'EndLine Top Fault With Operation',
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
                          "EndLine",
                          "Operation",
                          "Fault",
                          "Fault Pcs",
                          "Frequency",
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
                            (dateFormat.format(DateTime.parse(sublist[i].date.toString()))),
                            sublist[i].lineNo.toString(),
                            sublist[i].wo0Rder.toString(),
                            sublist[i].endLineNo.toString(),
                            sublist[i].operationValue.toString(),
                            (sublist[i].deffects.toString()),
                            sublist[i].faultpc.toString(),
                            sublist[i].oprFrequncy.toString(),
                          ])
                            pw.Container(
                              alignment: cellData == sublist[i].deffects ? pw.Alignment.centerLeft : pw.Alignment.center,
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

  Future<void> exportToExcel(List<RowingQualityTopOperationListModel> data, String reportName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      const TextCellValue('Date'),
      const TextCellValue('Line'),
      const TextCellValue('W/O'),
      const TextCellValue('EndLine'),
      const TextCellValue('Operation'),
      const TextCellValue('Fault'),
      const TextCellValue('Fault Pcs'),
      const TextCellValue('Frequency'),
    ]);

    for (var item in data) {
      var date =
      dateFormat.format(DateTime.parse(item.date.toString()));
      var workOrder = item.lineNo.toString();
      var line = item.wo0Rder.toString();
      var machine = item.endLineNo.toString();
      var operation = item.operationValue.toString();
      var operator = item.deffects.toString(); // Treat null values as zero
      var opSequence = item.faultpc.toString();
      var round1Flag = item.oprFrequncy.toString();
      Debug.log(' date: $date   workOrder: $workOrder  line: $line  machine: $machine   operation: $operation operator: $operator, opSequence: $opSequence,  round1Flag: $round1Flag');

      sheet.appendRow([
        TextCellValue(date),
        TextCellValue(workOrder),
        TextCellValue(line),
        TextCellValue(machine),
        TextCellValue(operation),
        TextCellValue(operator),
        TextCellValue(opSequence),
        TextCellValue(round1Flag.toString()),
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

  Future<void> autoFilter() async {
    if (autoFilterEnabled.value) {

      getRowingQualityTopOperatorReport(
          Date: dateController.text.isNotEmpty ? dateController.text : '',
          Unit: selectedLinSection.value.isNotEmpty ? selectedLinSection.value : '',
          endline: selectedEndLine.value,
          WorkOrder: workOrderController.text.isNotEmpty ? workOrderController.text : '',
          defectiveFault: int.tryParse(defectiveFaultController.text) ?? 5,
      );
      getRowingQualityDHUList(
        date: dateController.text,
      );

    } else {
      dateController.clear();
      selectedLinSection.value = '';
      workOrderController.clear();
      defectiveFaultController.clear();
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
    operatorProductionList.sort((a, b) {
      switch (property) {
        case 'date':
          return ascending
              ? a.date.compareTo(b.date)
              : b.date.compareTo(a.date);
        case 'lineNo':
          return ascending
              ? a.lineNo.compareTo(b.lineNo)
              : b.lineNo.compareTo(a.lineNo);
        case 'wo0Rder':
          return ascending
              ? a.wo0Rder.compareTo(b.wo0Rder)
              : b.wo0Rder.compareTo(a.wo0Rder);
        case 'endLineNo':
          return ascending
              ? a.endLineNo.compareTo(b.endLineNo)
              : b.endLineNo.compareTo(a.endLineNo);
        case 'operationValue':
          return ascending
              ? a.operationValue.compareTo(b.operationValue)
              : b.operationValue.compareTo(a.operationValue);
        case 'deffects':
          return ascending
              ? a.deffects.compareTo(b.deffects)
              : b.deffects.compareTo(a.deffects);
        case 'oprFrequncy':
          return ascending
              ? a.oprFrequncy.compareTo(b.oprFrequncy)
              : b.oprFrequncy.compareTo(a.oprFrequncy);
        default:
          return 0;
      }
    });
  }

}