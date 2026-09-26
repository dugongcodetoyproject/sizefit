import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizefit/core/localization/app_strings.dart';

void main() {
  group('Localization AppStrings Tests', () {
    test('provides English strings by default', () {
      final strings = AppStrings(const Locale('en'));
      expect(strings.get('appName'), 'SizeFit');
      expect(strings.get('selectPhoto'), 'Select Photo');
      expect(strings.get('saveToGallery'), 'Save to Gallery');
    });

    test('provides Korean strings correctly', () {
      final strings = AppStrings(const Locale('ko'));
      expect(strings.get('appName'), 'SizeFit');
      expect(strings.get('selectPhoto'), '사진 선택');
      expect(strings.get('saveToGallery'), '갤러리에 저장');
      expect(strings.get('fitUnder'), '이하로 맞추기');
    });

    test('provides Japanese strings correctly', () {
      final strings = AppStrings(const Locale('ja'));
      expect(strings.get('appName'), 'SizeFit');
      expect(strings.get('selectPhoto'), '写真を選択');
      expect(strings.get('saveToGallery'), 'ギャラリーに保存');
    });

    test('falls back to English when key is missing in other locales', () {
      final strings = AppStrings(const Locale('ko'));
      expect(strings.get('unknown_key'), 'unknown_key');
    });
  });
}
