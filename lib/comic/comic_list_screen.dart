import 'package:im_mottu_mobile/index.dart';

class ComicListScreen extends StatelessWidget {
  final ComicViewModel comicViewModel;

  const ComicListScreen({super.key, required this.comicViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () {
            final query = comicViewModel.searchQuery.value;
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
            () => comicViewModel.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // Clear search query and reload default comic list
                      comicViewModel.onSearchChanged('');
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: ComicSearchDelegate(
                          onSearchQueryChanged: comicViewModel.onSearchChanged,
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
                    itemCount: comicViewModel.comics.length,
                    itemBuilder: (context, index) {
                      final comic = comicViewModel.comics[index];
                      return ComicGridItem(
                        comic: comic,
                        comicViewModel: comicViewModel,
                      );
                    },
                  ),
                ),
              ),
              if (comicViewModel.isLoading.value)
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

class ComicSearchDelegate extends SearchDelegate<String> {
  final void Function(String query) onSearchQueryChanged;

  ComicSearchDelegate({
    required this.onSearchQueryChanged,
  });

  @override
  Widget buildSuggestions(BuildContext context) {
    // You might want to provide actual suggestions here
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
            close(context, 'close'); // Dismiss search when query is empty
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

class ComicGridItem extends StatelessWidget {
  final Comic comic;
  final ComicViewModel comicViewModel;

  const ComicGridItem(
      {super.key, required this.comic, required this.comicViewModel});

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
                child: Image.network(
                  '${comic.thumbnail?.path}.${comic.thumbnail?.extension}',
                  fit: BoxFit.cover,
                ),
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
