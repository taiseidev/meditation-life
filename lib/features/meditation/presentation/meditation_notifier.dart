import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/domain/usecase/meditation_usecase.dart';

final meditationNotifierProvider = StreamProvider<List<Meditation>>(
  (ref) => ref.read(meditationUsecaseProvider).fetchMeditationsStream(),
);
