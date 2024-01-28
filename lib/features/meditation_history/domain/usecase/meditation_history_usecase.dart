import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/domain/repository/meditation_repository.dart';
import 'package:meditation_life/features/meditation/infrastructure/repository/meditation_repository_provider.dart';
import 'package:meditation_life/features/meditation_history/domain/repository/meditation_history_repository.dart';
import 'package:meditation_life/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meditation_history_usecase.g.dart';

@Riverpod(keepAlive: true)
MeditationHistoryUsecase meditationHistoryUsecase(
  MeditationHistoryUsecaseRef ref,
) =>
    MeditationHistoryUsecase(
      ref.read(meditationHistoryRepositoryProvider),
      ref.read(meditationRepositoryProvider),
    );

class MeditationHistoryUsecase {
  MeditationHistoryUsecase(
    this._repository,
    this._meditationRepository,
  );

  final MeditationHistoryRepository _repository;
  final MeditationRepository _meditationRepository;

  Future<void> addMeditationHistory(String meditationId, DateTime date) async =>
      _repository.add(meditationId, date);

  Future<List<Meditation>> fetchUserMeditationHistory(DateTime date) async {
    final histories = await _repository.fetchAll(date);
    final meditationIds = histories.map((e) => e.meditationId).toList();
    final meditations =
        await _meditationRepository.fetchMeditationsByIds(meditationIds);

    final result = histories.map((e) {
      final sound =
          meditations.firstWhere((element) => element.id == e.meditationId);
      return sound.copyWith(date: e.date);
    }).toList();

    return result;
  }
}
