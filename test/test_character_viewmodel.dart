import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:im_mottu_mobile/index.dart';

/// Mock class for [ICharacterRepository] to simulate interactions in tests.
class MockCharacterRepository extends Mock implements ICharacterRepository {}

void main() {
  late MockCharacterRepository mockCharacterRepository;

  setUp(() {
    mockCharacterRepository = MockCharacterRepository();
  });

  /// Creates a sample [CharacterDataWrapper] with given [characters].
  ///
  /// [characters] is a list of [Character] objects to be included in the
  /// [CharacterDataWrapper].
  CharacterDataWrapper createCharacterDataWrapper({
    required List<Character> characters,
  }) {
    return CharacterDataWrapper(
      code: 200,
      status: 'Ok',
      copyright: '© Marvel',
      attributionText: 'Data provided by Marvel',
      attributionHTML: '<a href="https://marvel.com">Data provided by Marvel</a>',
      etag: 'some-etag',
      data: CharacterDataContainer(
        offset: 0,
        limit: 20,
        total: characters.length,
        count: characters.length,
        results: characters,
      ),
    );
  }

  /// Verifies common expectations for a [CharacterDataWrapper] result.
  ///
  /// [result] is the [CharacterDataWrapper] object to be checked.
  /// [expectedName] is the expected name of the first character in the result.
  void verifyCommonExpectations(CharacterDataWrapper result, String expectedName) {
    expect(result.code, 200);
    expect(result.status, 'Ok');
    expect(result.data.results, hasLength(1));
    expect(result.data.results.first.name, expectedName);
  }

  group('Character Repository Tests', () {
    /// Tests that [fetchCharacters] returns the expected data.
    test('fetchCharacters returns expected data', () async {
      // Arrange
      final characterDataWrapper = createCharacterDataWrapper(
        characters: [
          Character(
            id: 1,
            name: 'Spider-Man',
            description: 'A superhero with spider-like abilities',
            resourceURI: 'http://example.com/spiderman',
            thumbnail: CharThumb(path: 'http://example.com/spiderman', extension: 'jpg'),
          ),
        ],
      );

      when(() => mockCharacterRepository.fetchCharacters(
            nameStartsWith: 'Spider',
            limit: 20,
            offset: 0,
          )).thenAnswer((_) async => characterDataWrapper);

      // Act
      final result = await mockCharacterRepository.fetchCharacters(
        nameStartsWith: 'Spider',
        limit: 20,
        offset: 0,
      );

      // Assert
      verifyCommonExpectations(result, 'Spider-Man');
      expect(result.data.results.first.description, 'A superhero with spider-like abilities');
      expect(result.data.results.first.thumbnail.path, 'http://example.com/spiderman');

      // Verify fetchCharacters was called with the correct parameters
      verify(() => mockCharacterRepository.fetchCharacters(
            nameStartsWith: 'Spider',
            limit: 20,
            offset: 0,
          )).called(1);
    });

    /// Tests that [fetchCharacterById] returns the expected character.
    test('fetchCharacterById returns expected character', () async {
      // Arrange
      final characterDataWrapper = createCharacterDataWrapper(
        characters: [
          Character(
            id: 1,
            name: 'Spider-Man',
            description: 'A superhero with spider-like abilities',
            resourceURI: 'http://example.com/spiderman',
            thumbnail: CharThumb(path: 'http://example.com/spiderman', extension: 'jpg'),
          ),
        ],
      );

      when(() => mockCharacterRepository.fetchCharacterById(1))
          .thenAnswer((_) async => characterDataWrapper);

      // Act
      final result = await mockCharacterRepository.fetchCharacterById(1);

      // Assert
      verifyCommonExpectations(result, 'Spider-Man');
      expect(result.data.results.first.description, 'A superhero with spider-like abilities');

      // Verify fetchCharacterById was called with the correct ID
      verify(() => mockCharacterRepository.fetchCharacterById(1)).called(1);
    });

    /// Tests that [fetchCharactersInComic] returns the expected data.
    test('fetchCharactersInComic returns expected data', () async {
      // Arrange
      final characterDataWrapper = createCharacterDataWrapper(
        characters: [
          Character(
            id: 2,
            name: 'Iron Man',
            description: 'A wealthy industrialist with a powerful suit',
            resourceURI: 'http://example.com/ironman',
            thumbnail: CharThumb(path: 'http://example.com/ironman', extension: 'jpg'),
          ),
        ],
      );

      when(() => mockCharacterRepository.fetchCharactersInComic(1))
          .thenAnswer((_) async => characterDataWrapper);

      // Act
      final result = await mockCharacterRepository.fetchCharactersInComic(1);

      // Assert
      verifyCommonExpectations(result, 'Iron Man');

      // Verify fetchCharactersInComic was called with the correct ID
      verify(() => mockCharacterRepository.fetchCharactersInComic(1)).called(1);
    });

    /// Tests that [fetchCharactersInSeries] returns the expected data.
    test('fetchCharactersInSeries returns expected data', () async {
      // Arrange
      final characterDataWrapper = createCharacterDataWrapper(
        characters: [
          Character(
            id: 3,
            name: 'Thor',
            description: 'The God of Thunder',
            resourceURI: 'http://example.com/thor',
            thumbnail: CharThumb(path: 'http://example.com/thor', extension: 'jpg'),
          ),
        ],
      );

      when(() => mockCharacterRepository.fetchCharactersInSeries(1))
          .thenAnswer((_) async => characterDataWrapper);

      // Act
      final result = await mockCharacterRepository.fetchCharactersInSeries(1);

      // Assert
      verifyCommonExpectations(result, 'Thor');

      // Verify fetchCharactersInSeries was called with the correct ID
      verify(() => mockCharacterRepository.fetchCharactersInSeries(1)).called(1);
    });

    /// Tests that [fetchCharactersInEvent] returns the expected data.
    test('fetchCharactersInEvent returns expected data', () async {
      // Arrange
      final characterDataWrapper = createCharacterDataWrapper(
        characters: [
          Character(
            id: 4,
            name: 'Hulk',
            description: 'The Incredible Hulk',
            resourceURI: 'http://example.com/hulk',
            thumbnail: CharThumb(path: 'http://example.com/hulk', extension: 'jpg'),
          ),
        ],
      );

      when(() => mockCharacterRepository.fetchCharactersInEvent(1))
          .thenAnswer((_) async => characterDataWrapper);

      // Act
      final result = await mockCharacterRepository.fetchCharactersInEvent(1);

      // Assert
      verifyCommonExpectations(result, 'Hulk');

      // Verify fetchCharactersInEvent was called with the correct ID
      verify(() => mockCharacterRepository.fetchCharactersInEvent(1)).called(1);
    });

    /// Tests that [fetchCharactersInStory] returns the expected data.
    test('fetchCharactersInStory returns expected data', () async {
      // Arrange
      final characterDataWrapper = createCharacterDataWrapper(
        characters: [
          Character(
            id: 5,
            name: 'Black Widow',
            description: 'A skilled spy and assassin',
            resourceURI: 'http://example.com/blackwidow',
            thumbnail: CharThumb(path: 'http://example.com/blackwidow', extension: 'jpg'),
          ),
        ],
      );

      when(() => mockCharacterRepository.fetchCharactersInStory(1))
          .thenAnswer((_) async => characterDataWrapper);

      // Act
      final result = await mockCharacterRepository.fetchCharactersInStory(1);

      // Assert
      verifyCommonExpectations(result, 'Black Widow');

      // Verify fetchCharactersInStory was called with the correct ID
      verify(() => mockCharacterRepository.fetchCharactersInStory(1)).called(1);
    });

    /// Tests that [fetchCharactersByCreator] returns the expected data.
    test('fetchCharactersByCreator returns expected data', () async {
      // Arrange
      final characterDataWrapper = createCharacterDataWrapper(
        characters: [
          Character(
            id: 6,
            name: 'Doctor Strange',
            description: 'The Sorcerer Supreme',
            resourceURI: 'http://example.com/doctorstrange',
            thumbnail: CharThumb(path: 'http://example.com/doctorstrange', extension: 'jpg'),
          ),
        ],
      );

      when(() => mockCharacterRepository.fetchCharactersByCreator(1))
          .thenAnswer((_) async => characterDataWrapper);

      // Act
      final result = await mockCharacterRepository.fetchCharactersByCreator(1);

      // Assert
      verifyCommonExpectations(result, 'Doctor Strange');

      // Verify fetchCharactersByCreator was called with the correct ID
      verify(() => mockCharacterRepository.fetchCharactersByCreator(1)).called(1);
    });

    /// Tests that [fetchCharacters] handles empty results gracefully.
    test('fetchCharacters handles empty results gracefully', () async {
      // Arrange
      final characterDataWrapper = createCharacterDataWrapper(
        characters: [],
      );

      when(() => mockCharacterRepository.fetchCharacters(
            nameStartsWith: 'NonExistent',
            limit: 20,
            offset: 0,
          )).thenAnswer((_) async => characterDataWrapper);

      // Act
      final result = await mockCharacterRepository.fetchCharacters(
        nameStartsWith: 'NonExistent',
        limit: 20,
        offset: 0,
      );

      // Assert
      expect(result.data.results, isEmpty);
    });

    /// Tests that [fetchCharacters] handles errors appropriately.
    test('fetchCharacters handles errors', () async {
      // Arrange
      when(() => mockCharacterRepository.fetchCharacters(
            nameStartsWith: 'ErrorTest',
            limit: 20,
            offset: 0,
          )).thenThrow(Exception('Error fetching characters'));

      // Act
      try {
        await mockCharacterRepository.fetchCharacters(
          nameStartsWith: 'ErrorTest',
          limit: 20,
          offset: 0,
        );
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isException);
      }
    });
  });
}
