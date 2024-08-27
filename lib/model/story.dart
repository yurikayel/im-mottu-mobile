class StoryDataWrapper {
  final int code;
  final String status;
  final String? copyright;
  final String? attributionText;
  final String? attributionHTML;
  final String? etag;
  final StoryDataContainer data;

  StoryDataWrapper({
    required this.code,
    required this.status,
    this.copyright,
    this.attributionText,
    this.attributionHTML,
    this.etag,
    required this.data,
  });

  factory StoryDataWrapper.fromJson(Map<String, dynamic> json) {
    return StoryDataWrapper(
      code: json['code'] as int,
      status: json['status'] as String,
      copyright: json['copyright'] as String?,
      attributionText: json['attributionText'] as String?,
      attributionHTML: json['attributionHTML'] as String?,
      etag: json['etag'] as String?,
      data: StoryDataContainer.fromJson(json['data'] as Map<String, dynamic>),
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

class StoryDataContainer {
  final int offset;
  final int limit;
  final int total;
  final int count;
  final List<Story> results;

  StoryDataContainer({
    required this.offset,
    required this.limit,
    required this.total,
    required this.count,
    required this.results,
  });

  factory StoryDataContainer.fromJson(Map<String, dynamic> json) {
    return StoryDataContainer(
      offset: json['offset'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      count: json['count'] as int,
      results: (json['results'] as List<dynamic>)
          .map((item) => Story.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'limit': limit,
      'total': total,
      'count': count,
      'results': results.map((story) => story.toJson()).toList(),
    };
  }
}

class Story {
  final int id;
  final String title;
  final String description;
  final String resourceURI;
  final String type;
  final DateTime modified;
  final SeriesSummary series;
  final ComicSummary originalIssue;
  final StoryThumb thumbnail;

  Story({
    required this.id,
    required this.title,
    required this.description,
    required this.resourceURI,
    required this.type,
    required this.modified,
    required this.series,
    required this.originalIssue,
    required this.thumbnail,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      resourceURI: json['resourceURI'] as String,
      type: json['type'] as String,
      modified: DateTime.parse(json['modified'] as String),
      series: SeriesSummary.fromJson(json['series'] as Map<String, dynamic>),
      originalIssue: ComicSummary.fromJson(json['originalIssue'] as Map<String, dynamic>),
      thumbnail: StoryThumb.fromJson(json['thumbnail'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'resourceURI': resourceURI,
      'type': type,
      'modified': modified.toIso8601String(),
      'series': series.toJson(),
      'originalIssue': originalIssue.toJson(),
      'thumbnail': thumbnail.toJson(),
    };
  }
}

class SeriesSummary {
  final String resourceURI;
  final String name;

  SeriesSummary({
    required this.resourceURI,
    required this.name,
  });

  factory SeriesSummary.fromJson(Map<String, dynamic> json) {
    return SeriesSummary(
      resourceURI: json['resourceURI'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resourceURI': resourceURI,
      'name': name,
    };
  }
}

class ComicSummary {
  final String resourceURI;
  final String name;

  ComicSummary({
    required this.resourceURI,
    required this.name,
  });

  factory ComicSummary.fromJson(Map<String, dynamic> json) {
    return ComicSummary(
      resourceURI: json['resourceURI'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resourceURI': resourceURI,
      'name': name,
    };
  }
}

class StoryThumb {
  final String path;
  final String extension;

  StoryThumb({
    required this.path,
    required this.extension,
  });

  factory StoryThumb.fromJson(Map<String, dynamic> json) {
    return StoryThumb(
      path: json['path'] as String,
      extension: json['extension'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'extension': extension,
    };
  }
}
