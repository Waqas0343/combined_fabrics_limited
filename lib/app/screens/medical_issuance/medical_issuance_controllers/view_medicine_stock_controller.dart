import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../../app_assets/styles/my_images.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../medical_issuance_model/medicine_list_model.dart';
import '../medical_issuance_model/medicine_stock_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class MedicineStockController extends GetxController {
  final RxList<MedicineStockListModel> medicineList = <MedicineStockListModel>[].obs;
  final TextEditingController searchController = TextEditingController();
  RxList<MedicineListModel> filteredMedicineList = <MedicineListModel>[].obs;
  final TextEditingController dateController = TextEditingController();
  final RxBool isLoading = RxBool(true);
  final RxBool hasSearchText = RxBool(false);
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  DateTime dateTime = DateTime.now();
  @override
  void onInit() {
    dateController.text = dateFormat.format(dateTime);
    getMedicinesStock();
    super.onInit();
  }

  Future<void> getMedicinesStock() async {
    String params = "ItemName=${searchController.text}";
    isLoading(true);
    List<MedicineStockListModel>? responseList = await ApiFetch.getMedicineStockList(params);
    isLoading(false);
    if (responseList != null) {
      medicineList.assignAll(responseList);
    }
  }

  Future<void> applyFilter() async {
    medicineList.clear();
    getMedicinesStock();
  }

  Future<Uint8List> generatePdf(PdfPageFormat format, List<MedicineStockListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 30;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<MedicineStockListModel> sublist = data.sublist(start, end.clamp(0, data.length));
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.copyWith(),
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
                        'Medicine Stock',
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
                          "Item Code",
                          "Item Name",
                          "Stock",
                        ])
                          pw.Container(
                            alignment: pw.Alignment.centerLeft,
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
                            sublist[i].itemCode.toString(),
                            sublist[i].itemName.toString(),
                            sublist[i].stock.toStringAsFixed(0),
                          ])
                            pw.Container(
                              alignment: pw.Alignment.centerLeft,
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
  Future<void> exportToExcel(List<MedicineStockListModel> data,  String reportName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      const TextCellValue('Item Code'),
      const TextCellValue('Item Name'),
      const TextCellValue('Stock'),
    ]);
    for (var item in data) {
      var itemName = item.itemCode.toString();
      var itemNames = item.itemName.toString();
      var itemStock = item.stock.toStringAsFixed(0);
      Debug.log(' machine: $itemName  operationName: $itemNames  operator: $itemStock');
      sheet.appendRow([
        TextCellValue(itemName),
        TextCellValue(itemNames),
        TextCellValue(itemStock),
      ]);
    }
    try {
      var bytes = excel.encode();
      var directory = await getApplicationDocumentsDirectory();
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      var fileName = '${reportName.replaceAll(' ', '_')}_$timestamp.xlsx';
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
}
