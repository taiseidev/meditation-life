import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MainPage extends HookWidget {
  const MainPage({super.key});

  static const meditationViewIndex = 2;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState<int>(0);

    final views = <Widget>[
      const MeditationHistoryView(),
      const SettingView(),
      const MeditationView(),
    ];

    return Scaffold(
      body: views[selectedIndex.value],
      floatingActionButton: FloatingActionButton(
        onPressed: () => selectedIndex.value = meditationViewIndex,
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.red,
        icons: const [Icons.add, Icons.add],
        activeIndex: selectedIndex.value,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => selectedIndex.value = index,
        //other params
      ),
    );
  }
}

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("設定画面"),
    );
  }
}

class MeditationView extends StatelessWidget {
  const MeditationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("瞑想画面"),
    );
  }
}

class MeditationHistoryView extends StatelessWidget {
  const MeditationHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("瞑想履歴画面"),
    );
  }
}
