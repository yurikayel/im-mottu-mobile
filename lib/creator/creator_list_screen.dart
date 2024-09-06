import 'package:im_mottu_mobile/index.dart';

class CreatorListScreen extends StatelessWidget {
  final CreatorViewModel creatorViewModel;

  const CreatorListScreen({super.key, required this.creatorViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
              () {
            final query = creatorViewModel.searchQuery.value;
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
                () => creatorViewModel.searchQuery.value.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                creatorViewModel.onSearchChanged('');
              },
            )
                : IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CreatorSearchDelegate(
                    onSearchQueryChanged:
                    creatorViewModel.onSearchChanged,
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
            if (!creatorViewModel.isLoading.value &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              creatorViewModel.fetchCreators();
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
                    itemCount: creatorViewModel.creators.length,
                    itemBuilder: (context, index) {
                      final creator = creatorViewModel.creators[index];
                      return CreatorGridItem(
                        creator: creator,
                        creatorViewModel: creatorViewModel,
                      );
                    },
                  ),
                ),
              ),
              if (creatorViewModel.isLoading.value)
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

class CreatorSearchDelegate extends SearchDelegate<String> {
  final void Function(String query) onSearchQueryChanged;

  CreatorSearchDelegate({
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

class CreatorGridItem extends StatelessWidget {
  final Creator creator;
  final CreatorViewModel creatorViewModel;

  const CreatorGridItem({
    super.key,
    required this.creator,
    required this.creatorViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatorDetailScreen(
              creator: creator,
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
                  '${creator.thumbnail?.path}.${creator.thumbnail?.extension}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                creator.fullName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
