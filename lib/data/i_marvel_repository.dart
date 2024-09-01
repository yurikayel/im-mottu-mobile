import "package:im_mottu_mobile/index.dart";

abstract class IMarvelRepository {
  String generateHash(String timestamp);

  // Characters
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

  // Comics
  Future<ComicDataWrapper> fetchComics({
    String? title,
    String? titleStartsWith,
    DateTime? modifiedSince,
    List<int>? format,
    List<int>? formatType,
    bool? noVariants,
    List<int>? dateDescriptor,
    DateTime? dateRangeStart,
    DateTime? dateRangeEnd,
    bool? hasDigitalIssue,
    List<int>? characters,
    List<int>? series,
    List<int>? events,
    List<int>? creators,
    List<int>? stories,
    String? orderBy,
    int? limit,
    int? offset,
  });

  // Creators
  Future<CreatorDataWrapper> fetchCreators({
    String? firstName,
    String? middleName,
    String? lastName,
    String? suffix,
    DateTime? modifiedSince,
    List<int>? comics,
    List<int>? series,
    List<int>? events,
    List<int>? stories,
    String? orderBy,
    int? limit,
    int? offset,
    String? nameStartsWith,
  });

  // Events
  Future<EventDataWrapper> fetchEvents({
    String? name,
    String? nameStartsWith,
    DateTime? modifiedSince,
    List<int>? creators,
    List<int>? characters,
    List<int>? comics,
    List<int>? series,
    List<int>? stories,
    String? orderBy,
    int? limit,
    int? offset,
  });

  // Series
  Future<SeriesDataWrapper> fetchSeries({
    String? title,
    String? titleStartsWith,
    DateTime? modifiedSince,
    List<int>? comics,
    List<int>? stories,
    List<int>? events,
    List<int>? creators,
    List<int>? characters,
    String? seriesType,
    String? contains,
    String? orderBy,
    int? limit,
    int? offset,
  });

  // Stories
  Future<StoryDataWrapper> fetchStories({
    DateTime? modifiedSince,
    List<int>? comics,
    List<int>? series,
    List<int>? events,
    List<int>? creators,
    List<int>? characters,
    String? orderBy,
    int? limit,
    int? offset,
    String? titleStartsWith,
  });
}
