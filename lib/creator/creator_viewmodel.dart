import 'package:im_mottu_mobile/index.dart';

class CreatorViewModel extends GetxController {
  final ICreatorRepository _creatorRepository;

  // Observable variables
  var creators = <Creator>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Constructor
  CreatorViewModel(this._creatorRepository);

  @override
  void onInit() {
    super.onInit();
    fetchCreators();
  }

  /// Fetches a list of creators from the repository.
  Future<void> fetchCreators({
    String? name,
    String? nameStartsWith,
    int? limit = 20,
    int? offset = 0,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _creatorRepository.fetchCreators(
        name: name,
        nameStartsWith: nameStartsWith,
        limit: limit,
        offset: offset,
      );

      creators.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load creators: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches a creator by ID.
  Future<void> fetchCreatorById(int creatorId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _creatorRepository.fetchCreatorById(creatorId);
      creators.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load creator: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches creators associated with a comic.
  Future<void> fetchCreatorsByComic(int comicId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _creatorRepository.fetchCreatorsByComic(comicId);
      creators.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load creators for comic: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches creators associated with a series.
  Future<void> fetchCreatorsBySeries(int seriesId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _creatorRepository.fetchCreatorsBySeries(seriesId);
      creators.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value =
          'Failed to load creators for series: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches creators associated with an event.
  Future<void> fetchCreatorsByEvent(int eventId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _creatorRepository.fetchCreatorsByEvent(eventId);
      creators.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load creators for event: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles changes in the search query.
  void onSearchQueryChanged(String query) {
    fetchCreators(nameStartsWith: query, limit: 20, offset: 0);
  }
}
