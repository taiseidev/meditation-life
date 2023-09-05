// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meditation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Meditation _$MeditationFromJson(Map<String, dynamic> json) {
  return _Meditation.fromJson(json);
}

/// @nodoc
mixin _$Meditation {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  String get thumbnailUrl => throw _privateConstructorUsedError;
  String get audioUrl => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeditationCopyWith<Meditation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeditationCopyWith<$Res> {
  factory $MeditationCopyWith(
          Meditation value, $Res Function(Meditation) then) =
      _$MeditationCopyWithImpl<$Res, Meditation>;
  @useResult
  $Res call(
      {String id,
      String title,
      int duration,
      String thumbnailUrl,
      String audioUrl,
      DateTime? date});
}

/// @nodoc
class _$MeditationCopyWithImpl<$Res, $Val extends Meditation>
    implements $MeditationCopyWith<$Res> {
  _$MeditationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? duration = null,
    Object? thumbnailUrl = null,
    Object? audioUrl = null,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      audioUrl: null == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MeditationCopyWith<$Res>
    implements $MeditationCopyWith<$Res> {
  factory _$$_MeditationCopyWith(
          _$_Meditation value, $Res Function(_$_Meditation) then) =
      __$$_MeditationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      int duration,
      String thumbnailUrl,
      String audioUrl,
      DateTime? date});
}

/// @nodoc
class __$$_MeditationCopyWithImpl<$Res>
    extends _$MeditationCopyWithImpl<$Res, _$_Meditation>
    implements _$$_MeditationCopyWith<$Res> {
  __$$_MeditationCopyWithImpl(
      _$_Meditation _value, $Res Function(_$_Meditation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? duration = null,
    Object? thumbnailUrl = null,
    Object? audioUrl = null,
    Object? date = freezed,
  }) {
    return _then(_$_Meditation(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      audioUrl: null == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Meditation implements _Meditation {
  _$_Meditation(
      {required this.id,
      required this.title,
      required this.duration,
      required this.thumbnailUrl,
      required this.audioUrl,
      this.date});

  factory _$_Meditation.fromJson(Map<String, dynamic> json) =>
      _$$_MeditationFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final int duration;
  @override
  final String thumbnailUrl;
  @override
  final String audioUrl;
  @override
  final DateTime? date;

  @override
  String toString() {
    return 'Meditation(id: $id, title: $title, duration: $duration, thumbnailUrl: $thumbnailUrl, audioUrl: $audioUrl, date: $date)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Meditation &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, duration, thumbnailUrl, audioUrl, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MeditationCopyWith<_$_Meditation> get copyWith =>
      __$$_MeditationCopyWithImpl<_$_Meditation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MeditationToJson(
      this,
    );
  }
}

abstract class _Meditation implements Meditation {
  factory _Meditation(
      {required final String id,
      required final String title,
      required final int duration,
      required final String thumbnailUrl,
      required final String audioUrl,
      final DateTime? date}) = _$_Meditation;

  factory _Meditation.fromJson(Map<String, dynamic> json) =
      _$_Meditation.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  int get duration;
  @override
  String get thumbnailUrl;
  @override
  String get audioUrl;
  @override
  DateTime? get date;
  @override
  @JsonKey(ignore: true)
  _$$_MeditationCopyWith<_$_Meditation> get copyWith =>
      throw _privateConstructorUsedError;
}
