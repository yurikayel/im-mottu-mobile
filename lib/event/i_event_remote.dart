import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:im_mottu_mobile/index.dart';

part 'i_event_remote.g.dart';

@RestApi(baseUrl: "https://gateway.marvel.com:443/v1/public")
abstract class IEventRemote {
  factory IEventRemote(Dio dio, {String baseUrl}) = _IEventRemote;

  @GET("/events")
  Future<EventDataWrapper> fetchEvents({
    @Query("name") String? name,
    @Query("nameStartsWith") String? nameStartsWith,
    @Query("comics") String? comics,
    @Query("series") String? series,
    @Query("creators") String? creators,
    @Query("stories") String? stories,
    @Query("orderBy") String? orderBy,
    @Query("limit") int? limit,
    @Query("offset") int? offset,
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/events/{eventId}")
  Future<EventDataWrapper> fetchEventById(
    @Path("eventId") int eventId, {
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/events")
  Future<EventDataWrapper> fetchEventsByComic(
    @Query("comics") int comicId, {
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/events")
  Future<EventDataWrapper> fetchEventsByCreator(
    @Query("creators") int creatorId, {
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/events")
  Future<EventDataWrapper> fetchEventsBySeries(
    @Query("series") int seriesId, {
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/events")
  Future<EventDataWrapper> fetchEventsByStory(
    @Query("stories") int storyId, {
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });
}
