import 'package:dio/dio.dart';
import 'package:im_mottu_mobile/index.dart';

class CharacterViewModel extends GetxController {
  final ICharacterRepository _characterRepository;
  final IComicRepository _comicRepository;
  final IEventRepository _eventRepository;
  final ISeriesRepository _seriesRepository;
  final IStoryRepository _storyRepository;

  final RxList<Character> characters = <Character>[].obs;
  final RxList<Character> relatedCharacters = <Character>[].obs;
  final RxBool isLoadingList = false.obs;
  final RxBool isLoadingRelated = false.obs;
  final RxBool isEndOfList = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt offset = 0.obs;
  final int limit = 20;

  CharacterViewModel(
    this._characterRepository,
    this._comicRepository,
    this._eventRepository,
    this._seriesRepository,
    this._storyRepository,
  );

  @override
  void onInit() {
    super.onInit();
    fetchCharacters();
  }

  void onSearchChanged(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    offset.value = 0;
    characters.clear();
    isEndOfList.value = false;
    fetchCharacters();
  }

  void fetchCharacters() {
    if (isLoadingList.value || isEndOfList.value) return;

    isLoadingList.value = true;
    _characterRepository
        .fetchCharacters(
      nameStartsWith: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      limit: limit,
      offset: offset.value,
    )
        .then((data) {
      if (data.data.results.isNotEmpty) {
        characters.addAll(data.data.results);
        offset.value += limit;
      } else {
        isEndOfList.value = true;
        Get.snackbar(
          'Info',
          'No more characters to load',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      isLoadingList.value = false;
    }).catchError((error) {
      isLoadingList.value = false;
      Get.snackbar(
        'Error',
        'Error fetching characters: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> fetchCharacterById(int characterId) async {
    if (isLoadingRelated.value) return;

    isLoadingRelated.value = true;
    try {
      final data = await _characterRepository.fetchCharacterById(characterId);
      characters.clear();
      characters.addAll(data.data.results);
      await fetchRelatedCharacters(characterId);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching character: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingRelated.value = false;
    }
  }

  Future<void> fetchRelatedCharacters(int characterId) async {
    try {
      isLoadingRelated.value = true;

      // Clear previous related characters to start fresh
      relatedCharacters.clear();

      // Fetch characters from various sources and update the list incrementally
      await _fetchAndUpdateRelatedCharacters(
        () async => (await _comicRepository.fetchComicsByCharacter(characterId))
            .data
            .results,
        _fetchCharactersInComic,
        characterId,
      );

      await _fetchAndUpdateRelatedCharacters(
        () async =>
            (await _seriesRepository.fetchSeriesByCharacter(characterId))
                .data
                .results,
        _fetchCharactersInSeries,
        characterId,
      );

      await _fetchAndUpdateRelatedCharacters(
        () async => (await _eventRepository.fetchEventsByCharacter(characterId))
            .data
            .results,
        _fetchCharactersInEvent,
        characterId,
      );

      await _fetchAndUpdateRelatedCharacters(
        () async =>
            (await _storyRepository.fetchStoriesByCharacter(characterId))
                .data
                .results,
        _fetchCharactersInStory,
        characterId,
      );

      // Sort the related characters alphabetically
      _sortRelatedCharactersAlphabetically();
    } catch (error) {
      print('Error in fetchRelatedCharacters: $error'); // Log the error
      Get.snackbar(
        'Error',
        'Error fetching related characters: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingRelated.value = false;
    }
  }

  Future<void> _fetchAndUpdateRelatedCharacters(
    Future<List<dynamic>> Function() fetchFunction,
    Future<List<Character>> Function(int) processFunction,
    int currentCharacterId,
  ) async {
    try {
      final items = await fetchFunction();
      for (var item in items) {
        final charactersFromItem = await processFunction(item.id);

        for (var character in charactersFromItem) {
          // Skip if it's the current character
          if (character.id == currentCharacterId) continue;

          // If character is not already in the list, add it
          if (!relatedCharacters.any((c) => c.id == character.id)) {
            relatedCharacters.add(character);
          }
        }
      }

      // Sort related characters alphabetically after each fetch
      _sortRelatedCharactersAlphabetically();
    } catch (error) {
      print(
          'Error in _fetchAndUpdateRelatedCharacters: $error'); // Log the error
      Get.snackbar(
        'Error',
        'Error fetching related characters from endpoint: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _sortRelatedCharactersAlphabetically() {
    relatedCharacters.sort((a, b) => a.name.compareTo(b.name));
  }

  Future<List<Character>> _fetchCharactersInComic(int comicId) async {
    return await _fetchWithRetry(
      () async => (await _characterRepository.fetchCharactersInComic(comicId))
          .data
          .results,
      3,
    );
  }

  Future<List<Character>> _fetchCharactersInSeries(int seriesId) async {
    return await _fetchWithRetry(
      () async => (await _characterRepository.fetchCharactersInSeries(seriesId))
          .data
          .results,
      3,
    );
  }

  Future<List<Character>> _fetchCharactersInEvent(int eventId) async {
    return await _fetchWithRetry(
      () async => (await _characterRepository.fetchCharactersInEvent(eventId))
          .data
          .results,
      3,
    );
  }

  Future<List<Character>> _fetchCharactersInStory(int storyId) async {
    return await _fetchWithRetry(
      () async => (await _characterRepository.fetchCharactersInStory(storyId))
          .data
          .results,
      3,
    );
  }

  Future<List<T>> _fetchWithRetry<T>(
      Future<List<T>> Function() fetchFunction, int retries) async {
    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        return await fetchFunction();
      } catch (error) {
        if (error is DioException && error.response?.statusCode == 429) {
          final retryAfter = error.response?.headers.value('retry-after');
          final waitTime = retryAfter != null
              ? Duration(
                  seconds: int.tryParse(retryAfter) ?? (2 << attempt).toInt())
              : Duration(seconds: (2 << attempt).toInt());
          await Future.delayed(waitTime);
        } else {
          rethrow;
        }
      }
    }
    throw Exception('Failed to fetch data after multiple retries');
  }
}
