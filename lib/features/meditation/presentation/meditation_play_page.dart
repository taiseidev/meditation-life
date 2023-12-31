import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation_life/core/extension/int_extension.dart';
import 'package:meditation_life/core/extension/void_callback_ext.dart';
import 'package:meditation_life/core/res/color.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/presentation/modal/meditation_completed_modal.dart';

class MeditationPlayScreen extends StatefulWidget {
  const MeditationPlayScreen(this.meditation, {super.key});

  final Meditation meditation;

  @override
  MeditationPlayScreenState createState() => MeditationPlayScreenState();
}

class MeditationPlayScreenState extends State<MeditationPlayScreen> {
  bool isPlaying = false;
  double volume = 0.5;
  double sliderValue = 0;
  bool isDragging = false;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    Future(() async {
      await player.setUrl(widget.meditation.audioUrl);
    });

    player.playerStateStream.listen(
      (state) async {
        if (state.processingState == ProcessingState.completed) {
          await player.stop();
          if (context.mounted) {
            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return MeditationCompletedModal(
                  meditationId: widget.meditation.id,
                );
              },
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: widget.meditation.id,
              child: CachedNetworkImage(
                imageUrl: widget.meditation.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: IconButton(
              onPressed: () async {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }.withFeedback(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DefaultTextStyle(
              style: const TextStyle(fontWeight: FontWeight.bold),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.meditation.title,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        color: Colors.white,
                        iconSize: 64,
                        onPressed: () async {
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                          if (isPlaying) {
                            await player.play();
                          } else {
                            await player.stop();
                          }
                        }.withFeedback(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<Duration>(
                    stream: player.positionStream,
                    builder: (context, snapshot) {
                      final position =
                          snapshot.data?.inSeconds.toDouble() ?? 0.0;
                      return Slider(
                        value: isDragging
                            ? sliderValue
                            : position > widget.meditation.duration.toDouble()
                                ? widget.meditation.duration.toDouble()
                                : position,
                        max: widget.meditation.duration.toDouble(),
                        onChangeEnd: (value) {
                          isDragging = false;
                          player.seek(Duration(seconds: value.toInt()));
                        },
                        activeColor: AppColor.secondary,
                        thumbColor: AppColor.secondary,
                        secondaryActiveColor: AppColor.secondary,
                        onChanged: (value) {
                          setState(() {
                            isDragging = true;
                            sliderValue = value;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<Duration>(
                        stream: player.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          return Text(
                            position.inSeconds.formatTime(),
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                      Text(
                        widget.meditation.duration.formatTime(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
