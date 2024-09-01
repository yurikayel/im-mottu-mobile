import 'package:im_mottu_mobile/index.dart';

class ComicViewModel extends GetxController {
  final IMarvelRepository _marvelRepository;

  // Observable variables
  var comics = <Comic>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Constructor
  ComicViewModel(this._marvelRepository);

  @override
  void onInit() {
    super.onInit();
    fetchComics();
  }

  /// Fetches a list of comics from the repository.
  Future<void> fetchComics({
    String? titleStartsWith,
    int? limit = 20,
    int? offset = 0,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _marvelRepository.fetchComics(
        titleStartsWith: titleStartsWith,
        limit: limit,
        offset: offset,
      );

      comics.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load comics: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles changes in the search query.
  void onSearchQueryChanged(String query) {
    fetchComics(titleStartsWith: query, limit: 20, offset: 0);
  }
}
