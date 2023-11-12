import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meditation_life/app.dart';
import 'package:meditation_life/config/firebase_options.dart';
import 'package:meditation_life/core/local_notification/local_notification.dart';
import 'package:meditation_life/core/shared_preference/shared_preference_instance.dart';
import 'package:meditation_life/core/utils/local_time_zone_util.dart';
import 'package:meditation_life/core/utils/package_info_util.dart';
import 'package:meditation_life/core/utils/riverpod_logger.dart';
import 'package:meditation_life/features/meditation/infrastructure/repository/firebase_meditation_repository.dart';
import 'package:meditation_life/features/meditation/infrastructure/repository/meditation_repository_provider.dart';
import 'package:meditation_life/features/meditation_history/domain/repository/meditation_history_repository.dart';
import 'package:meditation_life/features/meditation_history/infrastructure/repository/firebase_meditation_history_repository.dart';
import 'package:timezone/data/latest.dart' as timezone;

final meditationHistoryRepositoryProvider =
    Provider<MeditationHistoryRepository>(
  (_) => throw UnimplementedError(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // timezoneパッケージの初期化処理
  timezone.initializeTimeZones();

  await Future.wait([
    // Firebaseの初期化処理
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    // intlパッケージのDateFormatを初期化
    initializeDateFormatting(),
    // AdMobの初期化
    MobileAds.instance.initialize(),
    // PackageInfoの初期化処理
    PackageInfoInstance.init(),
    // timezoneの初期化処理
    LocalTimeZoneUtil.init(),
    // SharedPreferenceの初期化
    SharedPreferencesInstance.init(),
    // お知らせの初期化
    LocalNotification().localNotificationSetting(),
  ]);

  runApp(
    ProviderScope(
      overrides: [
        meditationRepositoryProvider.overrideWith(
          (_) => FirebaseMeditationRepository(FirebaseFirestore.instance),
        ),
        meditationHistoryRepositoryProvider.overrideWith(
          (_) =>
              FirebaseMeditationHistoryRepository(FirebaseFirestore.instance),
        ),
      ],
      observers: [RiverpodLogger()],
      child: DevicePreview(
        enabled: false,
        builder: (context) => App(),
      ),
    ),
  );
}
