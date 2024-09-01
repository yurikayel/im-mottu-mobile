import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:im_mottu_mobile/index.dart';

part 'i_series_remote.g.dart';

@RestApi(baseUrl: "https://gateway.marvel.com:443/v1/public")
abstract class ISeriesRemote {
  factory ISeriesRemote(Dio dio, {String baseUrl}) = _ISeriesRemote;

  @GET("/series")
  Future<SeriesDataWrapper> fetchSeries({
    @Query("title") String? title,
    @Query("titleStartsWith") String? titleStartsWith,
    @Query("comics") String? comics,
    @Query("events") String? events,
    @Query("creators") String? creators,
    @Query("stories") String? stories,
    @Query("orderBy") String? orderBy,
    @Query("limit") int? limit,
    @Query("offset") int? offset,
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/series/{seriesId}")
  Future<SeriesDataWrapper> fetchSeriesById(
      @Path("seriesId") int seriesId, {
        @Query("ts") required String timestamp,
        @Query("apikey") required String apiKey,
        @Query("hash") required String hash,
      });

  @GET("/series")
  Future<SeriesDataWrapper> fetchSeriesByComic(
      @Query("comics") int comicId, {
        @Query("ts") required String timestamp,
        @Query("apikey") required String apiKey,
        @Query("hash") required String hash,
      });

  @GET("/series")
  Future<SeriesDataWrapper> fetchSeriesByEvent(
      @Query("events") int eventId, {
        @Query("ts") required String timestamp,
        @Query("apikey") required String apiKey,
        @Query("hash") required String hash,
      });

  @GET("/series")
  Future<SeriesDataWrapper> fetchSeriesByCreator(
      @Query("creators") int creatorId, {
        @Query("ts") required String timestamp,
        @Query("apikey") required String apiKey,
        @Query("hash") required String hash,
      });

  @GET("/series")
  Future<SeriesDataWrapper> fetchSeriesByStory(
      @Query("stories") int storyId, {
        @Query("ts") required String timestamp,
        @Query("apikey") required String apiKey,
        @Query("hash") required String hash,
      });
}
