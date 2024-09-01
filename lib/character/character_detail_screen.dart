import 'package:flutter/material.dart';
import 'package:im_mottu_mobile/index.dart';

class CharacterDetailScreen extends StatefulWidget {
  final Character character;
  final CharacterViewModel characterViewModel;

  const CharacterDetailScreen({
    super.key,
    required this.character,
    required this.characterViewModel,
  });

  @override
  _CharacterDetailScreenState createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch related characters when the screen is initialized
    widget.characterViewModel.fetchRelatedCharacters(widget.character.id);
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl =
        '${widget.character.thumbnail.path}.${widget.character.thumbnail.extension}';
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen =
        screenWidth > 800; // Breakpoint for tablets and desktops

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.character.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 32.0 : 16.0),
        child: ListView(
          children: [
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
              widget.character.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: isLargeScreen ? 36.0 : 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.character.description.isNotEmpty
                  ? widget.character.description
                  : 'No description available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: isLargeScreen ? 20.0 : 16.0,
              ),
            ),
            const SizedBox(height: 16),
            _buildRelatedCharacters(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedCharacters(BuildContext context) {
    return Obx(() {
      final relatedCharacters = widget.characterViewModel.relatedCharacters;

      if (relatedCharacters.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // Sort related characters alphabetically by name
      relatedCharacters.sort((a, b) => a.name.compareTo(b.name));

      final screenWidth = MediaQuery.of(context).size.width;
      final crossAxisCount = screenWidth > 1200
          ? 6
          : screenWidth > 800
          ? 4
          : 2;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Characters',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 2 / 3, // Adjust as needed
            ),
            itemCount: relatedCharacters.length,
            itemBuilder: (context, index) {
              final relatedCharacter = relatedCharacters[index];
              return GridTile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl:
                        '${relatedCharacter.thumbnail.path}.${relatedCharacter.thumbnail.extension}',
                        placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      relatedCharacter.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
