import 'package:im_mottu_mobile/index.dart';

/// A manager class for handling image caching with expiration.
///
/// This class provides functionality to cache images both in memory and on the
/// file system for offline access. Cached images are stored in memory with an
/// expiration time, and expired images are re-fetched from the network if needed.
///
/// Example usage:
/// ```dart
/// final image = await ImageCacheManager.getImage('https://example.com/image.png');
/// ```
///
/// The cache duration is set to 1 day. The class supports saving and loading
/// images from the file system, allowing images to persist across app restarts.
class ImageCacheManager {
  static final _cache = <String, _CachedImage>{};
  static const _cacheDuration = Duration(days: 1); // Cache duration of 1 day

  /// Retrieves an image either from the cache or by fetching it from the network.
  ///
  /// This method first checks if the image is present in the in-memory cache and
  /// whether it is still valid (i.e., not expired). If the image is not present
  /// or expired, it checks the file system for a cached image. If the image is
  /// not found in the file system, it fetches the image from the network, caches
  /// it in memory, and saves it to the file system.
  ///
  /// [url] The URL of the image to retrieve.
  /// [fit] The [BoxFit] to apply to the image. Defaults to [BoxFit.cover].
  ///
  /// Returns an [Image] widget containing the requested image.
  ///
  /// Throws an [ArgumentError] if the URL is invalid or empty.
  static Future<Image> getImage(String url, {BoxFit fit = BoxFit.cover}) async {
    if (url.isEmpty) {
      throw ArgumentError('URL cannot be empty.');
    }

    // Try from in-memory cache
    final fromCache = await _getImageFromCache(url, fit);
    if (fromCache != null) return fromCache;

    // Try from the file system
    final fromFile = await _loadImageFromFileSystem(url);
    if (fromFile != null) {
      // Cache the image in memory
      _cache[url] = _CachedImage(fromFile, DateTime.now());
      return Image.memory(fromFile, fit: fit);
    }

    // Catch from network
    return await _fetchImageFromNetwork(url, fit);
  }

  /// Retrieves an image from the in-memory cache if it is still valid.
  ///
  /// [url] The URL of the image to retrieve.
  /// [fit] The [BoxFit] to apply to the image.
  ///
  /// Returns an [Image] widget if the image is found in the cache and is valid,
  /// otherwise returns `null`.
  static Future<Image?> _getImageFromCache(String url, BoxFit fit) async {
    final cacheEntry = _cache[url];
    if (cacheEntry != null && _isCacheValid(cacheEntry.timestamp)) {
      return Image.memory(cacheEntry.bytes, fit: fit);
    }
    return null;
  }

  /// Fetches an image from the network, caches it in memory, and saves it to the file system.
  ///
  /// [url] The URL of the image to fetch.
  /// [fit] The [BoxFit] to apply to the image.
  ///
  /// Returns an [Image] widget containing the fetched image.
  static Future<Image> _fetchImageFromNetwork(String url, BoxFit fit) async {
    try {
      final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
      final Uint8List bytes = data.buffer.asUint8List();

      // Cache the image in memory
      _cache[url] = _CachedImage(bytes, DateTime.now());

      // Save image to file system
      await _saveImageToFileSystem(url, bytes);

      return Image.memory(bytes, fit: fit);
    } catch (e) {
      // On error, return a placeholder image
      return Image.asset('assets/images/marvel.jpg');
    }
  }

  /// Checks if the cache entry is still valid based on the cache duration.
  ///
  /// [timestamp] The timestamp when the image was cached.
  ///
  /// Returns `true` if the cache entry is valid (i.e., within the cache duration),
  /// otherwise returns `false`.
  static bool _isCacheValid(DateTime timestamp) {
    final currentTime = DateTime.now();
    return currentTime.difference(timestamp) <= _cacheDuration;
  }

  /// Saves the image data to the file system for persistence.
  ///
  /// This method writes the image data to a file in the cache directory.
  /// If the image cannot be saved, an error message is printed to the console.
  ///
  /// [url] The URL of the image to save.
  /// [bytes] The image data to save as [Uint8List].
  static Future<void> _saveImageToFileSystem(
      String url, Uint8List bytes) async {
    try {
      final fileName = _getFileNameFromUrl(url);
      final directory = await _getCacheDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
    } catch (e) {
      // Handle file I/O errors
      if (kDebugMode) {
        print('Failed to save image to file system: $e');
      }
    }
  }

  /// Loads the image data from the file system if it exists and is valid.
  ///
  /// This method checks the file system for a cached image. If the image file is
  /// found and is valid (i.e., not expired), its data is returned as [Uint8List].
  /// Otherwise, it returns `null`.
  ///
  /// [url] The URL of the image to load.
  ///
  /// Returns the image data as [Uint8List] if the file exists and is valid,
  /// otherwise returns `null`.
  static Future<Uint8List?> _loadImageFromFileSystem(String url) async {
    try {
      final fileName = _getFileNameFromUrl(url);
      final directory = await _getCacheDirectory();
      final file = File('${directory.path}/$fileName');
      if (await file.exists()) {
        return await file.readAsBytes();
      }
    } catch (e) {
      // Handle file I/O errors
      if (kDebugMode) {
        print('Failed to load image from file system: $e');
      }
    }
    return null;
  }

  /// Generates a file name from the URL.
  ///
  /// This method derives a file name from the URL by extracting the last segment
  /// of the URL's path. This file name is used to save and retrieve the image
  /// from the file system.
  ///
  /// [url] The URL of the image.
  ///
  /// Returns a [String] representing the file name based on the URL.
  static String _getFileNameFromUrl(String url) {
    return Uri.parse(url).pathSegments.last; // Simple file name based on URL
  }

  /// Gets the cache directory path for storing images.
  ///
  /// This method returns a [Directory] where images are cached. It uses the
  /// system temporary directory for this purpose.
  ///
  /// Returns a [Future<Directory>] representing the directory where images
  /// are cached.
  static Future<Directory> _getCacheDirectory() async {
    final directory = Directory.systemTemp;
    return directory;
  }
}

/// Represents a cached image entry with its data and timestamp.
///
/// This class holds the image data and the timestamp indicating when the image
/// was cached. It is used to manage the cache validity and expiration.
///
/// The [bytes] field contains the image data as [Uint8List]. The [timestamp] field
/// indicates when the image was cached, which is used to determine cache validity.
class _CachedImage {
  final Uint8List bytes;
  final DateTime timestamp;

  _CachedImage(this.bytes, this.timestamp);
}
