import 'package:im_mottu_mobile/index.dart';

class CharacterListScreen extends StatelessWidget {
  final CharacterViewModel characterViewModel;

  const CharacterListScreen({super.key, required this.characterViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marvel Characters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CharacterSearchDelegate(
                  onSearchQueryChanged: characterViewModel.onSearchChanged,
                ),
              );
            },
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!characterViewModel.isLoading.value &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
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
                    return CharacterGridItem(character: character);
                  },
                ),
              ),
            ),
            Obx(
              () => characterViewModel.isLoading.value
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(64.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterSearchDelegate extends SearchDelegate<String> {
  final void Function(String query) onSearchQueryChanged;

  CharacterSearchDelegate({
    required this.onSearchQueryChanged,
  });

  @override
  Widget buildSuggestions(BuildContext context) {
    // You might want to provide actual suggestions here
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
          query = '';
          onSearchQueryChanged(query);
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

class CharacterGridItem extends StatelessWidget {
  final Character character;

  const CharacterGridItem({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterDetailScreen(
              character: character,
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
                  '${character.thumbnail.path}.${character.thumbnail.extension}',
                  fit: BoxFit.cover,
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
