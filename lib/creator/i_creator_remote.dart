import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:im_mottu_mobile/index.dart';

part 'i_creator_remote.g.dart';

@RestApi(baseUrl: 'https://gateway.marvel.com/v1/public/')
abstract class ICreatorRemote {
  factory ICreatorRemote(Dio dio, {String baseUrl}) = _ICreatorRemote;

  @GET('/creators')
  Future<CreatorDataWrapper> fetchCreators({
    @Query('name') String? name,
    @Query('nameStartsWith') String? nameStartsWith,
    @Query('comics') String? comics,
    @Query('series') String? series,
    @Query('events') String? events,
    @Query('orderBy') String? orderBy,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/creators/{creatorId}')
  Future<CreatorDataWrapper> fetchCreatorById({
    @Path('creatorId') required int creatorId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/comics/{comicId}/creators')
  Future<CreatorDataWrapper> fetchCreatorsInComic({
    @Path('comicId') required int comicId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/series/{seriesId}/creators')
  Future<CreatorDataWrapper> fetchCreatorsInSeries({
    @Path('seriesId') required int seriesId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/events/{eventId}/creators')
  Future<CreatorDataWrapper> fetchCreatorsInEvent({
    @Path('eventId') required int eventId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });
}
