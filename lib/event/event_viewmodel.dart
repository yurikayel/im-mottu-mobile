import 'package:im_mottu_mobile/index.dart';

class EventViewModel extends GetxController {
  final IEventRepository _eventRepository;
  final RxList<Event> events = <Event>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isEndOfList = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt offset = 0.obs;
  final int limit = 20;

  EventViewModel(this._eventRepository);

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  void onSearchChanged(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    offset.value = 0;
    events.clear();
    isEndOfList.value = false;
    fetchEvents();
  }

  void fetchEvents() {
    if (isLoading.value || isEndOfList.value) return;

    isLoading.value = true;
    _eventRepository
        .fetchEvents(
      nameStartsWith: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      limit: limit,
      offset: offset.value,
    )
        .then((data) {
      if (data.data.results.isNotEmpty) {
        events.addAll(data.data.results);
        offset.value += limit;
      } else {
        isEndOfList.value = true;
        Get.snackbar(
          'Info',
          'No more events to load',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      isLoading.value = false;
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Error fetching events: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  Future<void> fetchEventById(int eventId) async {
    try {
      isLoading.value = true;
      final data = await _eventRepository.fetchEventById(eventId);
      events.clear();
      events.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching event: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEventsByComic(int comicId) async {
    try {
      isLoading.value = true;
      final data = await _eventRepository.fetchEventsByComic(comicId);
      events.clear();
      events.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching events by comic: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEventsBySeries(int seriesId) async {
    try {
      isLoading.value = true;
      final data = await _eventRepository.fetchEventsBySeries(seriesId);
      events.clear();
      events.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching events by series: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEventsByCharacter(int characterId) async {
    try {
      isLoading.value = true;
      final data = await _eventRepository.fetchEventsByCharacter(characterId);
      events.clear();
      events.addAll(data.data.results);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error fetching events by character: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
