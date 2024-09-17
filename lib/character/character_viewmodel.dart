import 'package:dio/dio.dart';
import 'package:im_mottu_mobile/index.dart';

/// A ViewModel for managing character-related data and operations.
///
/// This ViewModel handles fetching characters, searching for characters,
/// and fetching related characters based on various criteria.
class CharacterViewModel extends GetxController {
  final ICharacterRepository _characterRepository;
  final IComicRepository _comicRepository;
  final IEventRepository _eventRepository;
  final ISeriesRepository _seriesRepository;
  final IStoryRepository _storyRepository;

  /// A list of characters matching the search query or current filter.
  final RxList<Character> characters = <Character>[].obs;

  /// A list of related characters fetched from various sources.
  final RxList<Character> relatedCharacters = <Character>[].obs;

  /// Indicates whether data is being loaded.
  final RxBool isLoading = false.obs;

  /// Indicates whether related characters are being loaded.
  final RxBool isLoadingRelated = false.obs;

  /// Indicates whether the end of the list has been reached.
  final RxBool isEndOfList = false.obs;

  /// The current search query for filtering characters.
  final RxString searchQuery = ''.obs;

  /// The current offset for pagination.
  final RxInt offset = 0.obs;

  /// The number of items to fetch per page.
  final int limit = 20;

  /// Creates an instance of [CharacterViewModel].
  ///
  /// [characterRepository] - The repository for character-related operations.
  /// [comicRepository] - The repository for comic-related operations.
  /// [eventRepository] - The repository for event-related operations.
  /// [seriesRepository] - The repository for series-related operations.
  /// [storyRepository] - The repository for story-related operations.
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

  /// Handles changes in the search query.
  ///
  /// [query] - The new search query.
  /// If the query is different from the current query, it resets the list and fetches new characters.
  void onSearchChanged(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    offset.value = 0;
    characters.clear();
    isEndOfList.value = false;
    fetchCharacters();
  }

  /// Fetches characters from the repository based on the current search query and pagination.
  ///
  /// Updates the [characters] list and [offset] based on the fetched data.
  /// Displays a snackbar message if no more characters are available or if an error occurs.
  void fetchCharacters() {
    if (isLoading.value || isEndOfList.value) return;

    isLoading.value = true;
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
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching characters: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  /// Fetches a character by its ID and related characters.
  ///
  /// [characterId] - The ID of the character to fetch.
  /// Clears the [characters] list, fetches the character data, and then fetches related characters.
  /// Displays a snackbar message if an error occurs.
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

  /// Fetches related characters based on various sources.
  ///
  /// [characterId] - The ID of the character for which related characters are to be fetched.
  /// Fetches characters from comics, series, events, and stories related to the given character,
  /// and updates the [relatedCharacters] list.
  /// Displays a snackbar message if an error occurs.
  Future<void> fetchRelatedCharacters(int characterId) async {
    if (isLoadingRelated.value) return;

    isLoadingRelated.value = true;
    try {
      relatedCharacters.clear();

      final fetchFunctions = [
        () async => (await _comicRepository.fetchComicsByCharacter(characterId)).data.results,
        () async => (await _seriesRepository.fetchSeriesByCharacter(characterId)).data.results,
        () async => (await _eventRepository.fetchEventsByCharacter(characterId)).data.results,
        () async => (await _storyRepository.fetchStoriesByCharacter(characterId)).data.results,
      ];

      for (var fetchFunction in fetchFunctions) {
        await _fetchAndUpdateRelatedCharacters(fetchFunction, characterId);
      }

      _sortRelatedCharactersAlphabetically();
    } catch (error) {
      if (kDebugMode) {
        print('Error in fetchRelatedCharacters: $error');
      }
      Get.snackbar(
        'Error',
        'Error fetching related characters: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingRelated.value = false;
    }
  }

  /// Fetches characters from a specific source and updates the [relatedCharacters] list.
  ///
  /// [fetchFunction] - A function that returns a list of items from which to fetch related characters.
  /// [currentCharacterId] - The ID of the current character to exclude from the results.
  /// Updates the [relatedCharacters] list with characters fetched from the provided source.
  Future<void> _fetchAndUpdateRelatedCharacters(
    Future<List<dynamic>> Function() fetchFunction,
    int currentCharacterId,
  ) async {
    try {
      final items = await fetchFunction();
      for (var item in items) {
        final charactersFromItem = await _fetchCharactersById(item.id);
        for (var character in charactersFromItem) {
          if (character.id == currentCharacterId) continue;
          if (!relatedCharacters.any((c) => c.id == character.id)) {
            relatedCharacters.add(character);
          }
        }
      }

      _sortRelatedCharactersAlphabetically();
    } catch (error) {
      if (kDebugMode) {
        print('Error in _fetchAndUpdateRelatedCharacters: $error');
      }
      Get.snackbar(
        'Error',
        'Failed to fetch related characters: ${_parseError(error)}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

// Error parser utility method
  String _parseError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        return 'Status code: ${error.response?.statusCode} - ${error.response?.statusMessage}';
      }
      return 'DioException - ${error.message}';
    }
    return 'Unknown error - ${error.toString()}';
  }

  /// Fetches characters by ID with retry logic.
  ///
  /// [id] - The ID of the comic, series, event, or story.
  /// Returns a list of characters associated with the provided ID.
  Future<List<Character>> _fetchCharactersById(int id) async {
    return await _fetchWithRetry(
      () async => (await _characterRepository.fetchCharactersInComic(id)).data.results,
      3,
    );
  }

  /// Sorts the [relatedCharacters] list alphabetically by character name.
  void _sortRelatedCharactersAlphabetically() {
    relatedCharacters.sort((a, b) => a.name.compareTo(b.name));
  }

  /// Fetches a list of characters from a specific comic ID with retry logic.
  ///
  /// [comicId] - The ID of the comic to fetch characters from.
  Future<List<Character>> _fetchCharactersInComic(int comicId) async {
    return await _fetchWithRetry(
      () async => (await _characterRepository.fetchCharactersInComic(comicId)).data.results,
      3,
    );
  }

  /// Fetches a list of characters from a specific series ID with retry logic.
  ///
  /// [seriesId] - The ID of the series to fetch characters from.
  Future<List<Character>> _fetchCharactersInSeries(int seriesId) async {
    return await _fetchWithRetry(
      () async => (await _characterRepository.fetchCharactersInSeries(seriesId)).data.results,
      3,
    );
  }

  /// Fetches a list of characters from a specific event ID with retry logic.
  ///
  /// [eventId] - The ID of the event to fetch characters from.
  Future<List<Character>> _fetchCharactersInEvent(int eventId) async {
    return await _fetchWithRetry(
      () async => (await _characterRepository.fetchCharactersInEvent(eventId)).data.results,
      3,
    );
  }

  /// Fetches a list of characters from a specific story ID with retry logic.
  ///
  /// [storyId] - The ID of the story to fetch characters from.
  Future<List<Character>> _fetchCharactersInStory(int storyId) async {
    return await _fetchWithRetry(
      () async => (await _characterRepository.fetchCharactersInStory(storyId)).data.results,
      3,
    );
  }

  /// Fetches a list of characters from a specific creator ID with retry logic.
  ///
  /// [creatorId] - The ID of the creator to fetch characters from.
  Future<List<Character>> _fetchCharactersByCreator(int creatorId) async {
    return await _fetchWithRetry(
      () async => (await _characterRepository.fetchCharactersByCreator(creatorId)).data.results,
      3,
    );
  }

  /// Fetches data with retry logic in case of failures.
  ///
  /// [fetchFunction] - The function that performs the fetch operation.
  /// [retries] - The number of times to retry the fetch operation on failure.
  /// Returns the data fetched by the [fetchFunction].
  Future<List<T>> _fetchWithRetry<T>(
    Future<List<T>> Function() fetchFunction,
    int retries,
  ) async {
    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        return await fetchFunction();
      } catch (error) {
        if (error is DioException && error.response?.statusCode == 429) {
          final retryAfter = error.response?.headers.value('retry-after');
          final waitTime = retryAfter != null
              ? Duration(seconds: int.tryParse(retryAfter) ?? (2 << attempt).toInt())
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
