import 'package:meditation_life/features/meditation/domain/meditation.dart';

class MeditationList {
  MeditationList(this.list);
  final List<Meditation> list;

  Map<String, List<String>> get events =>
      list.fold<Map<String, List<String>>>({}, (acc, item) {
        final dateKey =
            '${item.date!.year}/${item.date!.month}/${item.date!.day}';
        acc[dateKey] = (acc[dateKey] ?? [])..add(item.id);
        return acc;
      });

  String? get thisMonth => events.keys.firstOrNull;

  // 月のみを取得
  int month(DateTime now) {
    return now.month;
  }

  // その月にどれくらいの日数が含まれているか
  int daysInMonth(DateTime now) {
    final lastDate = DateTime(now.year, now.month + 1, 0);
    return lastDate.day;
  }

  // 選択した日付の List<MeditationHistory>
  List<Meditation> getMeditationHistoryForDate(DateTime targetDate) {
    return list.where((meditation) {
      return meditation.date?.year == targetDate.year &&
          meditation.date?.month == targetDate.month &&
          meditation.date?.day == targetDate.day;
    }).toList();
  }
}
