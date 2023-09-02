import 'package:intl/intl.dart';
import 'package:meditation_life/features/meditation_history/domain/entity/meditation_history.dart';

class MeditationHistoryList {
  MeditationHistoryList(this.list);
  final List<MeditationHistory> list;

  Map<String, List<String>> get events {
    final Map<String, List<String>> result = {};

    for (final item in list) {
      final date = item.date;
      result
          .putIfAbsent("${date.year}/${date.month}/${date.day}", () => [])
          .add(item.meditationId);
    }

    return result;
  }

  String get thisMonth => events.keys.first;

  // 月のみを取得
  int get month {
    final DateTime firstDate = DateFormat('y/M/d').parse(thisMonth);
    return firstDate.month;
  }

  // その月にどれくらいの日数が含まれているか
  int get daysInMonth {
    final firstDate = DateFormat('y/M/d').parse(thisMonth);
    final lastDate = DateTime(firstDate.year, firstDate.month + 1, 0);
    return lastDate.day;
  }

  // 選択した日付の List<MeditationHistory>
  List<MeditationHistory> getMeditationHistoryForDate(DateTime selectedDate) {
    return list.where((item) {
      final itemDate = item.date;
      return itemDate.year == selectedDate.year &&
          itemDate.month == selectedDate.month &&
          itemDate.day == selectedDate.day;
    }).toList();
  }
}
