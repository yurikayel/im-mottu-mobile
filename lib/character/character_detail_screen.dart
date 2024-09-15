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
  final Character character;

  /// The view model that provides data for this screen, including related characters.
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
      appBar: AppBar(
        title: Text(widget.character.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 32.0 : 16.0),
        child: ListView(
          children: [
            _buildCharacterImage(thumbnailUrl),
            const SizedBox(height: 16),
            _buildCharacterName(context, isLargeScreen),
            const SizedBox(height: 8),
            _buildCharacterDescription(context, isLargeScreen),
            const SizedBox(height: 16),
            _buildRelatedCharacters(context),
          ],
        ),
      ),
    );
  }

  /// Builds the character's image section.
  ///
  /// Displays the character's thumbnail. Uses [FutureBuilder] to handle loading, error, and data states.
  Widget _buildCharacterImage(String thumbnailUrl) => FutureBuilder<Image>(
        future: ImageCacheManager.getImage(thumbnailUrl),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? _buildLoadingIndicator()
                : snapshot.hasError
                    ? _buildErrorIcon()
                    : snapshot.hasData
                        ? snapshot.data!
                        : _buildErrorIcon(),
      );

  /// Builds the loading indicator widget.
  ///
  /// This widget is shown while the image is being fetched.
  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Builds the error icon widget.
  ///
  /// This widget is shown if there is an error loading the image.
  Widget _buildErrorIcon() {
    return const Center(child: Icon(Icons.error));
  }

  /// Builds the character's name section.
  ///
  /// Displays the character's name with responsive font size based on screen width.
  Widget _buildCharacterName(BuildContext context, bool isLargeScreen) {
    return Text(
      widget.character.name,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: isLargeScreen ? 36.0 : 24.0,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  /// Builds the character's description section.
  ///
  /// Displays the character's description or a placeholder text if no description is available.
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
              childAspectRatio: 1 / 2, // Adjust as needed
            ),
            itemCount: relatedCharacters.length,
            itemBuilder: (context, index) {
              final relatedCharacter = relatedCharacters[index];
              return GridTile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FutureBuilder<Image>(
                        future: ImageCacheManager.getImage(
                          '${relatedCharacter.thumbnail.path}.${relatedCharacter.thumbnail.extension}',
                        ),
                        builder: (context, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? _buildLoadingIndicator()
                              : snapshot.hasError
                                  ? _buildErrorIcon()
                                  : snapshot.hasData
                                      ? snapshot.data!
                                      : _buildErrorIcon();
                        },
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
