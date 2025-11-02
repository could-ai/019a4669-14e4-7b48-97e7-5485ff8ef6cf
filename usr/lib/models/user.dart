class User {
  final int id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? profilePhotoUrl;

  User({
    required this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.bio,
    this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      bio: json['bio'],
      profilePhotoUrl: json['profile_photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'bio': bio,
      'profile_photo_url': profilePhotoUrl,
    };
  }
}