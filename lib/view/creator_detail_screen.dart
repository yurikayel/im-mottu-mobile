import 'package:im_mottu_mobile/index.dart';

class CreatorDetailScreen extends StatelessWidget {
  final Creator creator;

  const CreatorDetailScreen({super.key, required this.creator});

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl =
        '${creator.thumbnail?.path}.${creator.thumbnail?.extension}';
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen =
        screenWidth > 800; // Breakpoint for tablets and desktops

    return Scaffold(
      appBar: AppBar(
        title: Text(creator.fullName ?? 'Unknown Creator'),
      ),
      body: Padding(
        padding:
            EdgeInsets.all(isLargeScreen ? 32.0 : 16.0 // Responsive padding
                ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the creator's thumbnail with placeholder and error handling
              SizedBox(
                width: double.infinity, // Make image take full width
                child: CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                creator.fullName ?? 'No Name Available',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize:
                          isLargeScreen ? 36.0 : 24.0, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
