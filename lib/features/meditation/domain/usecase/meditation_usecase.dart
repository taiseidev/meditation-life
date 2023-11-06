import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/domain/repository/meditation_repository.dart';
import 'package:meditation_life/features/meditation/infrastructure/repository/meditation_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meditation_usecase.g.dart';

@riverpod
MeditationUsecase meditationUsecase(MeditationUsecaseRef ref) =>
    MeditationUsecase(ref.read(meditationRepositoryProvider));

class MeditationUsecase {
  MeditationUsecase(this._meditationRepository);
  final MeditationRepository _meditationRepository;

  Stream<List<Meditation>> fetchMeditationsStream() =>
      _meditationRepository.fetchMeditationsStream();
}
