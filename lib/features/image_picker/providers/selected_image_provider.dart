import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/image_meta_info.dart';
import '../services/photo_picker_service.dart';

final photoPickerServiceProvider = Provider<PhotoPickerService>((ref) {
  return PhotoPickerService();
});

class SelectedImageNotifier extends Notifier<AsyncValue<ImageMetaInfo?>> {
  @override
  AsyncValue<ImageMetaInfo?> build() => const AsyncValue.data(null);

  Future<void> pickPhoto() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(photoPickerServiceProvider);
      final info = await service.pickPhoto();
      state = AsyncValue.data(info);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setImage(ImageMetaInfo info) {
    state = AsyncValue.data(info);
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

final selectedImageProvider =
    NotifierProvider<SelectedImageNotifier, AsyncValue<ImageMetaInfo?>>(
  SelectedImageNotifier.new,
);
