import 'package:im_mottu_mobile/index.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import "package:dio/dio.dart";

part 'i_marvel_remote.g.dart';

@RestApi(baseUrl: 'https://gateway.marvel.com/v1/public/')
abstract class IMarvelRemote {
  factory IMarvelRemote(Dio dio, {String baseUrl}) = _MarvelRemote;

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

  @GET('/comics')
  Future<ComicDataWrapper> fetchComics({
    @Query('title') String? title,
    @Query('titleStartsWith') String? titleStartsWith,
    @Query('modifiedSince') String? modifiedSince,
    @Query('format') String? format,
    @Query('formatType') String? formatType,
    @Query('noVariants') bool? noVariants,
    @Query('dateDescriptor') String? dateDescriptor,
    @Query('dateRangeStart') String? dateRangeStart,
    @Query('dateRangeEnd') String? dateRangeEnd,
    @Query('hasDigitalIssue') bool? hasDigitalIssue,
    @Query('characters') String? characters,
    @Query('series') String? series,
    @Query('events') String? events,
    @Query('creators') String? creators,
    @Query('stories') String? stories,
    @Query('orderBy') String? orderBy,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/creators')
  Future<CreatorDataWrapper> fetchCreators({
    @Query('firstName') String? firstName,
    @Query('middleName') String? middleName,
    @Query('lastName') String? lastName,
    @Query('suffix') String? suffix,
    @Query('modifiedSince') String? modifiedSince,
    @Query('comics') String? comics,
    @Query('series') String? series,
    @Query('events') String? events,
    @Query('stories') String? stories,
    @Query('orderBy') String? orderBy,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('nameStartsWith') String? nameStartsWith, // Add this line
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/events')
  Future<EventDataWrapper> fetchEvents({
    @Query('name') String? name,
    @Query('nameStartsWith') String? nameStartsWith,
    @Query('modifiedSince') String? modifiedSince,
    @Query('creators') String? creators,
    @Query('characters') String? characters,
    @Query('comics') String? comics,
    @Query('series') String? series,
    @Query('stories') String? stories,
    @Query('orderBy') String? orderBy,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/series')
  Future<SeriesDataWrapper> fetchSeries({
    @Query('title') String? title,
    @Query('titleStartsWith') String? titleStartsWith,
    @Query('modifiedSince') String? modifiedSince,
    @Query('comics') String? comics,
    @Query('stories') String? stories,
    @Query('events') String? events,
    @Query('creators') String? creators,
    @Query('characters') String? characters,
    @Query('seriesType') String? seriesType,
    @Query('contains') String? contains,
    @Query('orderBy') String? orderBy,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });

  @GET('/stories')
  Future<StoryDataWrapper> fetchStories({
    @Query('modifiedSince') String? modifiedSince,
    @Query('comics') String? comics,
    @Query('series') String? series,
    @Query('events') String? events,
    @Query('creators') String? creators,
    @Query('characters') String? characters,
    @Query('orderBy') String? orderBy,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('titleStartsWith') String? titleStartsWith,
    @Query('ts') required String timestamp,
    @Query('apikey') required String apiKey,
    @Query('hash') required String hash,
  });
}
