import 'package:cloud_firestore/cloud_firestore.dart';
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

// このプロバイダーは本来、専用のプロバイダーファイルに移動すべきです
final meditationHistoryRepositoryProvider =
    Provider<MeditationHistoryRepository>(
  (_) => throw UnimplementedError(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 基本的な初期化処理
  timezone.initializeTimeZones();

  // 並列で実行可能な初期化処理をまとめて実行
  await _initializeAppDependencies();

  // アプリケーションの起動
  runApp(
    ProviderScope(
      overrides: _createProviderOverrides(),
      observers: [RiverpodLogger()],
      child: App(),
    ),
  );
}

/// アプリケーションの依存関係を初期化する
Future<void> _initializeAppDependencies() async {
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    initializeDateFormatting(),
    MobileAds.instance.initialize(),
    PackageInfoInstance.init(),
    LocalTimeZoneUtil.init(),
    SharedPreferencesInstance.init(),
    LocalNotification().localNotificationSetting(),
  ]);
}

/// Riverpodプロバイダーのオーバーライドを作成する
List<Override> _createProviderOverrides() {
  final firestore = FirebaseFirestore.instance;

  return [
    meditationRepositoryProvider.overrideWith(
      (_) => FirebaseMeditationRepository(firestore),
    ),
    meditationHistoryRepositoryProvider.overrideWith(
      (_) => FirebaseMeditationHistoryRepository(firestore),
    ),
  ];
}
