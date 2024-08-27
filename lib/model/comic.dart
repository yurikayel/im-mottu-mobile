class ComicDataWrapper {
  final int code;
  final String status;
  final String? copyright;
  final String? attributionText;
  final String? attributionHTML;
  final String? etag;
  final ComicDataContainer data;

  ComicDataWrapper({
    required this.code,
    required this.status,
    this.copyright,
    this.attributionText,
    this.attributionHTML,
    this.etag,
    required this.data,
  });

  factory ComicDataWrapper.fromJson(Map<String, dynamic> json) {
    return ComicDataWrapper(
      code: json['code'] as int,
      status: json['status'] as String,
      copyright: json['copyright'] as String?,
      attributionText: json['attributionText'] as String?,
      attributionHTML: json['attributionHTML'] as String?,
      etag: json['etag'] as String?,
      data: ComicDataContainer.fromJson(json['data'] as Map<String, dynamic>),
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

class ComicDataContainer {
  final int offset;
  final int limit;
  final int total;
  final int count;
  final List<Comic> results;

  ComicDataContainer({
    required this.offset,
    required this.limit,
    required this.total,
    required this.count,
    required this.results,
  });

  factory ComicDataContainer.fromJson(Map<String, dynamic> json) {
    return ComicDataContainer(
      offset: json['offset'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      count: json['count'] as int,
      results: (json['results'] as List<dynamic>)
          .map((item) => Comic.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'limit': limit,
      'total': total,
      'count': count,
      'results': results.map((comic) => comic.toJson()).toList(),
    };
  }
}

class Comic {
  final int id;
  final int digitalId;
  final String title;
  final int issueNumber;
  final String? variantDescription;
  final String description;
  final DateTime modified;
  final String? isbn;
  final String? upc;
  final String? diamondCode;
  final String? ean;
  final String? issn;
  final String? format;
  final int pageCount;
  final List<TextObject> textObjects;
  final String resourceURI;
  final List<ComicUrl> urls;

  Comic({
    required this.id,
    required this.digitalId,
    required this.title,
    required this.issueNumber,
    this.variantDescription,
    required this.description,
    required this.modified,
    this.isbn,
    this.upc,
    this.diamondCode,
    this.ean,
    this.issn,
    this.format,
    required this.pageCount,
    required this.textObjects,
    required this.resourceURI,
    required this.urls,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['id'] as int,
      digitalId: json['digitalId'] as int,
      title: json['title'] as String,
      issueNumber: json['issueNumber'] as int,
      variantDescription: json['variantDescription'] as String?,
      description: json['description'] as String,
      modified: DateTime.parse(json['modified'] as String),
      isbn: json['isbn'] as String?,
      upc: json['upc'] as String?,
      diamondCode: json['diamondCode'] as String?,
      ean: json['ean'] as String?,
      issn: json['issn'] as String?,
      format: json['format'] as String?,
      pageCount: json['pageCount'] as int,
      textObjects: (json['textObjects'] as List<dynamic>)
          .map((item) => TextObject.fromJson(item as Map<String, dynamic>))
          .toList(),
      resourceURI: json['resourceURI'] as String,
      urls: (json['urls'] as List<dynamic>)
          .map((item) => ComicUrl.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'digitalId': digitalId,
      'title': title,
      'issueNumber': issueNumber,
      'variantDescription': variantDescription,
      'description': description,
      'modified': modified.toIso8601String(),
      'isbn': isbn,
      'upc': upc,
      'diamondCode': diamondCode,
      'ean': ean,
      'issn': issn,
      'format': format,
      'pageCount': pageCount,
      'textObjects': textObjects.map((textObject) => textObject.toJson()).toList(),
      'resourceURI': resourceURI,
      'urls': urls.map((url) => url.toJson()).toList(),
    };
  }
}

class TextObject {
  final String type;
  final String language;
  final String text;

  TextObject({
    required this.type,
    required this.language,
    required this.text,
  });

  factory TextObject.fromJson(Map<String, dynamic> json) {
    return TextObject(
      type: json['type'] as String,
      language: json['language'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'language': language,
      'text': text,
    };
  }
}

class ComicUrl {
  final String type;
  final String url;

  ComicUrl({
    required this.type,
    required this.url,
  });

  factory ComicUrl.fromJson(Map<String, dynamic> json) {
    return ComicUrl(
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
