import 'package:get/get.dart';
import 'package:im_mottu_mobile/index.dart';

class StoryViewModel extends GetxController {
  final IStoryRepository _storyRepository;

  // Observable variables
  var stories = <Story>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Constructor
  StoryViewModel(this._storyRepository);

  @override
  void onInit() {
    super.onInit();
    fetchStories();
  }

  /// Fetches a list of stories from the repository.
  Future<void> fetchStories({
    String? title,
    String? titleStartsWith,
    String? comics,
    String? series,
    String? creators,
    String? events,
    String? characters,
    String? orderBy,
    int? limit = 20,
    int? offset = 0,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _storyRepository.fetchStories(
        title: title,
        titleStartsWith: titleStartsWith,
        comics: comics,
        series: series,
        creators: creators,
        events: events,
        characters: characters,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      stories.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load stories: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches stories associated with a specific comic.
  Future<void> fetchStoriesByComic(int comicId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _storyRepository.fetchStoriesByComic(comicId);
      stories.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load stories: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches stories associated with a specific series.
  Future<void> fetchStoriesBySeries(int seriesId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _storyRepository.fetchStoriesBySeries(seriesId);
      stories.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load stories: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches stories associated with a specific creator.
  Future<void> fetchStoriesByCreator(int creatorId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _storyRepository.fetchStoriesByCreator(creatorId);
      stories.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load stories: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches stories associated with a specific event.
  Future<void> fetchStoriesByEvent(int eventId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _storyRepository.fetchStoriesByEvent(eventId);
      stories.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load stories: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches stories associated with a specific character.
  Future<void> fetchStoriesByCharacter(int characterId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response =
          await _storyRepository.fetchStoriesByCharacter(characterId);
      stories.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load stories: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles changes in the search query.
  void onSearchQueryChanged(String query) {
    fetchStories(titleStartsWith: query, limit: 20, offset: 0);
  }
}
