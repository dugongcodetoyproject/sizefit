abstract final class AppConstants {
  static const String appName = 'SizeFit';
  static const String appTagline = 'Make any photo fit the upload limit.';
  static const String privacyNotice = 'Processed entirely on your device.';

  // Target presets in KB
  static const List<int> defaultPresetsKb = [
    50,
    100,
    200,
    300,
    500,
    1000,
    2000,
  ];

  static const int defaultTargetKb = 200;

  // Compression limits
  static const int minLongEdgePx = 480;
  static const int minQuality = 10;
  static const int maxQuality = 98;
  static const int maxBinarySearchSteps = 6;

  // Scale levels for fallback downscaling
  static const List<double> scaleLevels = [
    1.0,
    0.85,
    0.70,
    0.55,
    0.40,
    0.30,
  ];

  // AdMob App ID
  static const String admobAppId = 'ca-app-pub-5510692764435204~6458417892';

  // AdMob Production Banner Unit IDs
  // Note: AdMob ad units use '/' separator (e.g., ca-app-pub-XXXX/YYYY)
  static const String androidBannerProductionId =
      'ca-app-pub-5510692764435204/6458417892';
  static const String iosBannerProductionId =
      'ca-app-pub-5510692764435204/6458417892';

  // AdMob Test Unit IDs (used during development in kDebugMode)
  // Android test banner unit ID
  static const String androidBannerTestId =
      'ca-app-pub-3940256099942544/6300978111';
  // iOS test banner unit ID
  static const String iosBannerTestId =
      'ca-app-pub-3940256099942544/2934735716';
}
