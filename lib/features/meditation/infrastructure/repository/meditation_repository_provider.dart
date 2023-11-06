import 'package:meditation_life/features/meditation/domain/repository/meditation_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meditation_repository_provider.g.dart';

@Riverpod(keepAlive: true)
MeditationRepository meditationRepository(
  MeditationRepositoryRef ref,
) =>
    throw UnimplementedError();
