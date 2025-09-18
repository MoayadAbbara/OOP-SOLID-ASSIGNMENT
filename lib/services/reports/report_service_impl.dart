import 'package:ahwa/models/drink.dart';
import 'package:ahwa/models/order.dart';
import 'package:ahwa/services/reports/report_service.dart';

class ReportServiceImpl implements ReportService {
  @override
  Map<Drink, int> generateReport(List<Order> orders) {
    Map<Drink, int> drinkCount = {};

    for (var order in orders) {
      for (var drink in order.items) {
        drinkCount[drink] = (drinkCount[drink] ?? 0) + 1;
      }
    }

    var sortedEntries = drinkCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }
}
