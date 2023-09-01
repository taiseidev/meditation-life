import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/meditation/presentation/meditation_detail_page.dart';
import 'package:meditation_life/features/meditation/presentation/meditation_notifier.dart';

class MeditationPage extends ConsumerWidget {
  const MeditationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(meditationNotifierProvider);
    return Scaffold(
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
                  '時間：${formatTime(meditation.duration)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeditationDetailView(meditation),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => const Center(
          child: Text("エラーが発生しました"),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
