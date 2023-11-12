import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          widget.meditation.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Hero(
                  tag: widget.meditation.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.meditation.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
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
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      Strings.meditationStartButtonLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.secondary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
