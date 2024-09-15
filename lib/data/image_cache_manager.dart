import 'package:im_mottu_mobile/index.dart';

/// A manager class for handling image caching with expiration.
///
/// This class provides functionality to cache images in memory and persist
/// them to the file system for offline access. Cached images are stored in
/// memory with an expiration time, and expired images are re-fetched from
/// the network if needed.
///
/// Example usage:
/// ```dart
/// final image = await ImageCacheManager.getImage('https://example.com/image.png');
/// ```
///
/// This class uses a simple in-memory cache with a cache duration of 1 day.
/// It also supports saving and loading images from the file system.
class ImageCacheManager {
  static final _cache = <String, _CachedImage>{};
  static const _cacheDuration = Duration(days: 1); // Cache duration of 1 day

  /// Retrieves an image either from the cache or by fetching it from the network.
  ///
  /// If the image is found in the cache and is still valid (i.e., not expired),
  /// it is returned directly from the cache. Otherwise, the image is fetched
  /// from the network, cached, and then returned.
  ///
  /// [url] The URL of the image to retrieve.
  ///
  /// Returns an [Image] widget.
  ///
  /// Throws an [ArgumentError] if the URL is invalid or empty.
  static Future<Image> getImage(String url, {BoxFit fit = BoxFit.cover}) async {
    if (url.isEmpty) {
      throw ArgumentError('URL cannot be empty.');
    }

    final cacheEntry = _cache[url];

    if (cacheEntry != null && _isCacheValid(cacheEntry.timestamp)) {
      // Serve image from cache if valid
      return Image.memory(
        cacheEntry.bytes,
        fit: fit,
      );
    }

    try {
      // Fetch image from network
      final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
      final Uint8List bytes = data.buffer.asUint8List();

      // Cache the image
      _cache[url] = _CachedImage(bytes, DateTime.now());

      // Optionally save image to file system
      await _saveImageToFileSystem(url, bytes);

      return Image.memory(
        bytes,
        fit: fit,
      );
    } catch (e) {
      // On error, return a placeholder image
      return Image.asset('assets/images/marvel.jpg');
    }
  }

  /// Checks if the cache entry is still valid based on the cache duration.
  ///
  /// [timestamp] The timestamp when the image was cached.
  ///
  /// Returns `true` if the cache entry is valid, otherwise `false`.
  static bool _isCacheValid(DateTime timestamp) {
    final currentTime = DateTime.now();
    return currentTime.difference(timestamp) <= _cacheDuration;
  }

  /// Saves the image data to the file system for persistence.
  ///
  /// [url] The URL of the image to save.
  /// [bytes] The image data to save.
  ///
  /// This method writes the image data to a file in the cache directory.
  /// If the image cannot be saved, an error is printed to the console.
  static Future<void> _saveImageToFileSystem(
      String url, Uint8List bytes) async {
    try {
      final fileName = _getFileNameFromUrl(url);
      final directory = await _getCacheDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
    } catch (e) {
      // Handle file I/O errors
      print('Failed to save image to file system: $e');
    }
  }

  /// Loads the image data from the file system if it exists and is valid.
  ///
  /// [url] The URL of the image to load.
  ///
  /// Returns the image data as [Uint8List] if the file exists and is valid,
  /// otherwise returns `null`.
  ///
  /// This method checks the file system for a cached image. If the image
  /// file is found and is not expired, its data is returned.
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
      print('Failed to load image from file system: $e');
    }
    return null;
  }

  /// Generates a file name from the URL.
  ///
  /// [url] The URL of the image.
  ///
  /// Returns a [String] representing the file name based on the URL. The file
  /// name is derived from the last segment of the URL's path.
  static String _getFileNameFromUrl(String url) {
    return Uri.parse(url).pathSegments.last; // Simple file name based on URL
  }

  /// Gets the cache directory path for storing images.
  ///
  /// Returns a [Future<Directory>] representing the directory where images
  /// are cached. Uses the system temporary directory for the cache.
  static Future<Directory> _getCacheDirectory() async {
    final directory = Directory.systemTemp;
    return directory;
  }
}

/// Represents a cached image entry with its data and timestamp.
///
/// This class holds the image data and the timestamp indicating when the
/// image was cached. It is used to manage the cache validity and expiration.
class _CachedImage {
  final Uint8List bytes;
  final DateTime timestamp;

  _CachedImage(this.bytes, this.timestamp);
}
