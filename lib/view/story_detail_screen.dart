import 'package:im_mottu_mobile/index.dart';

class StoryDetailScreen extends StatelessWidget {
  final Story story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            story.thumbnail != null
                ? Center(
                    child: Image.network(
                      '${story.thumbnail!.path}.${story.thumbnail!.extension}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error),
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 16.0),
            Text(
              story.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            Text(
              story.description ?? 'No description available.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Type: ${story.type}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Modified: ${story.modified}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            if (story.series != null)
              Text(
                'Series: ${story.series!.name}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 8.0),
            if (story.originalIssue != null)
              Text(
                'Original Issue: ${story.originalIssue!.name}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
