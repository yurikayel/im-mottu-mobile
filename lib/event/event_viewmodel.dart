import 'package:im_mottu_mobile/index.dart';

class EventViewModel extends GetxController {
  final IEventRepository _eventRepository;

  // Observable variables
  var events = <Event>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Constructor
  EventViewModel(this._eventRepository);

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  /// Fetches a list of events from the repository.
  Future<void> fetchEvents({
    String? name,
    String? nameStartsWith,
    String? comics,
    String? series,
    String? creators,
    String? stories,
    String? orderBy,
    int? limit = 20,
    int? offset = 0,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _eventRepository.fetchEvents(
        name: name,
        nameStartsWith: nameStartsWith,
        comics: comics,
        series: series,
        creators: creators,
        stories: stories,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      events.value =
          response.data.results.map((item) => item).toList();
    } catch (e) {
      errorMessage.value = 'Failed to load events: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches event details by ID.
  Future<void> fetchEventById(int eventId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _eventRepository.fetchEventById(eventId);
      events.value =
          response.data.results.map((item) => item).toList();
    } catch (e) {
      errorMessage.value = 'Failed to load event: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches events associated with a specific comic.
  Future<void> fetchEventsByComic(int comicId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _eventRepository.fetchEventsByComic(comicId);
      events.value =
          response.data.results.map((item) => item).toList();
    } catch (e) {
      errorMessage.value = 'Failed to load events by comic: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches events associated with a specific creator.
  Future<void> fetchEventsByCreator(int creatorId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _eventRepository.fetchEventsByCreator(creatorId);
      events.value =
          response.data.results.map((item) => item).toList();
    } catch (e) {
      errorMessage.value = 'Failed to load events by creator: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches events associated with a specific series.
  Future<void> fetchEventsBySeries(int seriesId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _eventRepository.fetchEventsBySeries(seriesId);
      events.value = response.data.results.map((item) => item).toList();
    } catch (e) {
      errorMessage.value = 'Failed to load events by series: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches events associated with a specific story.
  Future<void> fetchEventsByStory(int storyId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _eventRepository.fetchEventsByStory(storyId);
      events.value =
          response.data.results.map((item) => item).toList();
    } catch (e) {
      errorMessage.value = 'Failed to load events by story: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles changes in the search query.
  void onSearchQueryChanged(String query) {
    fetchEvents(nameStartsWith: query, limit: 20, offset: 0);
  }
}
