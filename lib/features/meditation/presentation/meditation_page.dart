import 'package:flutter/material.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';

class MeditationPage extends StatelessWidget {
  const MeditationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('瞑想一覧'),
      ),
      body: ListView.builder(
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
      ),
    );
  }
}

// ダミーデータ
final meditations = [
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
  Meditation(
    id: "id",
    title: "titleLarge",
    duration: 30,
    thumbnailUrl:
        "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
    audioUrl: "audioUrl",
  ),
];
