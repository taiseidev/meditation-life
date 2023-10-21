import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:meditation_life/gen/assets.gen.dart';
import 'package:meditation_life/shared/main_page.dart';
import 'package:meditation_life/shared/strings.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final imagePaths = [
    Assets.icons.meditationIcon.path,
    Assets.icons.appLogo.path,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final path in imagePaths) {
      // アプリ内で使用する画像をキャッシュ
      precacheImage(
        AssetImage(path),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appTitle,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
