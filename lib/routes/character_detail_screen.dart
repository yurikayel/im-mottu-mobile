import 'package:im_mottu_mobile/index.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = '${character.thumbnail.path}.${character.thumbnail.extension}';
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800; // Breakpoint for tablets and desktops

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(
            isLargeScreen ? 32.0 : 16.0 // Responsive padding
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the character thumbnail with placeholder and error handling
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
                character.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: isLargeScreen ? 36.0 : 24.0, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                character.description.isNotEmpty
                    ? character.description
                    : 'No description available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: isLargeScreen ? 20.0 : 16.0, // Responsive font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
