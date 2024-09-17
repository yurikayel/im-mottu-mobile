import 'package:im_mottu_mobile/index.dart';

/// A screen displaying the details of a [Character] including its name, description, and related characters.
///
/// The `CharacterDetailScreen` fetches and displays detailed information about a character.
/// It also displays related characters in a grid view and manages loading and error states.
///
/// The screen layout adjusts based on the width of the device, providing a responsive experience for both tablets and phones.
///
/// Example usage:
/// ```dart
/// CharacterDetailScreen(
///   character: myCharacter,
///   characterViewModel: myViewModel,
/// )
/// ```
class CharacterDetailScreen extends StatefulWidget {
  /// Creates a `CharacterDetailScreen` widget.
  ///
  /// * [character]: The [Character] whose details are to be displayed. This is a required parameter.
  /// * [characterViewModel]: The view model that manages the character data and related characters. This is a required parameter.
  const CharacterDetailScreen({
    super.key,
    required this.character,
    required this.characterViewModel,
  });

  /// The [Character] whose details are displayed on this screen.
  ///
  /// This [Character] instance provides information such as the character's name, description, and thumbnail image.
  final Character character;

  /// The view model that provides data for this screen, including related characters.
  ///
  /// This [CharacterViewModel] instance is responsible for managing and providing data about related characters.
  final CharacterViewModel characterViewModel;

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500.0, // Height of the app bar when expanded
            flexibleSpace: FlexibleSpaceBar(
              background: MarvelImage(
                thumbnailUrl,
                fit: BoxFit.cover,
              ),
              title: Text(
                widget.character.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: isLargeScreen ? 36.0 : 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Main text color
                  shadows: [
                    const Shadow(
                      color: Colors.white,
                      offset: Offset(1, 1),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.only(bottom: 12),
              centerTitle: true,
              expandedTitleScale: 2,
            ),
            pinned: true,
            floating: false,
            stretch: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(isLargeScreen ? 32.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCharacterDescription(context, isLargeScreen),
                      const SizedBox(height: 16),
                      _buildRelatedCharacters(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the character's description section.
  ///
  /// Displays the character's description or a placeholder text if no description is available.
  ///
  /// * [context]: The build context used to retrieve theme data.
  /// * [isLargeScreen]: A boolean value indicating if the screen width is large (tablet or desktop).
  ///
  /// Returns a [Text] widget displaying the character's description.
  Widget _buildCharacterDescription(BuildContext context, bool isLargeScreen) {
    return Text(
      widget.character.description.isNotEmpty
          ? widget.character.description
          : 'No description available',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: isLargeScreen ? 20.0 : 16.0,
          ),
    );
  }

  /// Builds the related characters grid view.
  ///
  /// Displays related characters in a grid format. The grid adjusts the number of columns
  /// based on the screen width.
  ///
  /// * [context]: The build context used to retrieve theme data and screen width.
  ///
  /// Returns a [Column] widget containing a [Text] widget for the section title and a [GridView.builder]
  /// widget for the related characters.
  Widget _buildRelatedCharacters(BuildContext context) {
    return Obx(() {
      final relatedCharacters = widget.characterViewModel.relatedCharacters;

      if (relatedCharacters.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // Sort related characters alphabetically by name
      relatedCharacters.sort((a, b) => a.name.compareTo(b.name));

      final screenWidth = MediaQuery.of(context).size.width;
      final crossAxisCount = screenWidth > 800
          ? 6
          : screenWidth > 500
              ? 4
              : 2;
      final childAspectRatio = screenWidth > 800 ? 1 / 1.2 : 1 / 1.7;

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
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: relatedCharacters.length,
            itemBuilder: (context, index) {
              final relatedCharacter = relatedCharacters[index];

              return GridTile(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(64.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MarvelImage(
                              '${relatedCharacter.thumbnail.path}.${relatedCharacter.thumbnail.extension}',
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(
                              0.8), // Semi-transparent black background
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            relatedCharacter.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors
                                      .white, // Text color to contrast with the black background
                                  fontSize: 14.0,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
