import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';

class MeditationDto {
  final String id;
  final String title;
  final int duration;
  final String thumbnailUrl;
  final String audioUrl;

  MeditationDto({
    required this.id,
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
    required this.audioUrl,
  });

  factory MeditationDto.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MeditationDto(
      id: doc.id,
      title: data['title'] as String,
      duration: data['duration'] as int,
      thumbnailUrl: data['thumbnailUrl'] as String,
      audioUrl: data['audioUrl'] as String,
    );
  }

  Meditation toDomain() {
    return Meditation(
      id: id,
      title: title,
      duration: duration,
      thumbnailUrl: thumbnailUrl,
      audioUrl: audioUrl,
    );
  }
}
