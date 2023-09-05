import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation_history/domain/entity/meditation_history_list.dart';
import 'package:meditation_life/features/meditation_history/domain/usecase/meditation_history_usecase.dart';

final meditationHistoryNotifierProvider =
    AsyncNotifierProvider<MeditationHistoryNotifier, MeditationHistoryList>(
  MeditationHistoryNotifier.new,
);

// メモ
// AsyncNotifier内部的にstateをAsyncValueでラップしている
// copyWithPreviousを利用することで前の状態を維持することができる
class MeditationHistoryNotifier extends AsyncNotifier<MeditationHistoryList> {
  @override
  FutureOr<MeditationHistoryList> build() async => _init();

  Future<MeditationHistoryList> _init() async {
    final now = DateTime.now();
    final meditationHistories = await ref
        .read(meditationHistoryUsecaseProvider)
        .fetchMeditationHistories(now);
    return MeditationHistoryList(meditationHistories);
  }

  Future<MeditationHistoryList> test() async {
    state = const AsyncLoading<MeditationHistoryList>().copyWithPrevious(state);

    return MeditationHistoryList([]);
  }
}
