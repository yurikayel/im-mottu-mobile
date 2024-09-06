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
    _storyRepository
        .fetchStories(
      titleStartsWith: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      limit: limit,
      offset: offset.value,
    )
        .then((data) {
      if (data.data.results.isNotEmpty) {
        stories.addAll(data.data.results);
        offset.value += limit;
      } else {
        isEndOfList.value = true;
        showSnackbar('Info', 'No more stories to load');
      }
      isLoading.value = false;
    }).catchError((error) {
      showSnackbar('Error', 'Error fetching stories: $error');
      isLoading.value = false;
    });
  }

  Future<void> fetchStoryById(int storyId) async {
    _fetchStory(
      () => _storyRepository.fetchStoryById(storyId),
    );
  }

  Future<void> fetchStoriesByComic(int comicId) async {
    _fetchStory(
      () => _storyRepository.fetchStoriesByComic(comicId),
    );
  }

  Future<void> fetchStoriesBySeries(int seriesId) async {
    _fetchStory(
      () => _storyRepository.fetchStoriesBySeries(seriesId),
    );
  }

  Future<void> fetchStoriesByCreator(int creatorId) async {
    _fetchStory(
      () => _storyRepository.fetchStoriesByCreator(creatorId),
    );
  }

  Future<void> fetchStoriesByEvent(int eventId) async {
    _fetchStory(
      () => _storyRepository.fetchStoriesByEvent(eventId),
    );
  }

  Future<void> fetchStoriesByCharacter(int characterId) async {
    _fetchStory(
      () => _storyRepository.fetchStoriesByCharacter(characterId),
    );
  }

  Future<void> _fetchStory(
      Future<StoryDataWrapper> Function() fetchFunction) async {
    try {
      isLoading.value = true;
      final data = await fetchFunction();
      stories.clear();
      stories.addAll(data.data.results);
    } catch (error) {
      showSnackbar('Error', 'Error fetching story: $error');
    } finally {
      isLoading.value = false;
    }
  }

  void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
