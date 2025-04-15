import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/core/gen/assets.gen.dart';
import 'package:meditation_life/core/res/color.dart';
import 'package:meditation_life/core/utils/strings.dart';
import 'package:meditation_life/features/auth/infrastructure/auth_repository.dart';
import 'package:meditation_life/features/auth/infrastructure/user_repository.dart';
import 'package:meditation_life/shared/pages/main_page.dart';

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
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.primary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          headlineMedium: TextStyle(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          titleLarge: TextStyle(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          titleMedium: TextStyle(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          bodyLarge: TextStyle(
            color: AppColor.textPrimary,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: AppColor.textSecondary,
            fontSize: 14,
          ),
        ),
        cardTheme: CardTheme(
          color: AppColor.cardBackground,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: AppColor.primary.withOpacity(0.1),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.secondary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColor.secondary,
            side: const BorderSide(color: AppColor.secondary, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColor.secondary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.secondary,
          primary: AppColor.primary,
          secondary: AppColor.secondary,
          tertiary: AppColor.accent,
          background: AppColor.background,
          error: AppColor.error,
        ),
        useMaterial3: true,
      ),
      home: MainPage(),
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
