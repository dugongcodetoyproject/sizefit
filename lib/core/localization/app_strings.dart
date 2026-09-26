import 'package:flutter/material.dart';

class AppStrings {
  final Locale locale;

  AppStrings(this.locale);

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ??
        AppStrings(const Locale('en'));
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'appName': 'SizeFit',
      'appTagline': 'Make any photo fit the upload limit.',
      'privacyNotice': 'Processed entirely on your device.',
      'selectPhoto': 'Select Photo',
      'selectPhotoDesc': 'Tap to choose from your gallery (JPEG, PNG, WebP)',
      'loadingPhotoDetails': 'Loading photo details...',
      'targetSizeLimit': 'Target Size Limit',
      'mustBeUnder': 'Must be under this limit',
      'custom': 'Custom...',
      'customTargetTitle': 'Custom Target Size',
      'customTargetSubtitle': 'Target file size limit for uploads.',
      'selectPhotoToStart': 'Select Photo to Start',
      'fitUnder': 'Fit under',
      'resultTitle': 'Result',
      'fitsLimit': 'FITS UPLOAD LIMIT',
      'closestFit': 'CLOSEST FIT',
      'savedPercentage': 'saved',
      'resultSize': 'Result Size',
      'target': 'target',
      'original': 'Original',
      'resolution': 'Resolution',
      'qualityScore': 'Quality Score',
      'qualityWarning': 'Very small target size may reduce image quality.',
      'pinchToZoom': 'Pinch to zoom',
      'saveToGallery': 'Save to Gallery',
      'savedToGallery': 'Saved to Gallery',
      'share': 'Share',
      'compressAnother': 'Compress Another Photo',
      'errorProcess': "Couldn't process this photo. Please try another image.",
      'errorSave': 'Failed to save image. Please check storage permissions.',
      'errorShare': 'Failed to open share sheet.',
    },
    'ko': {
      'appName': 'SizeFit',
      'appTagline': '어떤 사진이든 업로드 용량에 딱 맞게.',
      'privacyNotice': '모든 처리는 기기 내부에서 안전하게 진행됩니다.',
      'selectPhoto': '사진 선택',
      'selectPhotoDesc': '갤러리에서 사진을 선택하세요 (JPEG, PNG, WebP 지원)',
      'loadingPhotoDetails': '사진 정보 불러오는 중...',
      'targetSizeLimit': '목표 용량 제한',
      'mustBeUnder': '이 크기 이하로 맞춰집니다',
      'custom': '직접 입력...',
      'customTargetTitle': '목표 용량 직접 입력',
      'customTargetSubtitle': '업로드할 사이트의 파일 크기 제한을 입력하세요.',
      'selectPhotoToStart': '사진을 선택해주세요',
      'fitUnder': '이하로 맞추기',
      'resultTitle': '압축 완료',
      'fitsLimit': '용량 제한 통과',
      'closestFit': '최대 근접 압축',
      'savedPercentage': '용량 절감',
      'resultSize': '결과 용량',
      'target': '목표',
      'original': '원본 용량',
      'resolution': '해상도',
      'qualityScore': '품질 점수',
      'qualityWarning': '목표 용량이 너무 작아 이미지 품질이 저하될 수 있습니다.',
      'pinchToZoom': '두 손가락으로 확대',
      'saveToGallery': '갤러리에 저장',
      'savedToGallery': '저장 완료',
      'share': '공유하기',
      'compressAnother': '다른 사진 압축하기',
      'errorProcess': '사진을 처리할 수 없습니다. 다른 사진으로 시도해주세요.',
      'errorSave': '저장에 실패했습니다. 저장 공간 권한을 확인해주세요.',
      'errorShare': '공유 창을 열 수 없습니다.',
    },
    'ja': {
      'appName': 'SizeFit',
      'appTagline': 'どんな写真もアップロード制限にピッタリ.',
      'privacyNotice': 'すべての処理はお使いの端末内で行われます.',
      'selectPhoto': '写真を選択',
      'selectPhotoDesc': 'ギャラリーから写真を選択 (JPEG, PNG, WebP対応)',
      'loadingPhotoDetails': '写真情報を読み込み中...',
      'targetSizeLimit': '目標ファイルサイズ',
      'mustBeUnder': 'このサイズ以下に調整されます',
      'custom': 'カスタム...',
      'customTargetTitle': '目標サイズを直接入力',
      'customTargetSubtitle': 'アップロード先の制限サイズを入力してください.',
      'selectPhotoToStart': '写真を選択して開始',
      'fitUnder': '以下に圧縮',
      'resultTitle': '圧縮完了',
      'fitsLimit': '制限クリア',
      'closestFit': '近似圧縮',
      'savedPercentage': '削減',
      'resultSize': '圧縮後のサイズ',
      'target': '目標',
      'original': '元のサイズ',
      'resolution': '解像度',
      'qualityScore': '品質スコア',
      'qualityWarning': '目標サイズが小さすぎるため、画質が低下する可能性があります.',
      'pinchToZoom': 'ピンチして拡大',
      'saveToGallery': 'ギャラリーに保存',
      'savedToGallery': '保存完了',
      'share': '共有',
      'compressAnother': '別の写真を圧縮',
      'errorProcess': 'この写真を処理できませんでした. 別の写真をお試しください.',
      'errorSave': '画像の保存に失敗しました. 権限を確認してください.',
      'errorShare': '共有を開けませんでした.',
    },
  };

  String get(String key) {
    final langCode = locale.languageCode;
    return _localizedValues[langCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppStrings> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ko', 'ja'].contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) async {
    return AppStrings(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
