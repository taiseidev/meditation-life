import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_life/features/meditation_history/domain/entity/meditation_histori_list.dart';
import 'package:meditation_life/features/meditation_history/domain/usecase/meditation_history_usecase.dart';

final meditationHistoryNotifierProvider =
    AsyncNotifierProvider<MeditationHistoryNotifier, MeditationHistoryList>(
        () => MeditationHistoryNotifier());

class MeditationHistoryNotifier extends AsyncNotifier<MeditationHistoryList> {
  @override
  FutureOr<MeditationHistoryList> build() async {
    final now = DateTime.now();
    final meditationHistories = await ref
        .read(meditationHistoryUsecaseProvider)
        .fetchMeditationHistories(now);
    return MeditationHistoryList(meditationHistories);
  }
}
