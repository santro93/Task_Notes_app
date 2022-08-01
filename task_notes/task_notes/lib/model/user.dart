import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String email;
  final String password;

  const User({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
      };

  static User fromJson(DocumentSnapshot<Object?> doc) {
    return User(
        email: doc["email"],
        username: doc["username"],
        password: doc["password"]);
  }
}
