import 'package:im_mottu_mobile/index.dart';

abstract class ICreatorRepository {
  Future<CreatorDataWrapper> fetchCreators({
    String? name,
    String? nameStartsWith,
    String? comics,
    String? series,
    String? events,
    String? orderBy,
    int? limit,
    int? offset,
  });

  Future<CreatorDataWrapper> fetchCreatorById(int creatorId);

  Future<CreatorDataWrapper> fetchCreatorsByComic(int comicId);

  Future<CreatorDataWrapper> fetchCreatorsBySeries(int seriesId);

  Future<CreatorDataWrapper> fetchCreatorsByEvent(int eventId);

  Future<CreatorDataWrapper> fetchCreatorsByCharacter(int characterId);
}
