// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  String firstName;
  String lastName;
  String email;
  String password;
  String? imageURL;
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.imageURL,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'imageURL': imageURL,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      imageURL: map['imageURL'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
