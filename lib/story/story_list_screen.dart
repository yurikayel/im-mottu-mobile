import 'package:im_mottu_mobile/index.dart';

class StoryListScreen extends StatelessWidget {
  final StoryViewModel storyViewModel;

  const StoryListScreen({super.key, required this.storyViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marvel Stories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: StorySearchDelegate(
                  searchController: storyViewModel.searchController,
                  onSearchQueryChanged: storyViewModel.onSearchQueryChanged,
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (storyViewModel.errorMessage.value.isNotEmpty) {
          return Center(child: Text(storyViewModel.errorMessage.value));
        }

        if (storyViewModel.isLoading.value && storyViewModel.stories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return NotificationListener<ScrollNotification>(
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
                child: GridView.builder(
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
                    return StoryGridItem(story: story);
                  },
                ),
              ),
              if (storyViewModel.isLoading.value &&
                  storyViewModel.stories.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(64.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class StorySearchDelegate extends SearchDelegate<String> {
  final TextEditingController searchController;
  final void Function(String query) onSearchQueryChanged;

  StorySearchDelegate({
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
          query = '';
          searchController.clear();
          onSearchQueryChanged(query); // Clear search results
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

  const StoryGridItem({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(story: story),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                story.title,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
