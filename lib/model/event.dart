class EventDataWrapper {
  final int code;
  final String status;
  final String? copyright;
  final String? attributionText;
  final String? attributionHTML;
  final String? etag;
  final EventDataContainer data;

  EventDataWrapper({
    required this.code,
    required this.status,
    this.copyright,
    this.attributionText,
    this.attributionHTML,
    this.etag,
    required this.data,
  });

  factory EventDataWrapper.fromJson(Map<String, dynamic> json) {
    return EventDataWrapper(
      code: json['code'] as int,
      status: json['status'] as String,
      copyright: json['copyright'] as String?,
      attributionText: json['attributionText'] as String?,
      attributionHTML: json['attributionHTML'] as String?,
      etag: json['etag'] as String?,
      data: EventDataContainer.fromJson(json['data'] as Map<String, dynamic>),
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

class EventDataContainer {
  final int offset;
  final int limit;
  final int total;
  final int count;
  final List<Event> results;

  EventDataContainer({
    required this.offset,
    required this.limit,
    required this.total,
    required this.count,
    required this.results,
  });

  factory EventDataContainer.fromJson(Map<String, dynamic> json) {
    return EventDataContainer(
      offset: json['offset'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      count: json['count'] as int,
      results: (json['results'] as List<dynamic>)
          .map((item) => Event.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'limit': limit,
      'total': total,
      'count': count,
      'results': results.map((event) => event.toJson()).toList(),
    };
  }
}

class Event {
  final int id;
  final String title;
  final String description;
  final String resourceURI;
  final List<EventUrl> urls;
  final DateTime modified;
  final DateTime? start;
  final DateTime? end;
  final EventThumb thumbnail;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.resourceURI,
    required this.urls,
    required this.modified,
    this.start,
    this.end,
    required this.thumbnail,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      resourceURI: json['resourceURI'] as String,
      urls: (json['urls'] as List<dynamic>)
          .map((item) => EventUrl.fromJson(item as Map<String, dynamic>))
          .toList(),
      modified: DateTime.parse(json['modified'] as String),
      start: json['start'] != null ? DateTime.parse(json['start'] as String) : null,
      end: json['end'] != null ? DateTime.parse(json['end'] as String) : null,
      thumbnail: EventThumb.fromJson(json['thumbnail'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'resourceURI': resourceURI,
      'urls': urls.map((url) => url.toJson()).toList(),
      'modified': modified.toIso8601String(),
      'start': start?.toIso8601String(),
      'end': end?.toIso8601String(),
      'thumbnail': thumbnail.toJson(),
    };
  }
}

class EventUrl {
  final String type;
  final String url;

  EventUrl({
    required this.type,
    required this.url,
  });

  factory EventUrl.fromJson(Map<String, dynamic> json) {
    return EventUrl(
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

class EventThumb {
  final String path;
  final String extension;

  EventThumb({
    required this.path,
    required this.extension,
  });

  factory EventThumb.fromJson(Map<String, dynamic> json) {
    return EventThumb(
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
