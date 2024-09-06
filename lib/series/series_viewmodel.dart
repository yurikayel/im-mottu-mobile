import 'package:im_mottu_mobile/index.dart';

class SeriesViewModel extends GetxController {
  final ISeriesRepository _seriesRepository;
  final RxList<Series> series = <Series>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isEndOfList = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt offset = 0.obs;
  final int limit = 20;

  SeriesViewModel(this._seriesRepository);

  @override
  void onInit() {
    super.onInit();
    fetchSeries();
  }

  void onSearchChanged(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    offset.value = 0;
    series.clear();
    isEndOfList.value = false;
    fetchSeries();
  }

  void fetchSeries() {
    if (isLoading.value || isEndOfList.value) return;

    isLoading.value = true;
    _seriesRepository
        .fetchSeries(
      titleStartsWith: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      limit: limit,
      offset: offset.value,
    )
        .then((data) {
      if (data.data.results.isNotEmpty) {
        series.addAll(data.data.results);
        offset.value += limit;
      } else {
        isEndOfList.value = true;
        Get.snackbar(
          'Info',
          'No more series to load',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching series: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> fetchSeriesById(int seriesId) async {
    try {
      isLoading.value = true;
      final data = await _seriesRepository.fetchSeriesById(seriesId);
      series.clear();
      series.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching series: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSeriesByComic(int comicId) async {
    try {
      isLoading.value = true;
      final data = await _seriesRepository.fetchSeriesByComic(comicId);
      series.clear();
      series.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching series by comic: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSeriesByEvent(int eventId) async {
    try {
      isLoading.value = true;
      final data = await _seriesRepository.fetchSeriesByEvent(eventId);
      series.clear();
      series.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching series by event: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSeriesByCreator(int creatorId) async {
    try {
      isLoading.value = true;
      final data = await _seriesRepository.fetchSeriesByCreator(creatorId);
      series.clear();
      series.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching series by creator: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSeriesByStory(int storyId) async {
    try {
      isLoading.value = true;
      final data = await _seriesRepository.fetchSeriesByStory(storyId);
      series.clear();
      series.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching series by story: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
