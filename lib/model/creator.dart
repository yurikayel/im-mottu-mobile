class CreatorDataWrapper {
  final int code;
  final String status;
  final String? copyright;
  final String? attributionText;
  final String? attributionHTML;
  final String? etag;
  final CreatorDataContainer data;

  CreatorDataWrapper({
    required this.code,
    required this.status,
    this.copyright,
    this.attributionText,
    this.attributionHTML,
    this.etag,
    required this.data,
  });

  factory CreatorDataWrapper.fromJson(Map<String, dynamic> json) {
    return CreatorDataWrapper(
      code: json['code'] as int,
      status: json['status'] as String,
      copyright: json['copyright'] as String?,
      attributionText: json['attributionText'] as String?,
      attributionHTML: json['attributionHTML'] as String?,
      etag: json['etag'] as String?,
      data: CreatorDataContainer.fromJson(json['data'] as Map<String, dynamic>),
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

class CreatorDataContainer {
  final int offset;
  final int limit;
  final int total;
  final int count;
  final List<Creator> results;

  CreatorDataContainer({
    required this.offset,
    required this.limit,
    required this.total,
    required this.count,
    required this.results,
  });

  factory CreatorDataContainer.fromJson(Map<String, dynamic> json) {
    return CreatorDataContainer(
      offset: json['offset'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      count: json['count'] as int,
      results: (json['results'] as List<dynamic>)
          .map((item) => Creator.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'limit': limit,
      'total': total,
      'count': count,
      'results': results.map((creator) => creator.toJson()).toList(),
    };
  }
}

class Creator {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String suffix;
  final String fullName;
  final DateTime modified;
  final String resourceURI;
  final List<Url> urls;
  final CreatorThumb thumbnail;

  Creator({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.suffix,
    required this.fullName,
    required this.modified,
    required this.resourceURI,
    required this.urls,
    required this.thumbnail,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String,
      lastName: json['lastName'] as String,
      suffix: json['suffix'] as String,
      fullName: json['fullName'] as String,
      modified: DateTime.parse(json['modified'] as String),
      resourceURI: json['resourceURI'] as String,
      urls: (json['urls'] as List<dynamic>)
          .map((item) => Url.fromJson(item as Map<String, dynamic>))
          .toList(),
      thumbnail: CreatorThumb.fromJson(json['thumbnail'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'suffix': suffix,
      'fullName': fullName,
      'modified': modified.toIso8601String(),
      'resourceURI': resourceURI,
      'urls': urls.map((url) => url.toJson()).toList(),
      'thumbnail': thumbnail.toJson(),
    };
  }
}

class Url {
  final String type;
  final String url;

  Url({
    required this.type,
    required this.url,
  });

  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
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

class CreatorThumb {
  final String path;
  final String extension;

  CreatorThumb({
    required this.path,
    required this.extension,
  });

  factory CreatorThumb.fromJson(Map<String, dynamic> json) {
    return CreatorThumb(
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
