import 'package:im_mottu_mobile/index.dart';

abstract class ISeriesRepository {
  Future<SeriesDataWrapper> fetchSeries({
    String? title,
    String? titleStartsWith,
    String? comics,
    String? events,
    String? creators,
    String? stories,
    String? orderBy,
    int? limit,
    int? offset,
  });

  Future<SeriesDataWrapper> fetchSeriesById(int seriesId);

  Future<SeriesDataWrapper> fetchSeriesByComic(int comicId);

  Future<SeriesDataWrapper> fetchSeriesByEvent(int eventId);

  Future<SeriesDataWrapper> fetchSeriesByCreator(int creatorId);

  Future<SeriesDataWrapper> fetchSeriesByStory(int storyId);
}
