import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:im_mottu_mobile/index.dart';

part 'i_comic_remote.g.dart';

@RestApi(baseUrl: 'https://gateway.marvel.com/v1/public/')
abstract class IComicRemote {
  factory IComicRemote(Dio dio, {String baseUrl}) = _IComicRemote;

  @GET('/comics')
  Future<ComicDataWrapper> fetchComics({
    @Query('title') String? title,
    @Query('titleStartsWith') String? titleStartsWith,
    @Query('series') String? series,
    @Query('events') String? events,
    @Query('characters') String? characters,
    @Query('orderBy') String? orderBy,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/comics/{comicId}')
  Future<ComicDataWrapper> fetchComicById({
    @Path('comicId') required int comicId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/characters/{characterId}/comics')
  Future<ComicDataWrapper> fetchComicsByCharacter({
    @Path('characterId') required int characterId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/series/{seriesId}/comics')
  Future<ComicDataWrapper> fetchComicsBySeries({
    @Path('seriesId') required int seriesId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/events/{eventId}/comics')
  Future<ComicDataWrapper> fetchComicsByEvent({
    @Path('eventId') required int eventId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });
}
