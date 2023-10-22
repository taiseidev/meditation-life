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
}
