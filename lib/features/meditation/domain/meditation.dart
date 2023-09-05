import 'package:freezed_annotation/freezed_annotation.dart';

part 'meditation.freezed.dart';
part 'meditation.g.dart';

@freezed
class Meditation with _$Meditation {
  factory Meditation({
    required String id,
    required String title,
    required int duration,
    required String thumbnailUrl,
    required String audioUrl,
    DateTime? date,
  }) = _Meditation;

  factory Meditation.fromJson(Map<String, dynamic> json) =>
      _$MeditationFromJson(json);
}
