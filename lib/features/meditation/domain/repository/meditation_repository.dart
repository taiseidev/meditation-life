import 'package:meditation_life/features/meditation/domain/meditation.dart';

abstract class MeditationRepository {
  Future<void> addMeditation(String meditationId);
  Stream<List<Meditation>> fetchMeditationsStream();
}
