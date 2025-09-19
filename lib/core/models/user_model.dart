class User {
  final String? id;
  final String email;
  final String name;
  final String? token;
  String? photoUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.token,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? null,
      email: json['email'] ?? null,
      name: json['name'] ?? json['username'] ?? null,
      token: json['token'] ?? null,
      photoUrl: json['photoUrl'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'photoUrl': photoUrl,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}