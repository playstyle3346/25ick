class User {
  final String email;
  final String nickname;
  final String? profileImage;

  User({
    required this.email,
    required this.nickname,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json["email"] ?? "",
      nickname: json["nickname"] ?? "익명",
      profileImage: json["profileImage"] ?? "",
    );
  }
}
