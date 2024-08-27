import 'package:im_mottu_mobile/index.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  _CharacterListScreenState createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final MarvelService _apiService = MarvelService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _offset = 0;
  final int _limit = 20;
  bool _isLoading = false;
  final List<Character> _characters = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  void _fetchCharacters() {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    _apiService
        .fetchCharacters(
      nameStartsWith: _searchQuery,
      limit: _limit,
      offset: _offset,
    )
        .then((data) {
      setState(() {
        _characters.addAll(data.data.results);
        _offset += _limit;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = _searchController.text;
        _offset = 0;
        _characters.clear();
        _fetchCharacters();
      });
    });
  }

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
                  searchController: _searchController,
                  onSearchChanged: _onSearchChanged,
                ),
              );
            },
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchCharacters();
            return true;
          }
          return false;
        },
        child: _characters.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio:
                      MediaQuery.of(context).size.width > 600 ? 0.6 : 0.8,
                ),
                itemCount: _characters.length,
                itemBuilder: (context, index) {
                  final character = _characters[index];
                  return CharacterGridItem(character: character);
                },
              ),
      ),
    );
  }
}

class CharacterSearchDelegate extends SearchDelegate<String> {
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;

  CharacterSearchDelegate({
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = <String>[]; // Populate with actual suggestions
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            searchController.text = suggestion;
            query = suggestion;
            onSearchChanged();
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearchChanged();
    return Container(); // Placeholder
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          searchController.clear();
          query = '';
          onSearchChanged();
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
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
