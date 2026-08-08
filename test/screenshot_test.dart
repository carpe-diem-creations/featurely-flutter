import 'dart:typed_data';

import 'package:featurely/src/image/screenshot.dart';
import 'package:flutter_test/flutter_test.dart';

/// A valid, decodable 1×1 transparent PNG.
final Uint8List tinyPng = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x62, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

/// A valid, decodable 1×1 GIF (wrong format for upload → re-encode path).
final Uint8List tinyGif = Uint8List.fromList([
  0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00,
  0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x21, 0xF9, 0x04, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00,
  0x00, 0x02, 0x02, 0x44, 0x01, 0x00, 0x3B,
]);

Uint8List bytesOf(List<int> header) => Uint8List.fromList(header);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('magic-byte detection', () {
    test('PNG signature accepted', () {
      expect(detectScreenshotFormat(tinyPng), ScreenshotFormat.png);
    });

    test('JPEG signature accepted', () {
      expect(
        detectScreenshotFormat(bytesOf([0xFF, 0xD8, 0xFF, 0xE0, 0, 0])),
        ScreenshotFormat.jpeg,
      );
    });

    test('WebP signature accepted (RIFF + WEBP at offset 8)', () {
      expect(
        detectScreenshotFormat(bytesOf([
          0x52, 0x49, 0x46, 0x46, 0x10, 0x00, 0x00, 0x00, //
          0x57, 0x45, 0x42, 0x50, 0x56, 0x50, 0x38, 0x20,
        ])),
        ScreenshotFormat.webp,
      );
    });

    test('RIFF without WEBP marker rejected', () {
      expect(
        detectScreenshotFormat(bytesOf([
          0x52, 0x49, 0x46, 0x46, 0x10, 0x00, 0x00, 0x00, //
          0x41, 0x56, 0x49, 0x20, 0x00, 0x00, 0x00, 0x00,
        ])),
        ScreenshotFormat.unknown,
      );
    });

    test('HEIC rejected by magic bytes', () {
      // ftypheic brand box.
      expect(
        detectScreenshotFormat(bytesOf([
          0x00, 0x00, 0x00, 0x18, 0x66, 0x74, 0x79, 0x70, //
          0x68, 0x65, 0x69, 0x63, 0x00, 0x00, 0x00, 0x00,
        ])),
        ScreenshotFormat.unknown,
      );
    });

    test('GIF rejected by magic bytes', () {
      expect(detectScreenshotFormat(tinyGif), ScreenshotFormat.unknown);
    });

    test('zero-byte rejected', () {
      expect(detectScreenshotFormat(Uint8List(0)), ScreenshotFormat.unknown);
    });
  });

  group('prepareScreenshot', () {
    test('accepted formats pass through unchanged', () async {
      final prepared = await prepareScreenshot(tinyPng);
      expect(prepared, isNotNull);
      expect(prepared!.contentType, 'image/png');
      expect(prepared.bytes, tinyPng);
    });

    test('unknown-but-decodable input invokes the re-encode path to PNG',
        () async {
      final prepared = await prepareScreenshot(tinyGif);
      expect(prepared, isNotNull);
      expect(prepared!.contentType, 'image/png');
      // The output is a real PNG by magic bytes.
      expect(detectScreenshotFormat(prepared.bytes), ScreenshotFormat.png);
    });

    test('undecodable input is rejected with null', () async {
      expect(await prepareScreenshot(Uint8List(0)), isNull);
      expect(
        await prepareScreenshot(bytesOf(List.filled(64, 0xAB))),
        isNull,
      );
    });
  });
}
