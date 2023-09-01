import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation/presentation/meditation_page.dart';
import 'package:meditation_life/features/meditation_history/presentation/meditation_history_page.dart';
import 'package:meditation_life/features/setting/presentation/setting_page.dart';

final selectedIndexProvider = StateProvider.autoDispose<int>((_) => 0);

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  static const meditationViewIndex = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = <Widget>[
      const MeditationHistoryPage(),
      const SettingPage(),
      const MeditationPage(),
    ];

    return Scaffold(
      body: pages[ref.watch(selectedIndexProvider)],
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref
            .read(selectedIndexProvider.notifier)
            .update((state) => state = meditationViewIndex),
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.red,
        icons: const [Icons.history_rounded, Icons.settings],
        activeIndex: ref.watch(selectedIndexProvider),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => ref
            .read(selectedIndexProvider.notifier)
            .update((state) => state = index),
        //other params
      ),
    );
  }
}
