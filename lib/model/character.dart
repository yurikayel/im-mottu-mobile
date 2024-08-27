class CharacterDataWrapper {
  final int code;
  final String status;
  final String copyright;
  final String attributionText;
  final String attributionHTML;
  final String etag;
  final CharacterDataContainer data;

  CharacterDataWrapper({
    required this.code,
    required this.status,
    required this.copyright,
    required this.attributionText,
    required this.attributionHTML,
    required this.etag,
    required this.data,
  });

  factory CharacterDataWrapper.fromJson(Map<String, dynamic> json) {
    return CharacterDataWrapper(
      code: json['code'],
      status: json['status'],
      copyright: json['copyright'],
      attributionText: json['attributionText'],
      attributionHTML: json['attributionHTML'],
      etag: json['etag'],
      data: CharacterDataContainer.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'copyright': copyright,
      'attributionText': attributionText,
      'attributionHTML': attributionHTML,
      'etag': etag,
      'data': data.toJson(),
    };
  }
}

class CharacterDataContainer {
  final int offset;
  final int limit;
  final int total;
  final int count;
  final List<Character> results;

  CharacterDataContainer({
    required this.offset,
    required this.limit,
    required this.total,
    required this.count,
    required this.results,
  });

  factory CharacterDataContainer.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Character> characterList = list.map((i) => Character.fromJson(i)).toList();

    return CharacterDataContainer(
      offset: json['offset'],
      limit: json['limit'],
      total: json['total'],
      count: json['count'],
      results: characterList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'limit': limit,
      'total': total,
      'count': count,
      'results': results.map((character) => character.toJson()).toList(),
    };
  }
}

class Character {
  final int id;
  final String name;
  final String description;
  final String resourceURI;
  final CharThumb thumbnail;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.resourceURI,
    required this.thumbnail,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      resourceURI: json['resourceURI'],
      thumbnail: CharThumb.fromJson(json['thumbnail']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'resourceURI': resourceURI,
      'thumbnail': thumbnail.toJson(),
    };
  }
}

class CharThumb {
  final String path;
  final String extension;

  CharThumb({
    required this.path,
    required this.extension,
  });

  factory CharThumb.fromJson(Map<String, dynamic> json) {
    return CharThumb(
      path: json['path'],
      extension: json['extension'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'extension': extension,
    };
  }
}
