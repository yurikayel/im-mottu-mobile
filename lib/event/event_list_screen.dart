import 'package:im_mottu_mobile/index.dart';

class EventListScreen extends StatelessWidget {
  final EventViewModel eventViewModel;

  const EventListScreen({super.key, required this.eventViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () {
            final query = eventViewModel.searchQuery.value;
            return Center(
              child: Text(
                query.isNotEmpty
                    ? 'Search results for "$query"'
                    : 'Marvel Events',
              ),
            );
          },
        ),
        actions: [
          Obx(
            () => eventViewModel.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      eventViewModel.onSearchChanged('');
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: EventSearchDelegate(
                          onSearchQueryChanged: eventViewModel.onSearchChanged,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      body: Obx(
        () => NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!eventViewModel.isLoading.value &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              eventViewModel.fetchEvents();
              return true;
            }
            return false;
          },
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 4 : 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio:
                          MediaQuery.of(context).size.width > 600 ? 0.6 : 0.8,
                    ),
                    itemCount: eventViewModel.events.length,
                    itemBuilder: (context, index) {
                      final event = eventViewModel.events[index];
                      return EventGridItem(
                        event: event,
                        eventViewModel: eventViewModel,
                      );
                    },
                  ),
                ),
              ),
              if (eventViewModel.isLoading.value)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(64.0),
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class EventSearchDelegate extends SearchDelegate<String> {
  final void Function(String query) onSearchQueryChanged;

  EventSearchDelegate({
    required this.onSearchQueryChanged,
  });

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = <String>[];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            onSearchQueryChanged(query);
            close(context, suggestion);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onSearchQueryChanged(query);
      close(context, query);
    });
    return Container();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          if (query.isEmpty) {
            close(context, 'close');
          } else {
            query = '';
            onSearchQueryChanged(query);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, 'close');
      },
    );
  }
}

class EventGridItem extends StatelessWidget {
  final Event event;
  final EventViewModel eventViewModel;

  const EventGridItem({
    super.key,
    required this.event,
    required this.eventViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              event: event,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.network(
                  '${event.thumbnail?.path}.${event.thumbnail?.extension}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                event.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
