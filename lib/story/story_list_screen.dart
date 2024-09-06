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
                    itemCount: storyViewModel.stories.length,
                    itemBuilder: (context, index) {
                      final story = storyViewModel.stories[index];
                      return StoryGridItem(
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
    final suggestions = <String>[]; // Populate with real suggestions

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

class StoryGridItem extends StatelessWidget {
  final Story story;
  final StoryViewModel storyViewModel;

  const StoryGridItem({
    super.key,
    required this.story,
    required this.storyViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  '${story.thumbnail?.path}.${story.thumbnail?.extension}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                story.title,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
