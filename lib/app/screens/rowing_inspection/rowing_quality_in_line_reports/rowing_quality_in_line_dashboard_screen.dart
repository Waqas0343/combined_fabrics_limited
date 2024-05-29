import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_widgets/confirmation_alert.dart';
import '../../../routes/app_routes.dart';
import '../../../services/preferences.dart';
import '../../complaint_portal/complain_widget/complain_portal_dashboard_card.dart';
import '../controllers/rowing_quality_dashboard_controller.dart';

class RowingInspectionReportsDashboard extends StatelessWidget {
  const RowingInspectionReportsDashboard({Key? key}) : super(key: key);
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
                      onTap: () =>  Get.toNamed(AppRoutes.inLineStatusReportsScreen),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.flag_circle_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF50C9C3),
                        titleText: '',
                        subTitleText: "Daily 7.0 Rounds & Flag Report",
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>   Get.toNamed(AppRoutes.rowingQualityInLineInspectorDetail),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF50C9C3),
                        titleText: '',
                        subTitleText: "Daily 7.0 Inspector Activity Report",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>  Get.toNamed(AppRoutes.rowingQualityFlagReports),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.flag_circle_rounded,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF50C9C3),
                        titleText: '',
                        subTitleText: "Daily 7.0 Flag Report Detail",
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.inLineInspectorMonthlyFlagReport),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.flag_circle_rounded,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF50C9C3),
                        titleText: '',
                        subTitleText: "7.0 InLine Inspector Monthly Flag Report",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.inLineInspectorMonthlyFlagDetailReport),
                      child: const ComplaintPortalCard(
                        icon: Icon(
                          Icons.flag_circle_rounded,
                          color: Colors.deepOrangeAccent,
                        ),
                        color: Color(0xFF50C9C3),
                        titleText: '',
                        subTitleText: "7.0 InLine Inspector Activity Detail Report",
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
