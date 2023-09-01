import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation/domain/usecase/meditation_usecase.dart';
import 'package:meditation_life/shared/main_page.dart';

class MeditationCompletedModal extends StatelessWidget {
  const MeditationCompletedModal({
    super.key,
    required this.meditationId,
  });

  final String meditationId;

  static const encouragementMessages = [
    "よくやった！また明日も頑張ろう！",
    "今日も一日頑張りましたね！",
    "瞑想でリラックス、最高！",
    "瞑想で心地よい一時を過ごしましたね！",
    "瞑想で心が落ち着きましたね！",
    "瞑想でストレス解消！",
    "瞑想で集中力アップ！",
    "瞑想でリフレッシュ！",
    "自分を見つめ直す時間、大切にしよう！",
    "良い眠りのために、瞑想を続けよう！",
    "心と体のバランス、大切にしよう！",
    "ポジティブな思考で、毎日を過ごそう！",
    "心の平穏のために、瞑想を続けよう！",
    "自分を受け入れる力、大切にしよう！",
    "心の健康のために、瞑想を続けよう！",
    "ストレス解消のために、瞑想を続けよう！",
    "心と体のバランス、大切にしよう！",
    "自分を見つめ直す時間、大切にしよう！",
    "心の平穏のために、瞑想を続けよう！",
    "自分を受け入れる力、大切にしよう！",
    "心と体の健康のために、瞑想を続けよう！",
    "自分を見つめ直す時間、大切にしよう！",
    "心の平穏のために、瞑想を続けよう！",
    "自分を受け入れる力、大切にしよう！",
    "心と体の健康のために、瞑想を続けよう！",
    "自分を見つめ直す時間、大切にしよう！",
    "心の平穏のために、瞑想を続けよう！",
    "自分を受け入れる力、大切にしよう！",
    "心と体の健康のために、瞑想を続けよう！",
    "自分を見つめ直す時間、大切にしよう！",
  ];

  String outputRandomMessage() {
    final random = math.Random();
    return encouragementMessages[random.nextInt(encouragementMessages.length)];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('今日もお疲れ様でした！'),
      content: Text(outputRandomMessage()),
      actions: <Widget>[
        Consumer(
          builder: (context, ref, child) {
            return ElevatedButton(
              // 本日の瞑想データを保存して、履歴画面に遷移する。
              onPressed: () async {
                await ref
                    .read(meditationUsecaseProvider)
                    .addMeditation(meditationId);
                if (context.mounted) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  ref
                      .read(selectedIndexProvider.notifier)
                      .update((state) => state = 0);
                }
              },
              child: const Text("終了"),
            );
          },
        )
      ],
    );
  }
}