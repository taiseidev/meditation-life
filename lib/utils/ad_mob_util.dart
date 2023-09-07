import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meditation_life/utils/flavor.dart';

String _getAdUnitId({
  required String androidId,
  required String iosId,
}) {
  if (Platform.isAndroid) {
    return androidId;
  } else if (Platform.isIOS) {
    return iosId;
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}

// バナー広告を管理
class AdBannerService {
  AdBannerService();
  AdBannerService._();

  BannerAd? _bannerAd;
  BannerAd? get bannerAd => _bannerAd;

  final _bannerAdUnitId = Flavor.environment == FlavorType.dev
      ? _getAdUnitId(
          androidId: 'ca-app-pub-3940256099942544/6300978111',
          iosId: 'ca-app-pub-3940256099942544/2934735716',
        )
      : _getAdUnitId(
          androidId: 'ca-app-pub-5636285754013517/4778022335',
          iosId: 'ca-app-pub-5636285754013517/3286892985',
        );

  void create() => BannerAd(
        adUnitId: _bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (_bannerAd == null) {
              debugPrint('Loaded ad');
              _bannerAd = ad as BannerAd;
            }
          },
          onAdFailedToLoad: (ad, _) {
            debugPrint('Failed to load ad');
            ad.dispose();
          },
        ),
      ).load();
}

// インタースティシャル広告を管理
class AdInterstitialService {
  InterstitialAd? _interstitialAd;

  final _interstitialAdUnitId = Flavor.environment == FlavorType.dev
      ? _getAdUnitId(
          androidId: 'ca-app-pub-3940256099942544/1033173712',
          iosId: 'ca-app-pub-3940256099942544/4411468910',
        )
      : _getAdUnitId(
          androidId: 'ca-app-pub-5636285754013517/4603882073',
          iosId: 'ca-app-pub-5636285754013517/1674466408',
        );

  void create() => InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint('Loaded ad');
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (_) {
            debugPrint('Failed to load ad');
            _interstitialAd = null;
          },
        ),
      );

  // 広告表示
  Future<void> show() async {
    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        debugPrint('ad onAdshowedFullscreen');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('ad Disposed');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
        debugPrint('$ad OnAdFailed $aderror');
        ad.dispose();
        create();
      },
    );

    await _interstitialAd!.show();
    _interstitialAd = null;
  }
}
