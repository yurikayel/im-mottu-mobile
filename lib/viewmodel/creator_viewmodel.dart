import 'package:im_mottu_mobile/index.dart';

class CreatorViewModel extends GetxController {
  final IMarvelRepository _marvelRepository;
  final TextEditingController searchController = TextEditingController();

  // Observable variables
  var creators = <Creator>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Constructor
  CreatorViewModel(this._marvelRepository);

  @override
  void onInit() {
    super.onInit();
    fetchCreators();
  }

  /// Fetches a list of creators from the repository.
  Future<void> fetchCreators({
    String? firstName,
    String? middleName,
    String? lastName,
    String? suffix,
    DateTime? modifiedSince,
    List<int>? comics,
    List<int>? series,
    List<int>? events,
    List<int>? stories,
    String? orderBy,
    int? limit = 20,
    int? offset = 0,
    String? nameStartsWith,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _marvelRepository.fetchCreators(
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        suffix: suffix,
        modifiedSince: modifiedSince,
        comics: comics,
        series: series,
        events: events,
        stories: stories,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
        nameStartsWith: nameStartsWith,
      );

      creators.value = response.data?.results ?? [];
    } catch (e) {
      errorMessage.value = 'Failed to load creators: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles changes in the search query.
  void onSearchQueryChanged(String query) {
    fetchCreators(nameStartsWith: query, limit: 20, offset: 0);
  }
}
