class User {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatar;

  User({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}