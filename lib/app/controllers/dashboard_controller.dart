import 'package:get/get.dart';

class DashboardController extends GetxController {
  var kpiData = <String, dynamic>{}.obs;
  var recentActivity = [].obs;

  @override
  void onInit() {
    fetchKpiData();
    fetchRecentActivity();
    super.onInit();
  }

  void fetchKpiData() {
    // TODO: Replace with AWS API call
    kpiData.value = {
      'leadsToday': 12,
      'conversionRate': '18%',
      'tasksDue': 5,
    };
  }

  void fetchRecentActivity() {
    // TODO: Replace with AWS API call
    recentActivity.value = [
      'Lead #1092 updated by John',
      'Call completed with Client A',
    ];
  }
}
