import 'package:meditation_life/features/meditation_history/domain/entity/meditation_history.dart';

abstract class MeditationHistoryRepository {
  Future<void> add(String meditationId, DateTime date);
  Future<List<MeditationHistory>> fetchAll(DateTime date);
}
