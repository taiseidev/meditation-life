import 'package:intl/intl.dart';
import 'package:meditation_life/features/meditation_history/domain/entity/meditation_history.dart';

class MeditationHistoryList {
  MeditationHistoryList(this.list);
  final List<MeditationHistory> list;

  Map<String, List<String>> get events =>
      list.fold<Map<String, List<String>>>({}, (acc, item) {
        final dateKey = '${item.date.year}/${item.date.month}/${item.date.day}';
        acc[dateKey] = (acc[dateKey] ?? [])..add(item.meditationId);
        return acc;
      });

  String? get thisMonth => events.keys.firstOrNull;

  // 月のみを取得
  int get month {
    if (thisMonth == null) {
      final now = DateTime.now();
      return now.month;
    }
    return DateFormat('y/M/d').parse(thisMonth!).month;
  }

  // その月にどれくらいの日数が含まれているか
  int get daysInMonth {
    if (thisMonth == null) {
      return 30;
    }
    final firstDate = DateFormat('y/M/d').parse(thisMonth!);
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
