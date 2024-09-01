import 'package:im_mottu_mobile/index.dart';

class StoryViewModel extends GetxController {
  final IMarvelRepository _marvelRepository;
  final TextEditingController searchController = TextEditingController();

  // Observable variables
  var stories = <Story>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;
  var offset = 0;
  final int limit = 20;

  // Constructor
  StoryViewModel(this._marvelRepository);

  @override
  void onInit() {
    super.onInit();
    fetchStories();
    searchController.addListener(() {
      onSearchQueryChanged(searchController.text);
    });
  }

  /// Fetches a list of stories from the repository.
  Future<void> fetchStories() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _marvelRepository.fetchStories(
        titleStartsWith:
            searchQuery.value.isNotEmpty ? searchQuery.value : null,
        limit: limit,
        offset: offset,
      );

      stories.addAll(response.data?.results ?? []);
      offset += limit;
    } catch (e) {
      errorMessage.value = 'Failed to load stories: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles changes in the search query.
  void onSearchQueryChanged(String query) {
    searchQuery.value = query;
    offset = 0;
    stories.clear();
    fetchStories();
  }
}
