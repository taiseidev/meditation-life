import 'package:meditation_life/features/meditation/domain/meditation.dart';

abstract class MeditationRepository {
  Stream<List<Meditation>> fetchMeditationsStream();
  Future<List<Meditation>> fetchMeditationsByIds(List<String> ids);
}
