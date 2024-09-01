import 'package:im_mottu_mobile/index.dart';

/// An interface for the repository that interacts with character-related endpoints of the Marvel API.
///
/// This interface defines methods for fetching characters and character-related data
/// with various filtering options.
abstract class ICharacterRepository {
  /// Generates an MD5 hash for Marvel API authentication.
  ///
  /// The [timestamp] is used in the hash generation process along with the public
  /// and private API keys.
  String generateHash(String timestamp);

  /// Fetches characters from the Marvel API with optional filtering parameters.
  ///
  /// [name] and [nameStartsWith] are used for filtering characters by name.
  /// [modifiedSince] filters characters modified since the given date.
  /// [comics], [series], [events], and [stories] are used to filter characters related
  /// to the provided IDs.
  /// [orderBy] specifies the field to order the results by.
  /// [limit] and [offset] control pagination.
  Future<CharacterDataWrapper> fetchCharacters({
    String? name,
    String? nameStartsWith,
    DateTime? modifiedSince,
    List<int>? comics,
    List<int>? series,
    List<int>? events,
    List<int>? stories,
    String? orderBy,
    int? limit,
    int? offset,
  });

  /// Fetches a specific character by its ID.
  ///
  /// [characterId] is the unique identifier of the character to fetch.
  Future<CharacterDataWrapper> fetchCharacterById(int characterId);

  /// Fetches a list of characters appearing in a specific comic.
  ///
  /// [comicId] is the unique identifier of the comic to fetch characters from.
  Future<CharacterDataWrapper> fetchCharactersInComic(int comicId);

  /// Fetches a list of characters appearing in a specific series.
  ///
  /// [seriesId] is the unique identifier of the series to fetch characters from.
  Future<CharacterDataWrapper> fetchCharactersInSeries(int seriesId);

  /// Fetches a list of characters appearing in a specific event.
  ///
  /// [eventId] is the unique identifier of the event to fetch characters from.
  Future<CharacterDataWrapper> fetchCharactersInEvent(int eventId);

  /// Fetches a list of characters appearing in a specific story.
  ///
  /// [storyId] is the unique identifier of the story to fetch characters from.
  Future<CharacterDataWrapper> fetchCharactersInStory(int storyId);
}
