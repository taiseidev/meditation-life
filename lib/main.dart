import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/app.dart';
import 'package:meditation_life/features/auth/infrastructure/auth_repository.dart';
import 'package:meditation_life/features/auth/infrastructure/user_repository.dart';
import 'package:meditation_life/features/meditation/domain/repository/meditation_repository.dart';
import 'package:meditation_life/features/meditation/infrastructure/repository/firebase_meditation_repository.dart';
import 'package:meditation_life/firebase_options.dart';
import 'package:meditation_life/shared/package_info_util.dart';
import 'package:package_info_plus/package_info_plus.dart';

final meditationRepositoryProvider = Provider<MeditationRepository>(
  (ref) => throw UnimplementedError(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final packageInfo = await PackageInfo.fromPlatform();

  final container = ProviderContainer(
    overrides: [
      meditationRepositoryProvider.overrideWith(
          (ref) => FirebaseMeditationRepository(FirebaseFirestore.instance)),
      packageInfoProvider.overrideWithValue(packageInfo),
    ],
  );

  await setUp(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: DevicePreview(
        enabled: !kReleaseMode,
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
