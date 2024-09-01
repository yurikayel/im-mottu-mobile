import 'package:im_mottu_mobile/index.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'i_character_remote.g.dart';

@RestApi(baseUrl: 'https://gateway.marvel.com/v1/public/')
abstract class ICharacterRemote {
  factory ICharacterRemote(Dio dio, {String baseUrl}) = _ICharacterRemote;

  @GET('/characters')
  Future<CharacterDataWrapper> fetchCharacters({
    @Query('name') String? name,
    @Query('nameStartsWith') String? nameStartsWith,
    @Query('modifiedSince') String? modifiedSince,
    @Query('comics') String? comics,
    @Query('series') String? series,
    @Query('events') String? events,
    @Query('stories') String? stories,
    @Query('orderBy') String? orderBy,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/characters/{characterId}')
  Future<CharacterDataWrapper> fetchCharacterById({
    @Path('characterId') required int characterId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/comics/{comicId}/characters')
  Future<CharacterDataWrapper> fetchCharactersInComic({
    @Path('comicId') required int comicId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/series/{seriesId}/characters')
  Future<CharacterDataWrapper> fetchCharactersInSeries({
    @Path('seriesId') required int seriesId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/events/{eventId}/characters')
  Future<CharacterDataWrapper> fetchCharactersInEvent({
    @Path('eventId') required int eventId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/stories/{storyId}/characters')
  Future<CharacterDataWrapper> fetchCharactersInStory({
    @Path('storyId') required int storyId,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });
}
