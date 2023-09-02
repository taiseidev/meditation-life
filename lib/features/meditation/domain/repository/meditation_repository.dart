import 'package:meditation_life/features/meditation/domain/meditation.dart';

abstract class MeditationRepository {
  Stream<List<Meditation>> fetchMeditationsStream();
}
