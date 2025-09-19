class MovieItem {
  final String id;
  final String title;
  final String description;
  final String? posterUrl;
  bool? isFavorite;

  MovieItem({
    required this.id,
    required this.title,
    required this.description,
    this.posterUrl,
    this.isFavorite,
  });

  factory MovieItem.fromJson(Map<String, dynamic> json) {
    return MovieItem(
      id: json['id']?.toString() ?? '',
      title: json['Title'] ?? '',
      description: json['Plot'] ?? '',
      posterUrl: json['Poster'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'posterUrl': posterUrl,
    };
  }

  MovieItem copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    bool? isFavorite,
  }) {
    return MovieItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}