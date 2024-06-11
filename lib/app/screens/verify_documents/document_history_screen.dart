import 'package:combined_fabrics_limited/app/app_widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../app_assets/styles/my_colors.dart';
import 'verify_controllers/document_history_controller.dart';
import 'package:intl/intl.dart';

class DocumentHistoryTimelinePage extends StatelessWidget {
  const DocumentHistoryTimelinePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DocumentHistoryController controller =
        Get.put(DocumentHistoryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document History'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: controller.documentHistoryList.length,
            itemBuilder: (context, index) {
              final history = controller.documentHistoryList[index];

              // Determine the status and color based on the index
              final status = index == 0 ? 0 : history.status;
              final color = index == 0
                  ? MyColors.greenLight
                  : (history.status == 1
                      ? MyColors.greenLight
                      : Colors.redAccent);

              return TimelineTile(
                alignment: TimelineAlign.start,
                isFirst: index == 0,
                isLast: index == controller.documentHistoryList.length - 1,
                indicatorStyle: IndicatorStyle(
                  width: 40,
                  color: color,
                  padding: const EdgeInsets.all(6),
                  iconStyle: IconStyle(
                    color: Colors.white,
                    iconData: index == 0
                        ? Icons.person
                        : status == 1
                            ? Icons.check
                            : Icons.close,
                  ),
                ),
                endChild: CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        history.comments,
                        style: Get.textTheme.titleSmall,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            'Date: ${DateFormat('EEEE, MMMM d, yyyy').format(history.audtdatetime)}',
                            style: Get.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Time: ${DateFormat('h:mm a').format(history.audtdatetime)}',
                            style: Get.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'User: ${history.username}',
                            style: Get.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 5),
                          if (index != 0)
                            Text(
                              'Status: ${status == 1 ? 'Approved' : 'Rejected'}',
                              style: Get.textTheme.titleSmall,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                beforeLineStyle: LineStyle(
                  color: color,
                  thickness: 4,
                ),
              );
            },
          );
        }
      }),
    );
  }
}
