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
        title: const Text('瞑想一覧'),
      ),
      body: data.when(
        data: (meditations) {
          return ListView.builder(
            itemCount: meditations.length,
            itemBuilder: (context, index) {
              final meditation = meditations[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Hero(
                    tag: meditation.id,
                    child: CachedNetworkImage(
                      imageUrl: meditation.thumbnailUrl,
                      width: 100,
                    ),
                  ),
                ),
                title: Text(meditation.title),
                subtitle: Text('${meditation.duration} minutes'),
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
}
