import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/admob_service.dart';

class AdaptiveBannerWidget extends StatefulWidget {
  const AdaptiveBannerWidget({super.key});

  @override
  State<AdaptiveBannerWidget> createState() => _AdaptiveBannerWidgetState();
}

class _AdaptiveBannerWidgetState extends State<AdaptiveBannerWidget>
    with WidgetsBindingObserver {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;
  int _retryAttempts = 0;
  static const int _maxRetryAttempts = 5;
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBanner();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_isLoaded && !_isLoading) {
        _loadBanner();
      }
    }
  }

  void _loadBanner() {
    // Only run on mobile platforms (Android/iOS)
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    if (_isLoading || _isLoaded) {
      return;
    }

    final adUnitId = AdMobService.bannerAdUnitId;
    if (adUnitId.isEmpty) {
      return;
    }

    _isLoading = true;
    try {
      _bannerAd?.dispose();
      _bannerAd = BannerAd(
        adUnitId: adUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            debugPrint('AdaptiveBannerWidget: Ad loaded successfully');
            _retryAttempts = 0;
            _retryTimer?.cancel();
            if (mounted) {
              setState(() {
                _isLoaded = true;
                _isLoading = false;
              });
            }
          },
          onAdFailedToLoad: (ad, err) {
            debugPrint(
                'AdaptiveBannerWidget: Failed to load: $err (attempt: $_retryAttempts)');
            try {
              ad.dispose();
            } catch (_) {}
            if (mounted) {
              setState(() {
                _isLoaded = false;
                _isLoading = false;
                _bannerAd = null;
              });

              // Exponential / progressive retry backoff if failed (e.g. startup network latency)
              if (_retryAttempts < _maxRetryAttempts) {
                _retryAttempts++;
                final delaySeconds = _retryAttempts * 5; // 5s, 10s, 15s, 20s, 25s
                _retryTimer?.cancel();
                _retryTimer = Timer(Duration(seconds: delaySeconds), () {
                  if (mounted && !_isLoaded && !_isLoading) {
                    _loadBanner();
                  }
                });
              }
            }
          },
        ),
      )..load();
    } catch (e) {
      debugPrint('AdaptiveBannerWidget: Error initializing banner: $e');
      _isLoading = false;
      _bannerAd = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _retryTimer?.cancel();
    try {
      _bannerAd?.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return const SizedBox.shrink();
    }

    // Reserve fixed height (50dp standard banner height)
    // to prevent sudden layout shift (CLS) and button jumping when the ad loads.
    const bannerHeight = 50.0;

    return SizedBox(
      height: bannerHeight,
      width: double.infinity,
      child: Center(
        child: _isLoaded && _bannerAd != null
            ? SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
