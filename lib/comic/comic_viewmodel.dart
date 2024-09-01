import 'package:im_mottu_mobile/index.dart';

/// ViewModel for managing comic-related data and UI state.
class ComicViewModel extends GetxController {
  final IComicRepository _comicRepository;

  // Observable variables
  var comics = <Comic>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Constructor
  ComicViewModel(this._comicRepository);

  @override
  void onInit() {
    super.onInit();
    fetchComics();
  }

  /// Fetches a list of comics from the repository.
  ///
  /// [titleStartsWith] - Optionally filter comics whose title starts with this string.
  /// [limit] - Number of comics to fetch (default is 20).
  /// [offset] - Pagination offset (default is 0).
  Future<void> fetchComics({
    String? titleStartsWith,
    int? limit = 20,
    int? offset = 0,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _comicRepository.fetchComics(
        titleStartsWith: titleStartsWith,
        limit: limit,
        offset: offset,
      );

      comics.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load comics: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches a specific comic by its ID.
  ///
  /// [comicId] - The ID of the comic to fetch.
  Future<void> fetchComicById(int comicId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _comicRepository.fetchComicById(comicId);
      comics.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load comic: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches comics associated with a specific character.
  ///
  /// [characterId] - The ID of the character.
  Future<void> fetchComicsByCharacter(int characterId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _comicRepository.fetchComicsByCharacter(characterId);
      comics.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load comics for character: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches comics associated with a specific series.
  ///
  /// [seriesId] - The ID of the series.
  Future<void> fetchComicsBySeries(int seriesId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _comicRepository.fetchComicsBySeries(seriesId);
      comics.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load comics for series: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches comics associated with a specific event.
  ///
  /// [eventId] - The ID of the event.
  Future<void> fetchComicsByEvent(int eventId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _comicRepository.fetchComicsByEvent(eventId);
      comics.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load comics for event: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles changes in the search query.
  ///
  /// [query] - The new search query to filter comics.
  void onSearchQueryChanged(String query) {
    fetchComics(titleStartsWith: query, limit: 20, offset: 0);
  }
}
