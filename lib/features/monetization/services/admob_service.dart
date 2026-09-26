import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../core/constants/app_constants.dart';

class AdMobService {
  static const bool enableInterstitial = false; // Disabled for MVP as per spec

  static String get bannerAdUnitId {
    // In debug mode, use Google's official test ID to prevent policy violations
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return AppConstants.androidBannerTestId;
      } else if (Platform.isIOS) {
        return AppConstants.iosBannerTestId;
      }
    }

    if (Platform.isAndroid) {
      return AppConstants.androidBannerProductionId;
    } else if (Platform.isIOS) {
      return AppConstants.iosBannerProductionId;
    }
    return '';
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    return '';
  }

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoaded = false;

  void loadInterstitial() {
    if (!enableInterstitial || kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoaded = true;
        },
        onAdFailedToLoad: (err) {
          debugPrint('Interstitial failed to load: $err');
          _interstitialAd = null;
          _isInterstitialLoaded = false;
        },
      ),
    );
  }

  void showInterstitialIfAvailable({VoidCallback? onComplete}) {
    if (!_isInterstitialLoaded || _interstitialAd == null) {
      onComplete?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialLoaded = false;
        onComplete?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialLoaded = false;
        onComplete?.call();
      },
    );

    _interstitialAd!.show();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
