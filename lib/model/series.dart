class SeriesDataWrapper {
  final int code;
  final String status;
  final String? copyright;
  final String? attributionText;
  final String? attributionHTML;
  final String? etag;
  final SeriesDataContainer data;

  SeriesDataWrapper({
    required this.code,
    required this.status,
    this.copyright,
    this.attributionText,
    this.attributionHTML,
    this.etag,
    required this.data,
  });

  factory SeriesDataWrapper.fromJson(Map<String, dynamic> json) {
    return SeriesDataWrapper(
      code: json['code'] as int,
      status: json['status'] as String,
      copyright: json['copyright'] as String?,
      attributionText: json['attributionText'] as String?,
      attributionHTML: json['attributionHTML'] as String?,
      etag: json['etag'] as String?,
      data: SeriesDataContainer.fromJson(json['data'] as Map<String, dynamic>),
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

class SeriesDataContainer {
  final int offset;
  final int limit;
  final int total;
  final int count;
  final List<Series> results;

  SeriesDataContainer({
    required this.offset,
    required this.limit,
    required this.total,
    required this.count,
    required this.results,
  });

  factory SeriesDataContainer.fromJson(Map<String, dynamic> json) {
    return SeriesDataContainer(
      offset: json['offset'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      count: json['count'] as int,
      results: (json['results'] as List<dynamic>)
          .map((item) => Series.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'limit': limit,
      'total': total,
      'count': count,
      'results': results.map((series) => series.toJson()).toList(),
    };
  }
}

class Series {
  final int id;
  final String title;
  final String description;
  final String resourceURI;
  final List<SeriesUrl> urls;
  final int startYear;
  final int endYear;
  final String rating;
  final DateTime modified;
  final SeriesThumb thumbnail;

  Series({
    required this.id,
    required this.title,
    required this.description,
    required this.resourceURI,
    required this.urls,
    required this.startYear,
    required this.endYear,
    required this.rating,
    required this.modified,
    required this.thumbnail,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      resourceURI: json['resourceURI'] as String,
      urls: (json['urls'] as List<dynamic>)
          .map((item) => SeriesUrl.fromJson(item as Map<String, dynamic>))
          .toList(),
      startYear: json['startYear'] as int,
      endYear: json['endYear'] as int,
      rating: json['rating'] as String,
      modified: DateTime.parse(json['modified'] as String),
      thumbnail: SeriesThumb.fromJson(json['thumbnail'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'resourceURI': resourceURI,
      'urls': urls.map((url) => url.toJson()).toList(),
      'startYear': startYear,
      'endYear': endYear,
      'rating': rating,
      'modified': modified.toIso8601String(),
      'thumbnail': thumbnail.toJson(),
    };
  }
}

class SeriesUrl {
  final String type;
  final String url;

  SeriesUrl({
    required this.type,
    required this.url,
  });

  factory SeriesUrl.fromJson(Map<String, dynamic> json) {
    return SeriesUrl(
      type: json['type'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
    };
  }
}

class SeriesThumb {
  final String path;
  final String extension;

  SeriesThumb({
    required this.path,
    required this.extension,
  });

  factory SeriesThumb.fromJson(Map<String, dynamic> json) {
    return SeriesThumb(
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
