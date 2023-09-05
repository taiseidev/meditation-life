import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation/presentation/meditation_notifier.dart';
import 'package:meditation_life/features/meditation/presentation/pages/meditation_detail_page.dart';
import 'package:meditation_life/shared/extension/int_extension.dart';

class MeditationPage extends ConsumerWidget {
  const MeditationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(meditationNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        title: const Text(
          '瞑想一覧',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: data.when(
        data: (meditations) {
          return ListView.builder(
            itemCount: meditations.length,
            itemBuilder: (context, index) {
              final meditation = meditations[index];
              return ListTile(
                leading: Hero(
                  tag: meditation.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: meditation.thumbnailUrl,
                      width: 100,
                    ),
                  ),
                ),
                title: Text(
                  meditation.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '時間：${meditation.duration.formatTime()}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => MeditationDetailView(meditation),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => const Center(
          child: Text('エラーが発生しました'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
