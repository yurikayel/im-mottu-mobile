import 'package:im_mottu_mobile/index.dart';

class StoryListScreen extends StatelessWidget {
  final StoryViewModel storyViewModel;

  const StoryListScreen({super.key, required this.storyViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () {
            final query = storyViewModel.searchQuery.value;
            return Center(
              child: Text(
                query.isNotEmpty
                    ? 'Search results for "$query"'
                    : 'Marvel Stories',
              ),
            );
          },
        ),
        actions: [
          Obx(
            () => storyViewModel.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      storyViewModel.onSearchChanged('');
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: StorySearchDelegate(
                          onSearchQueryChanged: storyViewModel.onSearchChanged,
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
            if (!storyViewModel.isLoading.value &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              storyViewModel.fetchStories();
              return true;
            }
            return false;
          },
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: storyViewModel.stories.length,
                    itemBuilder: (context, index) {
                      final story = storyViewModel.stories[index];
                      return StoryListItem(
                        story: story,
                        storyViewModel: storyViewModel,
                      );
                    },
                  ),
                ),
              ),
              if (storyViewModel.isLoading.value)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(64.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class StorySearchDelegate extends SearchDelegate<String> {
  final void Function(String query) onSearchQueryChanged;

  StorySearchDelegate({
    required this.onSearchQueryChanged,
  });

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        <String>[]; // Populate with real suggestions if applicable

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
    return Container(); // Optionally return a placeholder widget
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

class StoryListItem extends StatelessWidget {
  final Story story;
  final StoryViewModel storyViewModel;

  const StoryListItem({
    super.key,
    required this.story,
    required this.storyViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          story.title,
          style: Theme.of(context).textTheme.headlineSmall,
          overflow: TextOverflow.clip,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(
              story: story,
            ),
          ),
        );
      },
    );
  }
}
