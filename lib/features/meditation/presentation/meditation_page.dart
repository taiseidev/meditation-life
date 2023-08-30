import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
                leading: Image.network(meditation.thumbnailUrl),
                title: Text(meditation.title),
                subtitle: Text('${meditation.duration} minutes'),
                onTap: () {},
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
