import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/domain/repository/meditation_repository.dart';
import 'package:meditation_life/main.dart';

final meditationUsecaseProvider = Provider<MeditationUsecase>(
  (ref) => MeditationUsecase(ref.read(meditationRepositoryProvider)),
);

class MeditationUsecase {
  MeditationUsecase(this._meditationRepository);
  final MeditationRepository _meditationRepository;

  Future<void> addMeditation(String meditationId) async {
    await _meditationRepository.addMeditation(meditationId);
  }

  Stream<List<Meditation>> fetchMeditationsStream() =>
      _meditationRepository.fetchMeditationsStream();
}
