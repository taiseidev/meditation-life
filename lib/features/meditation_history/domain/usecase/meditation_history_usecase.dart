import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/domain/repository/meditation_repository.dart';
import 'package:meditation_life/features/meditation_history/domain/repository/meditation_history_repository.dart';
import 'package:meditation_life/main.dart';

final meditationHistoryUsecaseProvider = Provider<MeditationHistoryUsecase>(
  (ref) => MeditationHistoryUsecase(
    ref.read(meditationHistoryRepositoryProvider),
    ref.read(meditationRepositoryProvider),
  ),
);

class MeditationHistoryUsecase {
  MeditationHistoryUsecase(
    this._repository,
    this._meditationRepository,
  );
  final MeditationHistoryRepository _repository;
  final MeditationRepository _meditationRepository;

  Future<void> addMeditationHistory(String meditationId, DateTime date) async {
    await _repository.addMeditationHistory(meditationId, date);
  }

  Future<List<Meditation>> fetchUserMeditationHistory(DateTime date) async {
    final histories = await _repository.fetchMeditationHistories(date);
    final meditationIds = histories.map((e) => e.meditationId).toList();
    final meditations =
        await _meditationRepository.fetchMeditationsByIds(meditationIds);

    return meditations.map((meditation) {
      final matchingHistory = histories
          .firstWhere((history) => history.meditationId == meditation.id);
      return meditation.copyWith(date: matchingHistory.date);
    }).toList();
  }
}
