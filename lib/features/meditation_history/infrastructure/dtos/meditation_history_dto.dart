import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditation_life/features/meditation_history/domain/entity/meditation_history.dart';

class MeditationHistoryDto {
  final String meditationId;
  final Timestamp date;

  MeditationHistoryDto({
    required this.meditationId,
    required this.date,
  });

  factory MeditationHistoryDto.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MeditationHistoryDto(
      meditationId: data['meditationId'] as String,
      date: data['date'] as Timestamp,
    );
  }

  MeditationHistory toDomain() {
    return MeditationHistory(
      meditationId: meditationId,
      date: date.toDate(),
    );
  }
}
