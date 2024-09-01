import 'package:im_mottu_mobile/index.dart';

class SeriesDetailScreen extends StatelessWidget {
  final Series series;

  const SeriesDetailScreen({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(series.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (series.thumbnail != null)
              Center(
                child: Image.network(
                  '${series.thumbnail!.path}.${series.thumbnail!.extension}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
            const SizedBox(height: 16.0),
            Text(
              series.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16.0),
            if (series.description != null && series.description!.isNotEmpty)
              Text(
                series.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const SizedBox(height: 16.0),
            Text(
              'Start Year: ${series.startYear}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'End Year: ${series.endYear}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Rating: ${series.rating}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Modified: ${series.modified}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
