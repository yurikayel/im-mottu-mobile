import 'package:im_mottu_mobile/index.dart';

class EventViewModel extends GetxController {
  final IMarvelRepository _marvelRepository;
  final TextEditingController searchController = TextEditingController();

  // Observable variables
  var events = <Event>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;
  var offset = 0;
  final int limit = 20;

  // Constructor
  EventViewModel(this._marvelRepository);

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
    searchController.addListener(() {
      onSearchQueryChanged(searchController.text);
    });
  }

  /// Fetches a list of events from the repository.
  Future<void> fetchEvents() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _marvelRepository.fetchEvents(
        nameStartsWith: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        limit: limit,
        offset: offset,
      );

      events.addAll(response.data?.results ?? []);
      offset += limit;
    } catch (e) {
      errorMessage.value = 'Failed to load events: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles changes in the search query.
  void onSearchQueryChanged(String query) {
    searchQuery.value = query;
    offset = 0;
    events.clear();
    fetchEvents();
  }
}
