import 'package:get/get.dart';
import '../screens/complaint_portal/compliant_portal_home.dart';
import '../screens/complaint_portal/new_complaint/bar_code_scan_screen.dart';
import '../screens/complaint_portal/new_complaint/new_complaint_screen.dart';
import '../screens/complaint_portal/recieve_complaint/received_complaint_detail_form.dart';
import '../screens/complaint_portal/recieve_complaint/received_complaint_screen.dart';
import '../screens/fabric_inspection/fabric_inspection_fault_form_screen.dart';
import '../screens/fabric_inspection/fabric_inspection_faults_screen.dart';
import '../screens/fabric_inspection/fabric_inspection_home_screen.dart';
import '../screens/fabric_inspection/fabric_inspection_list.dart';
import '../screens/goods_inspections_note/good_inspection_form_screen.dart';
import '../screens/goods_inspections_note/good_inspections_home_screen.dart';
import '../screens/goods_inspections_note/goods_inspection_dashboard.dart';
import '../screens/goods_inspections_note/goods_inspection_detail_screen.dart';
import '../screens/goods_inspections_note/goods_inspection_notification_screen.dart';
import '../screens/goods_inspections_note/goods_inspection_receive_form.dart';
import '../screens/home/home_page.dart';
import '../screens/introduction/introduction.dart';
import '../screens/keys_issuance/check_key_history.dart';
import '../screens/keys_issuance/keys_add_by_master.dart';
import '../screens/keys_issuance/keys_dashboard_screen.dart';
import '../screens/keys_issuance/keys_issuance_home.dart';
import '../screens/keys_issuance/keys_issuance_return_form.dart';
import '../screens/keys_issuance/keys_management_screen.dart';
import '../screens/keys_issuance/view_key_reports.dart';
import '../screens/login_auth/login/login_screen.dart';
import '../screens/login_auth/login_finger_print/login_with_finger_screen.dart';
import '../screens/medical_issuance/medical_issuance_home.dart';
import '../screens/medical_issuance/first_box_issuance.dart';
import '../screens/medical_issuance/medicine_dashboard_screen.dart';
import '../screens/medical_issuance/medicine_patient_list.dart';
import '../screens/medical_issuance/view_medicine_stock.dart';
import '../screens/rowing_inspection/rowing_end_line_reports/end_line_inspector_hourly_report.dart';
import '../screens/rowing_inspection/rowing_end_line_reports/rowing_qaulity_ednline_top_five_defect_without_operation.dart';
import '../screens/rowing_inspection/rowing_end_line_reports/rowing_quality_end_line_detail_report.dart';
import '../screens/rowing_inspection/rowing_end_line_reports/rowing_quality_end_line_reports_dashboard.dart';
import '../screens/rowing_inspection/rowing_end_line_reports/rowing_quality_end_line_stitching_qa_report.dart';
import '../screens/rowing_inspection/rowing_end_line_reports/rowing_quality_inspector_summary_reports.dart';
import '../screens/rowing_inspection/rowing_end_line_reports/rowing_quality_top_operation_report.dart';
import '../screens/rowing_inspection/rowing_quality_add_seven_garment_fault.dart';
import '../screens/rowing_inspection/rowing_quality_change_machine_flag_color_form_screen.dart';
import '../screens/rowing_inspection/rowing_end_line_reports/rowing_quality_end_line_bundle_inspection_reports.dart';
import '../screens/rowing_inspection/rowing_quality_check_operation_rfid.dart';
import '../screens/rowing_inspection/rowing_quality_end_line_inspection_form.dart';
import '../screens/rowing_inspection/rowing_quality_check_persong_stitch_piece.dart';
import '../screens/rowing_inspection/rowing_quality_endline_add_garment.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_inspection_form.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/in_inspector_line_monthly_flag_report_detail.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/in_line_operator_monthly_flag_report.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/check_operator_quantity_detail_report.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/check_operator_quantity_report.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/check_work_order_rate_list.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/check_work_order_stitching_summary_detail_report.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/check_work_order_stitching_summary_report.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_daily_flag_report.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_in_line_dashboard_screen.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_in_line_inspector_activity_detail.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_in_line_status_reports_screen.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_live_status_flagged_screen.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_user_flag_mark_screen.dart';
import '../screens/rowing_inspection/rowing_quality_check_all_machine_flags.dart';
import '../screens/rowing_inspection/rowing_quality_dashboard.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_scan_nfc.dart';
import '../screens/rowing_inspection/rowing_quality_scan_rfid_for_end_line.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/verify_documents/document_approval_screen.dart';
import '../screens/verify_documents/full_screen_pdf_view.dart';
import '../screens/verify_documents/stock_adjustment_screen.dart';
import '../screens/verify_documents/verify_documents_DashBoard.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const Splash(),
    ),
    GetPage(
      name: AppRoutes.introduction,
      page: () => const IntroScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const Login(),
    ),
    GetPage(
      name: AppRoutes.loginWithFingerPrint,
      page: () => const LoginWithFingerPrint(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoutes.fabricInspectionList,
      page: () => const FabricInspectionListScreen(),
    ),
    GetPage(
      name: AppRoutes.fabricInspectionHome,
      page: () => const FabricInspectionHome(),
    ),
    GetPage(
      name: AppRoutes.fabricInspectionFaults,
      page: () => const FabricFaultsScreen(),
    ),
    GetPage(
      name: AppRoutes.fabricFaultFormScreen,
      page: () => const FabricFaultFormScreen(),
    ),
    GetPage(
      name: AppRoutes.complaintPortalHome,
      page: () => const ComplaintPortalHome(),
    ),
    GetPage(
      name: AppRoutes.createNewComplaint,
      page: () => const NewComplaintScreen(),
    ),
    GetPage(
      name: AppRoutes.receivedComplaints,
      page: () => const ReceivedComplaintScreen(),
    ),
    GetPage(
      name: AppRoutes.receivedComplaintsDetailForm,
      page: () => const ReceivedComplaintDetailForm(),
    ),
    GetPage(
      name: AppRoutes.barCodeScan,
      page: () => BarCodeScanner(),
    ),
    GetPage(
      name: AppRoutes.medicalIssuance,
      page: () => const MedicalIssuanceHome(),
    ),
    GetPage(
      name: AppRoutes.goodsInspectionHome,
      page: () => const GoodsInspectionsHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.goodsInspectionDetail,
      page: () => const GoodsInspectionDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.goodsInspectionNotification,
      page: () => const GoodInspectionNotificationScreen(),
    ),
    GetPage(
      name: AppRoutes.goodsInspectionForm,
      page: () => const GoodsInspectionForm(),
    ),
    GetPage(
      name: AppRoutes.goodsInspectionDashboard,
      page: () => const InspectionDashBoard(),
    ),
    GetPage(
      name: AppRoutes.goodsInspectionReceiveIGP,
      page: () => const ReceiveIGPScreen(),
    ),
    GetPage(
      name: AppRoutes.keysDashBoardScreen,
      page: () => const KeysDashBoard(),
    ),
    GetPage(
      name: AppRoutes.keysIssuanceHome,
      page: () => const KeysIssuanceHome(),
    ),
    GetPage(
      name: AppRoutes.keysIssuanceReturnForm,
      page: () => const KeysIssuanceReturnForm(),
    ),
    GetPage(
      name: AppRoutes.keysManagementScreen,
      page: () => const KeysManagementScreen(),
    ),
    GetPage(
      name: AppRoutes.addKeyByMasterScreen,
      page: () => const KeyAddByMaster(),
    ),
    GetPage(
      name: AppRoutes.checkMedicineIssueScreen,
      page: () => const PatientMedicineListScreen(),
    ),
    GetPage(
      name: AppRoutes.medicineDashboardScreen,
      page: () => const MedicineDashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.checkKeyHistory,
      page: () => const CheckKeyHistory(),
    ),
    GetPage(
      name: AppRoutes.checkMedicineStock,
      page: () => const MedicineStockScreen(),
    ),
    GetPage(
      name: AppRoutes.viewKeyReports,
      page: () => const ViewKeyReports(),
    ),
    GetPage(
      name: AppRoutes.firstAidBoxIssuance,
      page: () => const FirstAidBoxIssuance(),
    ),
    GetPage(
      name: AppRoutes.rowingInspectionDashboard,
      page: () => const RowingInspectionDashboard(),
    ),
    GetPage(
      name: AppRoutes.inLineInspection,
      page: () => const InLineInspection(),
    ),
    GetPage(
      name: AppRoutes.endLineInspection,
      page: () => const EndLineInspection(),
    ),
    GetPage(
      name: AppRoutes.otherApplication,
      page: () => const OtherApplication(),
    ),
    GetPage(
      name: AppRoutes.addInLineInspectionFault,
      page: () => const InLineInspectionFaultScreen(),
    ),
    GetPage(
      name: AppRoutes.inLineFlagScreen,
      page: () => const InLineFlagScreen(),
    ),
    GetPage(
      name: AppRoutes.changeMachineFlagScreen,
      page: () => const RowingQualityMachineFlagColor(),
    ),
    GetPage(
      name: AppRoutes.inLineStatusReportsScreen,
      page: () => const InLineStatusReportsScreen(),
    ),
    GetPage(
      name: AppRoutes.inLineCurrentMachineFlagScreen,
      page: () => const InLineLiveFlaggedScreen(),
    ),
    GetPage(
      name: AppRoutes.liveFlagMarkPerRoundScreen,
      page: () => const LiveFlagMarkForEachRoundTime(),
    ),
    GetPage(
      name: AppRoutes.endLineCheckGarmentScreen,
      page: () => const AddEndLineSevenGarmentFault(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityScanNFC,
      page: () => const RowingQualityScanNFC(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityInLineInspectorDetail,
      page: () => const InLineInspectorActivityDetail(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityEndLineBundleInspectionReports,
      page: () => const EndLineBundleInspectionReports(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityInLineReportsDashBoard,
      page: () => const RowingInspectionReportsDashboard(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityEndLineReportsDashBoard,
      page: () => const RowingQualityEndLineReportsDashboard(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityFlagReports,
      page: () => const InLineFlagReport(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityEndLineDetailReports,
      page: () => const EndLineDetailReport(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityEndLineQAStitchingReports,
      page: () => const EndLineStitchingQAReport(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityScanRFID,
      page: () => const RowingQualityScanEndLineRFID(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityEndLineInspectorHourlyReport,
      page: () => const EndLineInspectorHourlyReport(),
    ),
    GetPage(
      name: AppRoutes.inLineInspectorMonthlyFlagReport,
      page: () => const InLineOperatorMonthlyFlagReport(),
    ),
    GetPage(
      name: AppRoutes.inLineInspectorMonthlyFlagDetailReport,
      page: () => const InLineOperatorMonthlyFlagDetailReport(),
    ),
    GetPage(
      name: AppRoutes.checkWorkOrderStitchingSummaryReport,
      page: () => const CheckWorkOrderStitchingSummaryReport(),
    ),
    GetPage(
      name: AppRoutes.checkWorkOrderStitchingSummaryDetailReport,
      page: () => const CheckWorkOrderStitchingSummaryDetailReport(),
    ),
    GetPage(
      name: AppRoutes.checkWorkOrderRateList,
      page: () => const CheckWorkOrderRateList(),
    ),
    GetPage(
      name: AppRoutes.checkOperatorQuantityReport,
      page: () => const CheckOperatorQuantityReport(),
    ),
    GetPage(
      name: AppRoutes.checkOperatorProductionReport,
      page: () => const CheckOperatorProductionReport(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityEndLineSummary,
      page: () => const EndLineInspectorSummaryReport(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityEndLineTopOperationOfTheDay,
      page: () => const RowingQualityTopOperationInDayReport(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityEdnLineTopFiveDefectWithoutOperation,
      page: () => const EndLineTopFiveDefectWithoutOperation(),
    ),
    GetPage(
      name: AppRoutes.rowingQualityCheckCardOperation,
      page: () => const CheckWorkerOperationAgainstCard(),
    ),
    GetPage(
      name: AppRoutes.verifyDocumentDashBoard,
      page: () => const VerifyDocumentHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.stockAdjustmentScreen,
      page: () => const StockAdjustmentHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.documentApprovalScreen,
      page: () => const DocumentApprovalScreen(),
    ), GetPage(
      name: AppRoutes.fullScreenPdfView,
      page: () =>  const FullScreenPdfView(),
    ),
  ];
}
