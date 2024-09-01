import 'package:im_mottu_mobile/index.dart';

/// An abstract class defining methods for fetching comic data from a repository.
abstract class IComicRepository {
  /// Fetches a list of comics with optional filters.
  ///
  /// [title] - Filter comics by title.
  /// [titleStartsWith] - Filter comics whose title starts with the specified string.
  /// [series] - Filter comics by series ID.
  /// [events] - Filter comics by event ID.
  /// [characters] - Filter comics by character ID.
  /// [orderBy] - Specify sorting order.
  /// [limit] - Maximum number of comics to fetch.
  /// [offset] - Offset for pagination.
  Future<ComicDataWrapper> fetchComics({
    String? title,
    String? titleStartsWith,
    String? series,
    String? events,
    String? characters,
    String? orderBy,
    int? limit,
    int? offset,
  });

  /// Fetches a single comic by its ID.
  ///
  /// [comicId] - The ID of the comic to fetch.
  Future<ComicDataWrapper> fetchComicById(int comicId);

  /// Fetches comics that feature a specific character.
  ///
  /// [characterId] - The ID of the character whose comics to fetch.
  Future<ComicDataWrapper> fetchComicsByCharacter(int characterId);

  /// Fetches comics related to a specific series.
  ///
  /// [seriesId] - The ID of the series whose comics to fetch.
  Future<ComicDataWrapper> fetchComicsBySeries(int seriesId);

  /// Fetches comics related to a specific event.
  ///
  /// [eventId] - The ID of the event whose comics to fetch.
  Future<ComicDataWrapper> fetchComicsByEvent(int eventId);
}
