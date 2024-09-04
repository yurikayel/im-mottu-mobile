import 'package:im_mottu_mobile/index.dart';

class EventListScreen extends StatelessWidget {
  final EventViewModel eventViewModel;

  const EventListScreen({super.key, required this.eventViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marvel Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EventSearchDelegate(
                  searchController: eventViewModel.searchController,
                  onSearchQueryChanged: eventViewModel.onSearchQueryChanged,
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (eventViewModel.errorMessage.value.isNotEmpty) {
          return Center(child: Text(eventViewModel.errorMessage.value));
        }

        return NotificationListener<ScrollNotification>(
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
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 4 : 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.0, // Make cards square
                  ),
                  itemCount: eventViewModel.events.length,
                  itemBuilder: (context, index) {
                    final event = eventViewModel.events[index];
                    return EventGridItem(event: event);
                  },
                ),
              ),
              if (eventViewModel.isLoading.value)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(64.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class EventSearchDelegate extends SearchDelegate<String> {
  final TextEditingController searchController;
  final void Function(String query) onSearchQueryChanged;

  EventSearchDelegate({
    required this.searchController,
    required this.onSearchQueryChanged,
  });

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = <String>[]; // Populate with actual suggestions
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            searchController.text = suggestion;
            query = suggestion;
            onSearchQueryChanged(query); // Pass the query to parent
            Navigator.pop(context); // Close the search delegate after selection
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.text = query;
      onSearchQueryChanged(query); // Trigger search with current query
      Navigator.pop(
          context); // Close the search delegate after triggering the search
    });
    return Container(); // Placeholder, as search results are managed by the parent screen
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
          searchController.clear();
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}

class EventGridItem extends StatelessWidget {
  final Event event;

  const EventGridItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8.0)),
                  child: event.thumbnail != null
                      ? Center(
                          child: Image.network(
                            '${event.thumbnail?.path}.${event.thumbnail?.extension}',
                            fit: BoxFit.fitHeight,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.error),
                              );
                            },
                          ),
                        )
                      : const Placeholder(), // Show a placeholder if thumbnail is null
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 6.0, bottom: 6.0),
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
