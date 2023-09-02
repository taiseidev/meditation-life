import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation_history/domain/entity/meditation_history.dart';
import 'package:meditation_life/features/meditation_history/domain/repository/meditation_history_repository.dart';
import 'package:meditation_life/main.dart';

final meditationHistoryUsecaseProvider = Provider<MeditationHistoryUsecase>(
  (ref) =>
      MeditationHistoryUsecase(ref.read(meditationHistoryRepositoryProvider)),
);

class MeditationHistoryUsecase {
  MeditationHistoryUsecase(this._repository);
  final MeditationHistoryRepository _repository;

  Future<void> addMeditationHistory(String meditationId, DateTime date) async {
    await _repository.addMeditationHistory(meditationId, date);
  }

  Future<List<MeditationHistory>> fetchMeditationHistories(
      DateTime date) async {
    return await _repository.fetchMeditationHistories(date);
  }
}
