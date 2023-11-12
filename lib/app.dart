import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/core/gen/assets.gen.dart';
import 'package:meditation_life/core/utils/strings.dart';
import 'package:meditation_life/features/auth/infrastructure/auth_repository.dart';
import 'package:meditation_life/features/auth/infrastructure/user_repository.dart';
import 'package:meditation_life/features/main_page.dart';

class App extends HookConsumerWidget {
  App({super.key});

  final _imagePaths = [
    Assets.icons.meditationIcon.path,
    Assets.icons.appLogo.path,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    for (final path in _imagePaths) {
      precacheImage(
        AssetImage(path),
        context,
      );
    }

    useEffect(
      () {
        Future(() async {
          await _setUpUser(ref);
        });
        return null;
      },
      const [],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appTitle,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white.withOpacity(0.95),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }

  /// アプリ初回起動時にユーザを作成
  Future<void> _setUpUser(WidgetRef ref) async {
    final authRepository = ref.read(authRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);
    if (authRepository.authUser == null) {
      await authRepository.signInWithAnonymously();
      await userRepository.createUser();
    }
  }
}
