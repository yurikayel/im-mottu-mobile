import 'package:im_mottu_mobile/index.dart';

abstract class IStoryRepository {
  Future<StoryDataWrapper> fetchStories({
    String? title,
    String? titleStartsWith,
    String? comics,
    String? series,
    String? creators,
    String? events,
    String? characters,
    String? orderBy,
    int? limit,
    int? offset,
  });

  Future<StoryDataWrapper> fetchStoryById(int storyId);

  Future<StoryDataWrapper> fetchStoriesByComic(int comicId);

  Future<StoryDataWrapper> fetchStoriesBySeries(int seriesId);

  Future<StoryDataWrapper> fetchStoriesByCreator(int creatorId);

  Future<StoryDataWrapper> fetchStoriesByEvent(int eventId);

  Future<StoryDataWrapper> fetchStoriesByCharacter(int characterId);
}
