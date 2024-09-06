import 'package:im_mottu_mobile/index.dart';

class CreatorViewModel extends GetxController {
  final ICreatorRepository _creatorRepository;
  final RxList<Creator> creators = <Creator>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isEndOfList = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt offset = 0.obs;
  final int limit = 20;

  CreatorViewModel(this._creatorRepository);

  @override
  void onInit() {
    super.onInit();
    fetchCreators();
  }

  void onSearchChanged(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    offset.value = 0;
    creators.clear();
    isEndOfList.value = false;
    fetchCreators();
  }

  void fetchCreators() {
    if (isLoading.value || isEndOfList.value) return;

    isLoading.value = true;
    _creatorRepository
        .fetchCreators(
      nameStartsWith: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      limit: limit,
      offset: offset.value,
    )
        .then((data) {
      if (data.data.results.isNotEmpty) {
        creators.addAll(data.data.results);
        offset.value += limit;
      } else {
        isEndOfList.value = true;
        Get.snackbar(
          'Info',
          'No more creators to load',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching creators: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> fetchCreatorById(int creatorId) async {
    try {
      isLoading.value = true;
      final data = await _creatorRepository.fetchCreatorById(creatorId);
      creators.clear();
      creators.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching creator: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCreatorsByComic(int comicId) async {
    try {
      isLoading.value = true;
      final data = await _creatorRepository.fetchCreatorsByComic(comicId);
      creators.clear();
      creators.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching creators by comic: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCreatorsBySeries(int seriesId) async {
    try {
      isLoading.value = true;
      final data = await _creatorRepository.fetchCreatorsBySeries(seriesId);
      creators.clear();
      creators.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching creators by series: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCreatorsByEvent(int eventId) async {
    try {
      isLoading.value = true;
      final data = await _creatorRepository.fetchCreatorsByEvent(eventId);
      creators.clear();
      creators.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching creators by event: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCreatorsByCharacter(int characterId) async {
    try {
      isLoading.value = true;
      final data =
          await _creatorRepository.fetchCreatorsByCharacter(characterId);
      creators.clear();
      creators.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching creators by character: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
