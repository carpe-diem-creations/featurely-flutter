import 'dart:typed_data';
import 'dart:ui' as ui;

/// Image formats the server accepts, decided by magic bytes only.
enum ScreenshotFormat {
  /// `89 50 4E 47 0D 0A 1A 0A`
  png('image/png'),

  /// `FF D8 FF`
  jpeg('image/jpeg'),

  /// `RIFF` + `WEBP` at offset 8.
  webp('image/webp'),

  /// Anything else (HEIC, GIF, …) — must be re-encoded before upload.
  unknown('application/octet-stream');

  const ScreenshotFormat(this.contentType);

  /// The multipart content type for the format.
  final String contentType;
}

/// A screenshot ready for upload.
class PreparedScreenshot {
  /// Creates a prepared screenshot.
  const PreparedScreenshot({required this.bytes, required this.contentType});

  /// The (possibly re-encoded) image bytes.
  final Uint8List bytes;

  /// `image/png`, `image/jpeg`, or `image/webp`.
  final String contentType;
}

/// Detects the image format from magic bytes — never the filename, never a
/// client-supplied content type (matching the server's rule).
ScreenshotFormat detectScreenshotFormat(Uint8List bytes) {
  if (bytes.length >= 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47 &&
      bytes[4] == 0x0D &&
      bytes[5] == 0x0A &&
      bytes[6] == 0x1A &&
      bytes[7] == 0x0A) {
    return ScreenshotFormat.png;
  }
  if (bytes.length >= 3 &&
      bytes[0] == 0xFF &&
      bytes[1] == 0xD8 &&
      bytes[2] == 0xFF) {
    return ScreenshotFormat.jpeg;
  }
  if (bytes.length >= 12 &&
      bytes[0] == 0x52 && // R
      bytes[1] == 0x49 && // I
      bytes[2] == 0x46 && // F
      bytes[3] == 0x46 && // F
      bytes[8] == 0x57 && // W
      bytes[9] == 0x45 && // E
      bytes[10] == 0x42 && // B
      bytes[11] == 0x50) {
    return ScreenshotFormat.webp;
  }
  return ScreenshotFormat.unknown;
}

/// Prepares picked bytes for upload: PNG/JPEG/WebP pass through unchanged;
/// anything else (e.g. HEIC) is decoded and re-encoded to PNG via `dart:ui`
/// (the engine decodes and encodes off the UI thread). Returns null when
/// the bytes cannot be decoded at all.
Future<PreparedScreenshot?> prepareScreenshot(Uint8List bytes) async {
  if (bytes.isEmpty) return null;
  final format = detectScreenshotFormat(bytes);
  if (format != ScreenshotFormat.unknown) {
    return PreparedScreenshot(bytes: bytes, contentType: format.contentType);
  }
  try {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    codec.dispose();
    if (data == null) return null;
    return PreparedScreenshot(
      bytes: data.buffer.asUint8List(),
      contentType: ScreenshotFormat.png.contentType,
    );
  } catch (_) {
    return null;
  }
}
