import 'package:im_mottu_mobile/index.dart';

class StoryViewModel extends GetxController {
  final IStoryRepository _storyRepository;
  final RxList<Story> stories = <Story>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isEndOfList = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt offset = 0.obs;
  final int limit = 20;

  StoryViewModel(this._storyRepository);

  @override
  void onInit() {
    super.onInit();
    fetchStories();
  }

  void onSearchChanged(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    offset.value = 0;
    stories.clear();
    isEndOfList.value = false;
    fetchStories();
  }

  void fetchStories() {
    if (isLoading.value || isEndOfList.value) return;

    isLoading.value = true;
    _storyRepository.fetchStories(
      titleStartsWith: searchQuery.value.isNotEmpty
          ? searchQuery.value
          : null,
      limit: limit,
      offset: offset.value,
    )
        .then((data) {
      if (data.data.results.isNotEmpty) {
        stories.addAll(data.data.results);
        offset.value += limit;
      } else {
        isEndOfList.value = true;
        Get.snackbar(
          'Info',
          'No more stories to load',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching stories: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> fetchStoryById(int storyId) async {
    try {
      isLoading.value = true;
      final data = await _storyRepository.fetchStoryById(storyId);
      stories.clear();
      stories.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching story: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStoriesByComic(int comicId) async {
    try {
      isLoading.value = true;
      final data = await _storyRepository.fetchStoriesByComic(comicId);
      stories.clear();
      stories.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching stories by comic: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStoriesBySeries(int seriesId) async {
    try {
      isLoading.value = true;
      final data = await _storyRepository.fetchStoriesBySeries(seriesId);
      stories.clear();
      stories.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching stories by series: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStoriesByCreator(int creatorId) async {
    try {
      isLoading.value = true;
      final data = await _storyRepository.fetchStoriesByCreator(creatorId);
      stories.clear();
      stories.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching stories by creator: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStoriesByEvent(int eventId) async {
    try {
      isLoading.value = true;
      final data = await _storyRepository.fetchStoriesByEvent(eventId);
      stories.clear();
      stories.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching stories by event: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStoriesByCharacter(int characterId) async {
    try {
      isLoading.value = true;
      final data = await _storyRepository.fetchStoriesByCharacter(characterId);
      stories.clear();
      stories.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching stories by character: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
