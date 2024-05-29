import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_widgets/confirmation_alert.dart';
import '../../../routes/app_routes.dart';
import '../../../services/preferences.dart';
import '../../complaint_portal/complain_widget/complain_portal_dashboard_card.dart';
import '../controllers/rowing_quality_dashboard_controller.dart';


class RowingQualityEndLineReportsDashboard extends StatelessWidget {
  const RowingQualityEndLineReportsDashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final RowingQualityDashBoardController controller = Get.find<RowingQualityDashBoardController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rowing InLine Reports"),
        actions: [
          IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () => ConfirmationAlert.showDialog(
              title: "Logout Confirmation",
              description: "Are you sure you want to log out of this app?",
              onConfirm: () {
                Get.find<Preferences>().logout();
              },
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: "Current ",
                  style: Get.textTheme.titleSmall,
                  children: [
                    TextSpan(
                      text: "User ",
                      style: Get.textTheme.titleSmall,
                    ),
                    TextSpan(
                      text: controller.employeeName,
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.rowingQualityEndLineBundleInspectionReports);
                      },
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.start_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF6C63FF),
                        titleText: '',
                        subTitleText: "EndLine Inspection Report",
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.rowingQualityEndLineDetailReports);
                      },
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.start_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF6C63FF),
                        titleText: '',
                        subTitleText: "EndLine Detail Report",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.rowingQualityEndLineQAStitchingReports);
                      },
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.start_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF6C63FF),
                        titleText: '',
                        subTitleText: "EndLine Daily Summary Report",
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.rowingQualityEndLineInspectorHourlyReport);
                      },
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.start_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF6C63FF),
                        titleText: '',
                        subTitleText: "EndLine Inspector Hourly Report",
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.rowingQualityEndLineSummary);
                      },
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.start_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF6C63FF),
                        titleText: '',
                        subTitleText: "EndLine Date Wise Summary Reports",
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0,),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.rowingQualityEndLineTopOperationOfTheDay);
                      },
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.start_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF6C63FF),
                        titleText: '',
                        subTitleText: "EndLine Top Defective Operation",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.rowingQualityEdnLineTopFiveDefectWithoutOperation);
                      },
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.start_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF6C63FF),
                        titleText: '',
                        subTitleText: "EndLine Top 5 Defect Without Operation",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
