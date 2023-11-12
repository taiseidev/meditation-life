import 'dart:async';

import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/domain/meditation_list.dart';
import 'package:meditation_life/features/meditation_history/domain/usecase/meditation_history_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meditation_history_notifier.g.dart';

@riverpod
class MeditationHistoryNotifier extends _$MeditationHistoryNotifier {
  @override
  Future<MeditationList> build() async {
    final now = DateTime.now();
    final meditationList = await ref
        .read(meditationHistoryUsecaseProvider)
        .fetchUserMeditationHistory(now);
    return MeditationList(meditationList);
  }

  Future<void> fetchMeditationListPerMonth(DateTime now) async {
    state = const AsyncLoading<MeditationList>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final meditationList = await ref
          .read(meditationHistoryUsecaseProvider)
          .fetchUserMeditationHistory(now);
      return MeditationList(meditationList);
    });
  }
}

@riverpod
List<Meditation> meditationHistoriesOnDate(
  MeditationHistoriesOnDateRef ref,
  DateTime date,
) {
  final histories = ref.watch(meditationHistoryNotifierProvider);

  if (histories.valueOrNull == null) {
    return [];
  }

  return histories.valueOrNull!.list.where((meditation) {
    return meditation.date?.year == date.year &&
        meditation.date?.month == date.month &&
        meditation.date?.day == date.day;
  }).toList();
}
