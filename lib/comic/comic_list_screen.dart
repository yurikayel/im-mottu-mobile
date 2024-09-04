import 'package:im_mottu_mobile/index.dart';

class ComicListScreen extends StatelessWidget {
  final ComicViewModel comicViewModel;

  const ComicListScreen({super.key, required this.comicViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marvel Comics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ComicSearchDelegate(
                  searchController: comicViewModel.searchController,
                  onSearchQueryChanged: comicViewModel.onSearchQueryChanged,
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (comicViewModel.errorMessage.value.isNotEmpty) {
          return Center(child: Text(comicViewModel.errorMessage.value));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!comicViewModel.isLoading.value &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              comicViewModel.fetchComics();
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
                  itemCount: comicViewModel.comics.length,
                  itemBuilder: (context, index) {
                    final comic = comicViewModel.comics[index];
                    return ComicGridItem(comic: comic);
                  },
                ),
              ),
              if (comicViewModel.isLoading.value)
                const Padding(
                  padding: EdgeInsets.all(64.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class ComicSearchDelegate extends SearchDelegate<String> {
  final TextEditingController searchController;
  final void Function(String query) onSearchQueryChanged;

  ComicSearchDelegate({
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

class ComicGridItem extends StatelessWidget {
  final Comic comic;

  const ComicGridItem({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComicDetailScreen(
              comic: comic,
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
                child: comic.thumbnail != null
                    ? Center(
                        child: Image.network(
                          '${comic.thumbnail!.path}.${comic.thumbnail!.extension}',
                          fit: BoxFit.cover,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                comic.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
