import 'package:im_mottu_mobile/index.dart';

/// A widget that handles image caching, retrieval, and displaying.
///
/// The `MarvelImage` widget fetches an image from a given URL using the
/// `ImageCacheManager`. It displays a placeholder widget while the image is
/// being loaded and an error widget if there is an error loading the image.
///
/// This widget is useful for efficiently managing image loading and caching
/// without requiring additional image loading libraries.
///
/// Example usage:
/// ```dart
/// MarvelImage(
///   url: 'https://example.com/image.png',
///   placeholder: const Center(child: CircularProgressIndicator()),
///   errorWidget: const Center(child: Icon(Icons.error)),
/// )
/// ```
///
/// If no `placeholder` or `errorWidget` is provided, default widgets will be
/// used. The default placeholder is a [CircularProgressIndicator], and the
/// default error widget is an [Icon] with an error icon.
///
/// * [fit] determines how the image should be resized to fit its container.
///   If not provided, the default value is [BoxFit.cover].
class MarvelImage extends StatelessWidget {
  /// Creates a `MarvelImage` widget.
  ///
  /// * [url]: The URL of the image to be fetched. This is a required parameter.
  /// * [placeholder]: A widget displayed while the image is being loaded.
  ///   Defaults to a [CircularProgressIndicator] if not provided.
  /// * [errorWidget]: A widget displayed if there is an error loading the image.
  ///   Defaults to an [Icon] widget with an error icon if not provided.
  /// * [fit]: The [BoxFit] property that defines how the image should be resized
  ///   to fit its container. If not provided, defaults to [BoxFit.cover].
  ///
  /// Example usage:
  /// ```dart
  /// MarvelImage(
  ///   url: 'https://example.com/image.png',
  ///   placeholder: const Center(child: CircularProgressIndicator()),
  ///   errorWidget: const Center(child: Icon(Icons.error)),
  ///   fit: BoxFit.cover,
  /// )
  /// ```
  const MarvelImage(
    this.url, {
    super.key,
    this.placeholder,
    this.errorWidget,
    this.fit,
  });

  /// The URL of the image to be fetched.
  ///
  /// This is a required parameter. The URL should be a valid link to an image
  /// resource on the web.
  final String url;

  /// A widget displayed while the image is being loaded.
  ///
  /// This parameter is optional. If not provided, a default [CircularProgressIndicator]
  /// is shown during the image loading phase.
  final Widget? placeholder;

  /// A widget displayed if there is an error loading the image.
  ///
  /// This parameter is optional. If not provided, a default [Icon] widget with an error
  /// icon is shown in case of an error.
  final Widget? errorWidget;

  /// The [BoxFit] property that defines how the image should be resized to fit its container.
  ///
  /// This parameter is optional. If not provided, the image will default to [BoxFit.cover].
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image>(
      future: ImageCacheManager.getImage(url, fit: fit ?? BoxFit.cover),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _placeHolder();
        } else if (snapshot.hasError) {
          return _error();
        } else if (snapshot.hasData) {
          return _image(snapshot.data!);
        } else {
          return _error();
        }
      },
    );
  }

  /// Returns a widget displayed while the image is being loaded.
  ///
  /// Defaults to a [CircularProgressIndicator] if [placeholder] is not provided.
  Widget _placeHolder() =>
      placeholder ?? const Center(child: CircularProgressIndicator());

  /// Returns a widget displayed if there is an error loading the image.
  ///
  /// Defaults to an [Icon] widget with an error icon if [errorWidget] is not provided.
  Widget _error() => errorWidget ?? const Center(child: Icon(Icons.error));

  /// Returns the widget for displaying the image.
  ///
  /// Wraps the image in a [SizedBox] to ensure it takes up the full width of its container.
  Widget _image(Image image) => SizedBox.expand(child: image);
}
