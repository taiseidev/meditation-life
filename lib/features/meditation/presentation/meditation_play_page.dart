import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';

class MeditationPlayScreen extends StatefulWidget {
  const MeditationPlayScreen(this.meditation, {super.key});

  final Meditation meditation;

  @override
  _MeditationPlayScreenState createState() => _MeditationPlayScreenState();
}

class _MeditationPlayScreenState extends State<MeditationPlayScreen> {
  bool isPlaying = false;
  double volume = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.meditation.thumbnailUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DefaultTextStyle(
              style: const TextStyle(fontWeight: FontWeight.bold),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Meditation Title',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Meditation Description',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Slider(
                      value: volume,
                      onChanged: (value) {
                        setState(() {
                          volume = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon:
                              Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                          color: Colors.white,
                          iconSize: 64,
                          onPressed: () {
                            setState(() {
                              isPlaying = !isPlaying;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '10:00',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '20:00',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
