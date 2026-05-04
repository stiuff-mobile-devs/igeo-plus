import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email
  });

  factory User.fromFirebaseUser(fb_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
    );
  }

  factory User.fromJson(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      email: map['email'],
      name: map['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "name": name,
    };
  }
}