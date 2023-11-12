import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/core/res/color.dart';
import 'package:meditation_life/features/meditation_history/domain/usecase/meditation_history_usecase.dart';
import 'package:meditation_life/features/meditation_history/presentation/meditation_history_notifier.dart';
import 'package:meditation_life/shared/pages/main_page.dart';

class MeditationCompletedModal extends StatelessWidget {
  const MeditationCompletedModal({
    super.key,
    required this.meditationId,
  });

  final String meditationId;

  static const encouragementMessages = [
    'よくやった！また明日も頑張ろう！',
    '今日も一日頑張りましたね！',
    '瞑想でリラックス、最高！',
    '瞑想で心地よい一時を過ごしましたね！',
    '瞑想で心が落ち着きましたね！',
    '瞑想でストレス解消！',
    '瞑想で集中力アップ！',
    '瞑想でリフレッシュ！',
    '自分を見つめ直す時間、大切にしよう！',
    '良い眠りのために、瞑想を続けよう！',
    '心と体のバランス、大切にしよう！',
    'ポジティブな思考で、毎日を過ごそう！',
    '心の平穏のために、瞑想を続けよう！',
    '自分を受け入れる力、大切にしよう！',
    '心の健康のために、瞑想を続けよう！',
    'ストレス解消のために、瞑想を続けよう！',
    '心と体のバランス、大切にしよう！',
    '自分を見つめ直す時間、大切にしよう！',
    '心の平穏のために、瞑想を続けよう！',
    '自分を受け入れる力、大切にしよう！',
    '心と体の健康のために、瞑想を続けよう！',
    '自分を見つめ直す時間、大切にしよう！',
    '心の平穏のために、瞑想を続けよう！',
    '自分を受け入れる力、大切にしよう！',
    '心と体の健康のために、瞑想を続けよう！',
    '自分を見つめ直す時間、大切にしよう！',
    '心の平穏のために、瞑想を続けよう！',
    '自分を受け入れる力、大切にしよう！',
    '心と体の健康のために、瞑想を続けよう！',
    '自分を見つめ直す時間、大切にしよう！',
  ];

  String outputRandomMessage() {
    final random = math.Random();
    return encouragementMessages[random.nextInt(encouragementMessages.length)];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.secondary,
      surfaceTintColor: Colors.transparent,
      title: const Text(
        '今日もお疲れ様でした！',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        outputRandomMessage(),
        style: const TextStyle(
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
                // 瞑想履歴のProviderをリフレッシュ
                ref.invalidate(meditationHistoryNotifierProvider);
                // 瞑想履歴をFirestoreに保存
                await ref
                    .read(meditationHistoryUsecaseProvider)
                    .addMeditationHistory(
                      meditationId,
                      DateTime.now(),
                    );
                if (context.mounted) {
                  // 音源再生画面を全て閉じてタブを切り替え
                  Navigator.popUntil(context, (route) => route.isFirst);
                  ref
                      .read(selectedTabIndexProvider.notifier)
                      .switchTab(index: 0);
                }
              },
              child: const Text(
                '閉じる',
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
