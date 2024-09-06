import 'package:im_mottu_mobile/index.dart';

class ComicViewModel extends GetxController {
  final IComicRepository _comicRepository;
  final RxList<Comic> comics = <Comic>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isEndOfList = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt offset = 0.obs;
  final int limit = 20;

  ComicViewModel(this._comicRepository);

  @override
  void onInit() {
    super.onInit();
    fetchComics();
  }

  void onSearchChanged(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    offset.value = 0;
    comics.clear();
    isEndOfList.value = false;
    fetchComics();
  }

  void fetchComics() {
    if (isLoading.value || isEndOfList.value) return;

    isLoading.value = true;
    _comicRepository
        .fetchComics(
      titleStartsWith: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      limit: limit,
      offset: offset.value,
    )
        .then((data) {
      if (data.data.results.isNotEmpty) {
        comics.addAll(data.data.results);
        offset.value += limit;
      } else {
        isEndOfList.value = true;
        Get.snackbar(
          'Info',
          'No more comics to load',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching comics: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> fetchComicById(int comicId) async {
    try {
      isLoading.value = true;
      final data = await _comicRepository.fetchComicById(comicId);
      comics.clear();
      comics.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching comic: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchComicsByCharacter(int characterId) async {
    try {
      isLoading.value = true;
      final data = await _comicRepository.fetchComicsByCharacter(characterId);
      comics.clear();
      comics.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching comics by character: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchComicsBySeries(int seriesId) async {
    try {
      isLoading.value = true;
      final data = await _comicRepository.fetchComicsBySeries(seriesId);
      comics.clear();
      comics.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching comics by series: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchComicsByEvent(int eventId) async {
    try {
      isLoading.value = true;
      final data = await _comicRepository.fetchComicsByEvent(eventId);
      comics.clear();
      comics.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching comics by event: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
