// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sizefit/features/compression/models/compression_request.dart';
import 'package:sizefit/features/compression/services/compression_service.dart';
import 'package:sizefit/features/compression/services/image_compressor_interface.dart';

// Fake PathProvider for unit tests
class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }
}

// Simulated Compressor that mimics realistic JPEG file size curves based on Quality & Scale
class SimulatedImageCompressor implements ImageCompressorInterface {
  final int baseBytes;

  SimulatedImageCompressor({this.baseBytes = 2 * 1024 * 1024});

  @override
  Future<Uint8List> compressWithFile({
    required String path,
    required int minWidth,
    required int minHeight,
    required int quality,
    required String format,
    required bool autoCorrectionAngle,
    required bool keepExif,
  }) async {
    // Realistic model: size ~ baseBytes * scaleArea * (quality / 100)^1.4
    // 1000x1000 base
    final double areaRatio = (minWidth * minHeight) / (1000 * 1000);
    final double qFactor = (quality / 100.0) * (quality / 100.0);
    final int estimatedBytes =
        (baseBytes * areaRatio * qFactor).round().clamp(500, baseBytes);

    return Uint8List(estimatedBytes);
  }

  @override
  Future<void> compressToFile({
    required String sourcePath,
    required String targetPath,
    required int minWidth,
    required int minHeight,
    required int quality,
    required String format,
    required bool autoCorrectionAngle,
    required bool keepExif,
  }) async {
    final bytes = await compressWithFile(
      path: sourcePath,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
      format: format,
      autoCorrectionAngle: autoCorrectionAngle,
      keepExif: keepExif,
    );
    await File(targetPath).writeAsBytes(bytes);
  }
}

// Helper to generate a valid test image file
Future<File> createTestImageFile({
  required String name,
  required int width,
  required int height,
  required int fileSizeBytes,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  final paint = ui.Paint()..color = const ui.Color(0xFF2563EB);
  canvas.drawRect(
    ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    paint,
  );
  final picture = recorder.endRecording();
  final img = await picture.toImage(width, height);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  img.dispose();
  picture.dispose();

  final tempDir = Directory.systemTemp;
  final file = File(p.join(tempDir.path, name));

  // Write valid PNG header + dummy bytes to achieve fileSizeBytes
  final realBytes = byteData!.buffer.asUint8List();
  if (fileSizeBytes > realBytes.length) {
    final fullBytes = Uint8List(fileSizeBytes);
    fullBytes.setRange(0, realBytes.length, realBytes);
    await file.writeAsBytes(fullBytes);
  } else {
    await file.writeAsBytes(realBytes);
  }
  return file;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = FakePathProviderPlatform();

  group('Compression Binary Search Algorithm Tests', () {
    late File sample2MbFile;

    setUpAll(() async {
      sample2MbFile = await createTestImageFile(
        name: 'test_sample_2mb.png',
        width: 1000,
        height: 1000,
        fileSizeBytes: 2 * 1024 * 1024, // 2MB
      );
    });

    tearDownAll(() async {
      if (await sample2MbFile.exists()) {
        await sample2MbFile.delete();
      }
    });

    test('2MB image -> 200KB target: resultBytes must be <= targetBytes and not over-compressed', () async {
      const targetBytes = 200 * 1024; // 204,800 bytes
      final service = CompressionService(
        compressor: SimulatedImageCompressor(baseBytes: 2 * 1024 * 1024),
      );

      final result = await service.compressToTarget(
        CompressionRequest(
          inputPath: sample2MbFile.path,
          targetBytes: targetBytes,
        ),
      );

      // 1. MUST satisfy limit
      expect(result.resultBytes, lessThanOrEqualTo(targetBytes));

      // 2. MUST avoid extreme over-compression (should be within sweet spot >= 160KB)
      expect(result.resultBytes, greaterThanOrEqualTo((targetBytes * 0.75).round()));

      // 3. Output file exists
      expect(File(result.outputPath).existsSync(), isTrue);

      // Clean up temp output
      File(result.outputPath).deleteSync();
    });

    test('20KB image -> 200KB target: preserves original when requested and <= target', () async {
      final smallFile = await createTestImageFile(
        name: 'small_20kb.png',
        width: 200,
        height: 200,
        fileSizeBytes: 20 * 1024,
      );

      final service = CompressionService(
        compressor: SimulatedImageCompressor(baseBytes: 20 * 1024),
      );

      final result = await service.compressToTarget(
        CompressionRequest(
          inputPath: smallFile.path,
          targetBytes: 200 * 1024,
          preserveResolution: true,
        ),
      );

      expect(result.resultBytes, lessThanOrEqualTo(200 * 1024));
      expect(result.originalBytes, smallFile.lengthSync());

      if (await smallFile.exists()) await smallFile.delete();
      if (File(result.outputPath).existsSync()) {
        File(result.outputPath).deleteSync();
      }
    });

    test('12MB image -> 50KB target: downscales resolution gracefully and flags quality compromise', () async {
      const targetBytes = 50 * 1024; // 50KB
      final largeFile = await createTestImageFile(
        name: 'large_12mb.png',
        width: 1000,
        height: 1000,
        fileSizeBytes: 12 * 1024 * 1024,
      );

      final service = CompressionService(
        compressor: SimulatedImageCompressor(baseBytes: 12 * 1024 * 1024),
      );

      final result = await service.compressToTarget(
        CompressionRequest(
          inputPath: largeFile.path,
          targetBytes: targetBytes,
        ),
      );

      // Must downscale and attempt best fit
      expect(result.scale, lessThan(1.0));
      expect(result.resultBytes, lessThanOrEqualTo(targetBytes));

      if (await largeFile.exists()) await largeFile.delete();
      if (File(result.outputPath).existsSync()) {
        File(result.outputPath).deleteSync();
      }
    });
  });
}
