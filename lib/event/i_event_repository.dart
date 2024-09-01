import 'package:im_mottu_mobile/index.dart';

abstract class IEventRepository {
  Future<EventDataWrapper> fetchEvents({
    String? name,
    String? nameStartsWith,
    String? comics,
    String? series,
    String? creators,
    String? stories,
    String? orderBy,
    int? limit,
    int? offset,
  });

  Future<EventDataWrapper> fetchEventById(int eventId);

  Future<EventDataWrapper> fetchEventsByComic(int comicId);

  Future<EventDataWrapper> fetchEventsByCreator(int creatorId);

  Future<EventDataWrapper> fetchEventsBySeries(int seriesId);

  Future<EventDataWrapper> fetchEventsByStory(int storyId);
}
