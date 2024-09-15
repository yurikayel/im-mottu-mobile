import 'package:im_mottu_mobile/index.dart';

/// A screen displaying a list of characters with search functionality.
///
/// The `CharacterListScreen` provides a grid view of characters and allows users to search
/// for specific characters. It handles loading more characters as the user scrolls and
/// displays a search bar for filtering characters based on the search query.
///
/// Example usage:
/// ```dart
/// CharacterListScreen(
///   characterViewModel: myCharacterViewModel,
/// )
/// ```
class CharacterListScreen extends StatelessWidget {
  /// Creates a `CharacterListScreen` widget.
  ///
  /// * [characterViewModel]: The view model that manages the characters list and search functionality.
  const CharacterListScreen({super.key, required this.characterViewModel});

  /// The view model responsible for managing character data and search functionality.
  final CharacterViewModel characterViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () {
            final query = characterViewModel.searchQuery.value;
            return Center(
              child: Text(
                query.isNotEmpty
                    ? 'Search results for "$query"'
                    : 'Marvel Characters',
              ),
            );
          },
        ),
        actions: [
          Obx(
            () => characterViewModel.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // Clear search query and reload default character list
                      characterViewModel.onSearchChanged('');
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CharacterSearchDelegate(
                          onSearchQueryChanged:
                              characterViewModel.onSearchChanged,
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
            if (!characterViewModel.isLoading.value &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              characterViewModel.fetchCharacters();
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
                    itemCount: characterViewModel.characters.length,
                    itemBuilder: (context, index) {
                      final character = characterViewModel.characters[index];
                      return CharacterGridItem(
                        character: character,
                        characterViewModel: characterViewModel,
                      );
                    },
                  ),
                ),
              ),
              if (characterViewModel.isLoading.value)
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

/// A search delegate for searching characters.
///
/// The `CharacterSearchDelegate` provides a search interface for filtering characters based on the search query.
/// It handles suggestions, results, and clearing the search query.
///
/// Example usage:
/// ```dart
/// showSearch(
///   context: context,
///   delegate: CharacterSearchDelegate(
///     onSearchQueryChanged: (query) {
///       // Handle search query change
///     },
///   ),
/// );
/// ```
class CharacterSearchDelegate extends SearchDelegate<String> {
  /// Creates a `CharacterSearchDelegate`.
  ///
  /// * [onSearchQueryChanged]: Callback function to handle changes in the search query.
  CharacterSearchDelegate({
    required this.onSearchQueryChanged,
  });

  /// Callback function to handle changes in the search query.
  final void Function(String query) onSearchQueryChanged;

  @override
  Widget buildSuggestions(BuildContext context) {
    // Provide actual suggestions if needed
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
            close(context, 'close'); // Dismiss search when query is empty
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

/// A grid item widget that displays a character's information.
///
/// The `CharacterGridItem` displays a character's image and name in a grid format.
/// Tapping on the item navigates to the `CharacterDetailScreen` for more details.
///
/// The image of the character is loaded using [MarvelImage], which handles caching
/// and display.
///
/// * [character]: The character to be displayed in the grid item.
/// * [characterViewModel]: The view model used for navigating to the detail screen.
///
/// Example usage:
/// ```dart
/// CharacterGridItem(
///   character: character,
///   characterViewModel: characterViewModel,
/// )
/// ```
class CharacterGridItem extends StatelessWidget {
  /// Creates a `CharacterGridItem`.
  ///
  /// * [character]: The character to be displayed in the grid item.
  /// * [characterViewModel]: The view model for navigating to the detail screen.
  const CharacterGridItem({
    super.key,
    required this.character,
    required this.characterViewModel,
  });

  /// The character to be displayed in the grid item.
  final Character character;

  /// The view model used for navigating to the detail screen.
  final CharacterViewModel characterViewModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterDetailScreen(
              character: character,
              characterViewModel: characterViewModel,
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
                child: MarvelImage(
                  '${character.thumbnail.path}.${character.thumbnail.extension}',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                character.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
