import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meditation_life/features/meditation/presentation/meditation_page.dart';
import 'package:meditation_life/features/setting/presentation/setting_page.dart';

class MainPage extends HookWidget {
  const MainPage({super.key});

  static const meditationViewIndex = 2;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState<int>(0);

    final pages = <Widget>[
      const MeditationHistoryView(),
      const SettingPage(),
      const MeditationPage(),
    ];

    return Scaffold(
      body: pages[selectedIndex.value],
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

class MeditationHistoryView extends StatelessWidget {
  const MeditationHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("瞑想履歴画面"),
    );
  }
}
