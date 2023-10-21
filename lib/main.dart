import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
import 'package:meditation_life/features/notification/notification_service.dart';
import 'package:meditation_life/features/sound/domain/entities/sound.dart';
import 'package:meditation_life/firebase_options.dart';
import 'package:meditation_life/utils/package_info_util.dart';
import 'package:meditation_life/utils/riverpod_logger.dart';
import 'package:meditation_life/utils/shared_preference_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as timezone;

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
  // アプリの初期化処理
  WidgetsFlutterBinding.ensureInitialized();

  await PackageInfoInstance.init();

  // timezoneパッケージの初期化処理
  timezone.initializeTimeZones();

  await Future.wait([
    // Firebaseの初期化処理
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    // intlパッケージのDateFormatを初期化
    initializeDateFormatting(),
    // AdMobの初期化
    MobileAds.instance.initialize(),
  ]);

  // ローカルのtimezone情報を取得
  final currentTimeZone = await FlutterTimezone.getLocalTimezone();

  // 各パッケージのインスタンスを作成
  final (prefs, isar) = await initializeAppResources();

  final container = ProviderContainer(
    overrides: [
      meditationRepositoryProvider.overrideWith(
        (_) => FirebaseMeditationRepository(FirebaseFirestore.instance),
      ),
      meditationHistoryRepositoryProvider.overrideWith(
        (_) => FirebaseMeditationHistoryRepository(FirebaseFirestore.instance),
      ),
      sharedPreferenceProvider.overrideWithValue(prefs),
      localDbProvider.overrideWithValue(isar),
      localTimeZoneProvider.overrideWithValue(currentTimeZone),
    ],
    observers: [
      RiverpodLogger(),
    ],
  );

  await Future.wait([
    // 通知に関する設定
    container.read(notificationServiceProvider).notificationSettings(),
    // Firebaseに関する設定
    _setUpUser(container),
  ]);

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

// ローカルデータの保存先のpathを取得
Future<String> _getApplicationSupportPath() async {
  final dir = await getApplicationSupportDirectory();
  return dir.path;
}

Future<(SharedPreferences, Isar)> initializeAppResources() async {
  final results = await Future.wait([
    PackageInfo.fromPlatform(),
    SharedPreferences.getInstance(),
    Isar.open([SoundSchema], directory: await _getApplicationSupportPath()),
  ]);

  return (
    results[1] as SharedPreferences,
    results[2] as Isar,
  );
}

Future<void> _setUpUser(ProviderContainer container) async {
  final authRepository = container.read(authRepositoryProvider);
  final userRepository = container.read(userRepositoryProvider);
  if (authRepository.authUser == null) {
    await authRepository.signInWithAnonymously();
    await userRepository.createUser();
  }
}
