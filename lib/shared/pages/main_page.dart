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

/// タブインデックスを管理するプロバイダー
@riverpod
class SelectedTabIndex extends _$SelectedTabIndex {
  @override
  int build() => 0;

  /// タブを切り替える
  void switchTab({required int index}) => state = index;
}

/// メインページ
class MainPage extends HookConsumerWidget {
  MainPage({super.key});

  // タブインデックスの定数
  static const historyPageIndex = 0;
  static const settingPageIndex = 1;
  static const meditationPageIndex = 2;

  // 各タブに対応するページ
  final List<Widget> _pages = <Widget>[
    MeditationHistoryPage(),
    const SettingPage(),
    const MeditationPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTabIndex = ref.watch(selectedTabIndexProvider);

    return Scaffold(
      body: BackgroundImageWrapper(
        child: _pages[selectedTabIndex],
      ),
      floatingActionButton: _buildFloatingActionButton(ref),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(ref, selectedTabIndex),
    );
  }

  /// フローティングアクションボタンを構築
  Widget _buildFloatingActionButton(WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColor.secondary.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          ref
              .read(selectedTabIndexProvider.notifier)
              .switchTab(index: meditationPageIndex);
        }.withFeedback(),
        backgroundColor: AppColor.secondary,
        elevation: 4,
        shape: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.secondary,
                AppColor.secondary.withOpacity(0.8),
              ],
            ),
          ),
          child: const Icon(
            Icons.self_improvement,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  /// ボトムナビゲーションバーを構築
  Widget _buildBottomNavigationBar(WidgetRef ref, int activeIndex) {
    return AnimatedBottomNavigationBar(
      backgroundColor: AppColor.primary,
      activeColor: Colors.white,
      inactiveColor: Colors.white.withOpacity(0.6),
      icons: const [
        Icons.history_outlined,
        Icons.settings_outlined,
      ],
      iconSize: 24,
      activeIndex: activeIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 24,
      rightCornerRadius: 24,
      elevation: 8,
      shadow: BoxShadow(
        color: AppColor.primary.withOpacity(0.3),
        blurRadius: 10,
        spreadRadius: 0,
        offset: const Offset(0, -5),
      ),
      onTap: (int index) {
        ref.read(selectedTabIndexProvider.notifier).switchTab(index: index);
      }.withFeedback(),
    );
  }
}
