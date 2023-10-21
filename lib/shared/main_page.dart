import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation/presentation/pages/meditation_page.dart';
import 'package:meditation_life/features/meditation_history/presentation/meditation_history_page.dart';
import 'package:meditation_life/features/setting/presentation/setting_page.dart';
import 'package:meditation_life/gen/assets.gen.dart';
import 'package:meditation_life/shared/res/color.dart';
import 'package:meditation_life/utils/vibration_utils.dart';

final selectedIndexProvider = StateProvider.autoDispose<int>((_) => 0);

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  static const meditationPageIndex = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = <Widget>[
      MeditationHistoryPage(),
      const SettingPage(),
      const MeditationPage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            child: Image.asset(
              Assets.icons.appLogo.path,
            ),
          ),
          pages[ref.watch(selectedIndexProvider)],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(vibrationUtilProvider).hapticFeedback();
          ref
              .read(selectedIndexProvider.notifier)
              .update((state) => state = meditationPageIndex);
        },
        backgroundColor: AppColor.secondary.withOpacity(0.6),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.play_arrow_outlined,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.black,
        activeColor: Colors.white,
        inactiveColor: Colors.white.withOpacity(0.6),
        icons: const [Icons.home_outlined, Icons.settings_outlined],
        activeIndex: ref.watch(selectedIndexProvider),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          ref.read(vibrationUtilProvider).hapticFeedback();
          ref
              .read(selectedIndexProvider.notifier)
              .update((state) => state = index);
        },
        //other params
      ),
    );
  }
}
