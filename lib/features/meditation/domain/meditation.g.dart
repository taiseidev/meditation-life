// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeditationImpl _$$MeditationImplFromJson(Map<String, dynamic> json) =>
    _$MeditationImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as int,
      thumbnailUrl: json['thumbnailUrl'] as String,
      audioUrl: json['audioUrl'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$MeditationImplToJson(_$MeditationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'duration': instance.duration,
      'thumbnailUrl': instance.thumbnailUrl,
      'audioUrl': instance.audioUrl,
      'date': instance.date?.toIso8601String(),
    };
