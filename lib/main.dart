import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as tz;

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

  timezone.initializeTimeZones();

  await _requestNotificationPermission();

  await _setUp(container);

  await _scheduleDaily8AMNotification();

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

Future<void> _setUp(ProviderContainer container) async {
  final authRepository = container.read(authRepositoryProvider);
  final userRepository = container.read(userRepositoryProvider);
  if (authRepository.authUser == null) {
    await authRepository.signInWithAnonymously();
    await userRepository.createUser();
  }
}

Future<void> _requestNotificationPermission() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  } else if (Platform.isAndroid) {
    final androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestPermission();
  }
}

Future<void> _scheduleDaily8AMNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.zonedSchedule(
    312,
    '瞑想ライフ',
    '本日の瞑想を行いましょう！',
    _fiveSecondsLater(),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        '',
        '',
        channelDescription: '',
      ),
      iOS: DarwinNotificationDetails(badgeNumber: 1),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

// 1回目に通知を飛ばす時間の作成
tz.TZDateTime _nextInstanceOf8AM() {
  final now = tz.TZDateTime.now(tz.local);
  print(now);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 13, 54);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

// デバッグ用（3秒後に通知）
tz.TZDateTime _fiveSecondsLater() {
  var later = tz.TZDateTime.now(tz.local);
  later = later.add(const Duration(seconds: 5));
  return later;
}
