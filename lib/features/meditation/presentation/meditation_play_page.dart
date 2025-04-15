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

class MeditationPlayScreenState extends State<MeditationPlayScreen> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  double volume = 0.5;
  double sliderValue = 0;
  bool isDragging = false;

  // Animation controller for the breathing animation
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Set up breathing animation
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );

    // Make the animation repeat forward and backward
    _breathingController.repeat(reverse: true);

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
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
      body: Stack(
        children: [
          // Background image with gradient overlay
          Positioned.fill(
            child: Hero(
              tag: widget.meditation.id,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.meditation.thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColor.primary.withOpacity(0.4),
                          AppColor.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    widget.meditation.title,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Breathing animation circle
                  Center(
                    child: AnimatedBuilder(
                      animation: _breathingAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 180 * _breathingAnimation.value,
                          height: 180 * _breathingAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isPlaying
                                ? AppColor.secondary.withOpacity(0.2)
                                : AppColor.secondary.withOpacity(0.1),
                            border: Border.all(
                              color: isPlaying
                                  ? AppColor.secondary
                                  : AppColor.secondary.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 64,
                              ),
                              color: Colors.white,
                              onPressed: () async {
                                setState(() {
                                  isPlaying = !isPlaying;
                                });
                                if (isPlaying) {
                                  await player.play();
                                } else {
                                  await player.pause();
                                }
                              }.withFeedback(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Progress slider
                  StreamBuilder<Duration>(
                    stream: player.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data?.inSeconds.toDouble() ?? 0.0;
                      return Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 16,
                              ),
                              trackShape: const RoundedRectSliderTrackShape(),
                            ),
                            child: Slider(
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
                              inactiveColor: Colors.white.withOpacity(0.3),
                              thumbColor: Colors.white,
                              onChanged: (value) {
                                setState(() {
                                  isDragging = true;
                                  sliderValue = value;
                                });
                              },
                            ),
                          ),

                          // Time indicators
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StreamBuilder<Duration>(
                                  stream: player.positionStream,
                                  builder: (context, snapshot) {
                                    final position = snapshot.data ?? Duration.zero;
                                    return Text(
                                      position.inSeconds.formatTime(),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  widget.meditation.duration.formatTime(),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Volume control
                  Row(
                    children: [
                      const Icon(
                        Icons.volume_down,
                        color: Colors.white,
                        size: 24,
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 12,
                            ),
                            trackShape: const RoundedRectSliderTrackShape(),
                          ),
                          child: Slider(
                            value: volume,
                            onChanged: (value) {
                              setState(() {
                                volume = value;
                                player.setVolume(volume);
                              });
                            },
                            activeColor: AppColor.secondary,
                            inactiveColor: Colors.white.withOpacity(0.3),
                            thumbColor: Colors.white,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 24,
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
    _breathingController.dispose();
    player.dispose();
    super.dispose();
  }
}
