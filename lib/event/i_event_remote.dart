import 'package:im_mottu_mobile/index.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'i_event_remote.g.dart';

@RestApi(baseUrl: 'https://gateway.marvel.com/v1/public/')
abstract class IEventRemote {
  factory IEventRemote(Dio dio, {String baseUrl}) = _IEventRemote;

  @GET('/events')
  Future<EventDataWrapper> fetchEvents({
    @Query('name') String? name,
    @Query('nameStartsWith') String? nameStartsWith,
    @Query('comics') String? comics,
    @Query('series') String? series,
    @Query('creators') String? creators,
    @Query('stories') String? stories,
    @Query('orderBy') String? orderBy,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/events/{eventId}')
  Future<EventDataWrapper> fetchEventById({
    @Path('eventId') required int eventId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/comics/{comicId}/events')
  Future<EventDataWrapper> fetchEventsByComic({
    @Path('comicId') required int comicId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/creators/{creatorId}/events')
  Future<EventDataWrapper> fetchEventsByCreator({
    @Path('creatorId') required int creatorId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/series/{seriesId}/events')
  Future<EventDataWrapper> fetchEventsBySeries({
    @Path('seriesId') required int seriesId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/stories/{storyId}/events')
  Future<EventDataWrapper> fetchEventsByStory({
    @Path('storyId') required int storyId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/characters/{characterId}/events')
  Future<EventDataWrapper> fetchEventsByCharacter({
    @Path('characterId') required int characterId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });
}
