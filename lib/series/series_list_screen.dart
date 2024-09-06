import 'package:im_mottu_mobile/index.dart';

class SeriesListScreen extends StatelessWidget {
  final SeriesViewModel seriesViewModel;

  const SeriesListScreen({super.key, required this.seriesViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () {
            final query = seriesViewModel.searchQuery.value;
            return Center(
              child: Text(
                query.isNotEmpty
                    ? 'Search results for "$query"'
                    : 'Marvel Series',
              ),
            );
          },
        ),
        actions: [
          Obx(
            () => seriesViewModel.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      seriesViewModel.onSearchChanged('');
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: SeriesSearchDelegate(
                          onSearchQueryChanged: seriesViewModel.onSearchChanged,
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
                    itemCount: seriesViewModel.series.length,
                    itemBuilder: (context, index) {
                      final series = seriesViewModel.series[index];
                      return SeriesGridItem(
                        series: series,
                        seriesViewModel: seriesViewModel,
                      );
                    },
                  ),
                ),
              ),
              if (seriesViewModel.isLoading.value)
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

class SeriesSearchDelegate extends SearchDelegate<String> {
  final void Function(String query) onSearchQueryChanged;

  SeriesSearchDelegate({
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

class SeriesGridItem extends StatelessWidget {
  final Series series;
  final SeriesViewModel seriesViewModel;

  const SeriesGridItem({
    super.key,
    required this.series,
    required this.seriesViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeriesDetailScreen(
              series: series,
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
                  '${series.thumbnail?.path}.${series.thumbnail?.extension}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
