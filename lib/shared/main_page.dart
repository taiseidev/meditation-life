import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("こんにちは"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.red,
        icons: const [Icons.add, Icons.add],
        activeIndex: 0,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {},
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
