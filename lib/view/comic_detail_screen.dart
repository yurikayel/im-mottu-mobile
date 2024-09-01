import 'package:im_mottu_mobile/index.dart';

class ComicDetailScreen extends StatelessWidget {
  final Comic comic;

  const ComicDetailScreen({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = '${comic.thumbnail?.path}.${comic.thumbnail?.extension}';
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800; // Breakpoint for tablets and desktops

    return Scaffold(
      appBar: AppBar(
        title: Text(comic.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(
            isLargeScreen ? 32.0 : 16.0 // Responsive padding
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the comic thumbnail with placeholder and error handling
              SizedBox(
                width: double.infinity, // Make image take full width
                child: CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                comic.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: isLargeScreen ? 36.0 : 24.0, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                comic.description?.isNotEmpty == true
                    ? comic.description!
                    : 'No description available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: isLargeScreen ? 20.0 : 16.0, // Responsive font size
                ),
              ),
              const SizedBox(height: 16),
              // Display comic details like issue number and page count
              if (comic.issueNumber != null)
                Text(
                  'Issue Number: ${comic.issueNumber}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isLargeScreen ? 18.0 : 16.0,
                  ),
                ),
              if (comic.pageCount != null)
                Text(
                  'Page Count: ${comic.pageCount}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isLargeScreen ? 18.0 : 16.0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
