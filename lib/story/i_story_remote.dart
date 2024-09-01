import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:im_mottu_mobile/index.dart';

part 'i_story_remote.g.dart';

@RestApi(baseUrl: "https://gateway.marvel.com:443/v1/public")
abstract class IStoryRemote {
  factory IStoryRemote(Dio dio, {String baseUrl}) = _IStoryRemote;

  @GET("/stories")
  Future<StoryDataWrapper> fetchStories({
    @Query("title") String? title,
    @Query("titleStartsWith") String? titleStartsWith,
    @Query("comics") String? comics,
    @Query("series") String? series,
    @Query("creators") String? creators,
    @Query("events") String? events,
    @Query("characters") String? characters,
    @Query("orderBy") String? orderBy,
    @Query("limit") int? limit,
    @Query("offset") int? offset,
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/stories/{storyId}")
  Future<StoryDataWrapper> fetchStoryById(
    @Path("storyId") int storyId, {
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/stories")
  Future<StoryDataWrapper> fetchStoriesByComic(
    @Query("comics") int comicId, {
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/stories")
  Future<StoryDataWrapper> fetchStoriesBySeries(
    @Query("series") int seriesId, {
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/stories")
  Future<StoryDataWrapper> fetchStoriesByCreator(
    @Query("creators") int creatorId, {
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/stories")
  Future<StoryDataWrapper> fetchStoriesByEvent(
    @Query("events") int eventId, {
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });

  @GET("/stories")
  Future<StoryDataWrapper> fetchStoriesByCharacter(
    @Query("characters") int characterId, {
    @Query("ts") required String timestamp,
    @Query("apikey") required String apiKey,
    @Query("hash") required String hash,
  });
}
