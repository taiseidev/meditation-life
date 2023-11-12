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
}
