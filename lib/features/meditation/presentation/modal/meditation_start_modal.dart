import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/presentation/meditation_play_page.dart';
import 'package:meditation_life/shared/res/color.dart';

class MeditationStartModal extends StatelessWidget {
  const MeditationStartModal({
    super.key,
    required this.meditation,
  });

  final Meditation meditation;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.secondary,
      surfaceTintColor: Colors.transparent,
      title: const Text(
        '瞑想を開始しますか？',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        '静かな場所に座り、心地よい姿勢を取ってください。',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        Consumer(
          builder: (context, ref, child) {
            return TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeditationPlayScreen(
                      meditation,
                    ),
                  ),
                );
              },
              child: const Text(
                '開始',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
