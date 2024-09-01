import 'package:im_mottu_mobile/index.dart';

class SeriesListScreen extends StatelessWidget {
  final SeriesViewModel seriesViewModel;

  const SeriesListScreen({super.key, required this.seriesViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marvel Series'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SeriesSearchDelegate(
                  searchController: seriesViewModel.searchController,
                  onSearchQueryChanged: seriesViewModel.onSearchQueryChanged,
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (seriesViewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (seriesViewModel.errorMessage.value.isNotEmpty) {
          return Center(child: Text(seriesViewModel.errorMessage.value));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!seriesViewModel.isLoading.value &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              seriesViewModel.fetchSeries();
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
                    childAspectRatio: 0.85,
                  ),
                  itemCount: seriesViewModel.series.length,
                  itemBuilder: (context, index) {
                    final series = seriesViewModel.series[index];
                    return SeriesGridItem(series: series);
                  },
                ),
              ),
              if (seriesViewModel.isLoading.value)
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

class SeriesSearchDelegate extends SearchDelegate<String> {
  final TextEditingController searchController;
  final void Function(String query) onSearchQueryChanged;

  SeriesSearchDelegate({
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
            onSearchQueryChanged(query);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.text = query;
      onSearchQueryChanged(query);
      Navigator.pop(context);
    });
    return Container();
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

class SeriesGridItem extends StatelessWidget {
  final Series series;

  const SeriesGridItem({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeriesDetailScreen(series: series),
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
                  child: series.thumbnail != null
                      ? Center(
                          child: Image.network(
                            '${series.thumbnail!.path}.${series.thumbnail!.extension}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.error),
                              );
                            },
                          ),
                        )
                      : const Placeholder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                series.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
