class Profile {
  final int id;
  final String username;
  final String email;

  const Profile({
    required this.id,
    required this.username,
    required this.email,
  });

  factory Profile.fromJsonObject(Map<String, dynamic> jsonObject) {
    return Profile(
      id: jsonObject['id'],
      username: jsonObject['username'],
      email: jsonObject['email'],
    );
  }
}