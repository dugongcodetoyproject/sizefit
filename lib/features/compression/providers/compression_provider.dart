import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/compression_request.dart';
import '../models/compression_result.dart';
import '../services/compression_service.dart';

final compressionServiceProvider = Provider<CompressionService>((ref) {
  return CompressionService();
});

class CompressionState {
  final bool isCompressing;
  final double progress;
  final String statusText;
  final CompressionResult? result;
  final Object? error;

  const CompressionState({
    this.isCompressing = false,
    this.progress = 0.0,
    this.statusText = '',
    this.result,
    this.error,
  });

  CompressionState copyWith({
    bool? isCompressing,
    double? progress,
    String? statusText,
    CompressionResult? result,
    Object? error,
  }) {
    return CompressionState(
      isCompressing: isCompressing ?? this.isCompressing,
      progress: progress ?? this.progress,
      statusText: statusText ?? this.statusText,
      result: result ?? this.result,
      error: error,
    );
  }
}

class CompressionNotifier extends Notifier<CompressionState> {
  @override
  CompressionState build() => const CompressionState();

  Future<CompressionResult?> compress(CompressionRequest request) async {
    state = state.copyWith(
      isCompressing: true,
      progress: 0.0,
      statusText: 'Starting optimization...',
      error: null,
    );

    try {
      final service = ref.read(compressionServiceProvider);
      final result = await service.compressToTarget(
        request,
        onProgress: (progress, status) {
          state = state.copyWith(
            progress: progress,
            statusText: status,
          );
        },
      );

      state = state.copyWith(
        isCompressing: false,
        progress: 1.0,
        statusText: 'Done',
        result: result,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        isCompressing: false,
        error: e,
        statusText: 'Compression failed',
      );
      return null;
    }
  }

  void reset() {
    state = const CompressionState();
  }
}

final compressionNotifierProvider =
    NotifierProvider<CompressionNotifier, CompressionState>(
  CompressionNotifier.new,
);
