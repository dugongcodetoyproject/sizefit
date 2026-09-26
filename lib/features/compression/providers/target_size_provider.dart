import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';

class TargetSizeNotifier extends Notifier<int> {
  @override
  int build() => AppConstants.defaultTargetKb;

  void setTargetKb(int kb) {
    if (kb > 0) {
      state = kb;
    }
  }

  void reset() {
    state = AppConstants.defaultTargetKb;
  }
}

final targetSizeProvider =
    NotifierProvider<TargetSizeNotifier, int>(TargetSizeNotifier.new);
