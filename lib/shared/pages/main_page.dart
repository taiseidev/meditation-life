import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/core/extension/void_callback_ext.dart';
import 'package:meditation_life/core/res/color.dart';
import 'package:meditation_life/features/meditation/presentation/pages/meditation_page.dart';
import 'package:meditation_life/features/meditation_history/presentation/meditation_history_page.dart';
import 'package:meditation_life/features/setting/setting_page.dart';
import 'package:meditation_life/shared/widgets/background_image_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_page.g.dart';

@riverpod
class SelectedTabIndex extends _$SelectedTabIndex {
  @override
  int build() => 0;
  void switchTab({required int index}) => state = index;
}

class MainPage extends HookConsumerWidget {
  MainPage({super.key});

  static const meditationPageIndex = 2;
  final pages = <Widget>[
    MeditationHistoryPage(),
    const SettingPage(),
    const MeditationPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: BackgroundImageWrapper(
        child: pages[ref.watch(selectedTabIndexProvider)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref
              .read(selectedTabIndexProvider.notifier)
              .switchTab(index: meditationPageIndex);
        }.withFeedback(),
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
        activeIndex: ref.watch(selectedTabIndexProvider),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (int index) async {
          ref.read(selectedTabIndexProvider.notifier).switchTab(index: index);
        }.withFeedback(),
      ),
    );
  }
}
