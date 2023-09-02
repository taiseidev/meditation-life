import 'package:meditation_life/features/meditation_history/domain/entity/meditation_history.dart';

abstract class MeditationHistoryRepository {
  Future<void> addMeditationHistory(String meditationId, DateTime date);
  Future<List<MeditationHistory>> fetchMeditationHistories(DateTime date);
}
