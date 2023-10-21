import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation/domain/meditation_list.dart';
import 'package:meditation_life/features/meditation_history/domain/usecase/meditation_history_usecase.dart';

final meditationHistoryNotifierProvider =
    AsyncNotifierProvider<MeditationHistoryNotifier, MeditationList>(
  MeditationHistoryNotifier.new,
);

class MeditationHistoryNotifier extends AsyncNotifier<MeditationList> {
  @override
  FutureOr<MeditationList> build() async {
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
