import 'package:im_mottu_mobile/index.dart';

class SeriesViewModel extends GetxController {
  final ISeriesRepository _seriesRepository;

  // Observable variables
  var series = <Series>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Constructor
  SeriesViewModel(this._seriesRepository);

  @override
  void onInit() {
    super.onInit();
    fetchSeries();
  }

  /// Fetches a list of series from the repository.
  Future<void> fetchSeries({
    String? title,
    String? titleStartsWith,
    String? comics,
    String? events,
    String? creators,
    String? stories,
    String? orderBy,
    int? limit = 20,
    int? offset = 0,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _seriesRepository.fetchSeries(
        title: title,
        titleStartsWith: titleStartsWith,
        comics: comics,
        events: events,
        creators: creators,
        stories: stories,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

      series.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load series: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches a specific series by its ID.
  Future<void> fetchSeriesById(int seriesId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _seriesRepository.fetchSeriesById(seriesId);
      series.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load series: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches series associated with a specific comic.
  Future<void> fetchSeriesByComic(int comicId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _seriesRepository.fetchSeriesByComic(comicId);
      series.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load series: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches series associated with a specific event.
  Future<void> fetchSeriesByEvent(int eventId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _seriesRepository.fetchSeriesByEvent(eventId);
      series.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load series: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches series associated with a specific creator.
  Future<void> fetchSeriesByCreator(int creatorId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _seriesRepository.fetchSeriesByCreator(creatorId);
      series.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load series: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches series associated with a specific story.
  Future<void> fetchSeriesByStory(int storyId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _seriesRepository.fetchSeriesByStory(storyId);
      series.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load series: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles changes in the search query.
  void onSearchQueryChanged(String query) {
    fetchSeries(titleStartsWith: query, limit: 20, offset: 0);
  }
}
