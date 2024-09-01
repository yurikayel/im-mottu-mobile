import 'package:im_mottu_mobile/index.dart';

class SeriesViewModel extends GetxController {
  final IMarvelRepository _marvelRepository;
  final TextEditingController searchController = TextEditingController();

  // Observable variables
  var series = <Series>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;
  var offset = 0;
  final int limit = 20;

  // Constructor
  SeriesViewModel(this._marvelRepository);

  @override
  void onInit() {
    super.onInit();
    fetchSeries();
    searchController.addListener(() {
      onSearchQueryChanged(searchController.text);
    });
  }

  /// Fetches a list of series from the repository.
  Future<void> fetchSeries() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _marvelRepository.fetchSeries(
        titleStartsWith:
            searchQuery.value.isNotEmpty ? searchQuery.value : null,
        limit: limit,
        offset: offset,
      );

      series.addAll(response.data?.results ?? []);
      offset += limit;
    } catch (e) {
      errorMessage.value = 'Failed to load series: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles changes in the search query.
  void onSearchQueryChanged(String query) {
    searchQuery.value = query;
    offset = 0;
    series.clear();
    fetchSeries();
  }
}
