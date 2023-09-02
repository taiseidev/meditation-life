import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar/isar.dart';
import 'package:meditation_life/app.dart';
import 'package:meditation_life/features/auth/infrastructure/auth_repository.dart';
import 'package:meditation_life/features/auth/infrastructure/user_repository.dart';
import 'package:meditation_life/features/meditation/domain/repository/meditation_repository.dart';
import 'package:meditation_life/features/meditation/infrastructure/repository/firebase_meditation_repository.dart';
import 'package:meditation_life/features/meditation_history/domain/repository/meditation_history_repository.dart';
import 'package:meditation_life/features/meditation_history/infrastructure/repository/firebase_meditation_history_repository.dart';
import 'package:meditation_life/features/sound/domain/entities/sound.dart';
import 'package:meditation_life/firebase_options.dart';
import 'package:meditation_life/utils/package_info_util.dart';
import 'package:meditation_life/utils/shared_preference_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final meditationRepositoryProvider = Provider<MeditationRepository>(
  (_) => throw UnimplementedError(),
);
final meditationHistoryRepositoryProvider =
    Provider<MeditationHistoryRepository>(
  (_) => throw UnimplementedError(),
);
final localDbProvider = Provider<Isar>(
  (_) => throw UnimplementedError(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting();

  final packageInfo = await PackageInfo.fromPlatform();

  final prefs = await SharedPreferences.getInstance();

  var path = '';
  if (!kIsWeb) {
    final dir = await getApplicationSupportDirectory();
    path = dir.path;
  }

  final isar = await Isar.open(
    [SoundSchema],
    directory: path,
  );

  final container = ProviderContainer(
    overrides: [
      meditationRepositoryProvider.overrideWith(
          (_) => FirebaseMeditationRepository(FirebaseFirestore.instance)),
      meditationHistoryRepositoryProvider.overrideWith((_) =>
          FirebaseMeditationHistoryRepository(FirebaseFirestore.instance)),
      packageInfoProvider.overrideWithValue(packageInfo),
      localDbProvider.overrideWithValue(isar),
      sharedPreferenceProvider.overrideWithValue(prefs)
    ],
  );

  await setUp(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: DevicePreview(
        enabled: false,
        builder: (context) => const App(),
      ),
    ),
  );
}

Future<void> setUp(ProviderContainer container) async {
  final authRepository = container.read(authRepositoryProvider);
  final userRepository = container.read(userRepositoryProvider);
  if (authRepository.authUser == null) {
    await authRepository.signInWithAnonymously();
    await userRepository.createUser();
  }
}
