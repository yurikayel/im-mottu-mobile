import 'package:im_mottu_mobile/index.dart';

class CharacterViewModel extends GetxController {
  final IMarvelRepository _marvelRepository;
  final RxList<Character> characters = <Character>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt offset = 0.obs;
  final int limit = 20;

  CharacterViewModel(this._marvelRepository);

  @override
  void onInit() {
    super.onInit();
    fetchCharacters();
  }

  void fetchCharacters() {
    if (isLoading.value) return;

    isLoading.value = true;
    _marvelRepository
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

  void onSearchChanged(String query) {
    searchQuery.value = query;
    offset.value = 0;
    characters.clear();
    fetchCharacters();
  }
}
