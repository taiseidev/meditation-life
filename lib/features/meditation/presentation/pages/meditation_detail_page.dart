import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meditation_life/core/extension/int_extension.dart';
import 'package:meditation_life/core/extension/void_callback_ext.dart';
import 'package:meditation_life/core/res/color.dart';
import 'package:meditation_life/core/utils/ad_mob_util.dart';
import 'package:meditation_life/core/utils/strings.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/presentation/meditation_play_page.dart';

class MeditationDetailView extends StatefulWidget {
  const MeditationDetailView(this.meditation, {super.key});
  final Meditation meditation;

  @override
  State<MeditationDetailView> createState() => _MeditationDetailViewState();
}

class _MeditationDetailViewState extends State<MeditationDetailView> {
  InterstitialAd? _interstitialAd;
  final adInterstitial = AdInterstitialService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    adInterstitial.create();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Full-screen background image with gradient overlay
          Positioned.fill(
            child: Hero(
              tag: widget.meditation.id,
              child: Stack(
                children: [
                  // Image
                  CachedNetworkImage(
                    imageUrl: widget.meditation.thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColor.primary.withOpacity(0.3),
                          AppColor.primary.withOpacity(0.7),
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
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  // Title
                  Text(
                    widget.meditation.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Duration
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.meditation.duration.formatTime(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Start button
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await Future<void>.delayed(const Duration(seconds: 1));
                      await adInterstitial.show();
                      setState(() {
                        isLoading = false;
                      });
                      if (context.mounted) {
                        await Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                MeditationPlayScreen(widget.meditation),
                          ),
                        );
                      }
                    }.withFeedback(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.secondary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: AppColor.secondary.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_circle_outline, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          Strings.meditationStartButtonLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (isLoading)
            Container(
              color: AppColor.primary.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColor.secondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
