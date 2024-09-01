import 'package:im_mottu_mobile/index.dart';

class CharacterViewModel extends GetxController {
  final ICharacterRepository _characterRepository;
  final RxList<Character> characters = <Character>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt offset = 0.obs;
  final int limit = 20;

  CharacterViewModel(this._characterRepository);

  @override
  void onInit() {
    super.onInit();
    fetchCharacters();
  }

  void fetchCharacters() {
    if (isLoading.value) return;

    isLoading.value = true;
    _characterRepository
        .fetchCharacters(
      nameStartsWith: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      limit: limit,
      offset: offset.value,
    )
        .then((data) {
      characters.addAll(data.data.results);
      offset.value += limit;
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching characters: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  void fetchCharacterById(int characterId) {
    if (isLoading.value) return;

    isLoading.value = true;
    _characterRepository.fetchCharacterById(characterId).then((data) {
      characters.clear();
      characters.addAll(data.data.results);
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching character: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  void fetchCharactersInComic(int comicId) {
    if (isLoading.value) return;

    isLoading.value = true;
    _characterRepository.fetchCharactersInComic(comicId).then((data) {
      characters.clear();
      characters.addAll(data.data.results);
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching characters in comic: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  void fetchCharactersInSeries(int seriesId) {
    if (isLoading.value) return;

    isLoading.value = true;
    _characterRepository.fetchCharactersInSeries(seriesId).then((data) {
      characters.clear();
      characters.addAll(data.data.results);
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching characters in series: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  void fetchCharactersInEvent(int eventId) {
    if (isLoading.value) return;

    isLoading.value = true;
    _characterRepository.fetchCharactersInEvent(eventId).then((data) {
      characters.clear();
      characters.addAll(data.data.results);
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching characters in event: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  void fetchCharactersInStory(int storyId) {
    if (isLoading.value) return;

    isLoading.value = true;
    _characterRepository.fetchCharactersInStory(storyId).then((data) {
      characters.clear();
      characters.addAll(data.data.results);
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching characters in story: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    offset.value = 0;
    characters.clear();
    fetchCharacters();
  }
}
