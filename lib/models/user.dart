// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/constant.dart';

class User {
  String userId;
  String firstName;
  String lastName;
  String email;
  String password;
  String? imageURL;
  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.imageURL,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'imageURL': imageURL ?? placeholderImage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      imageURL: map['imageURL'] as String,
      userId: map['userId'] as String,
    );
  }

  factory User.fromDocToUser(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return User(
      userId: doc['userId'] as String,
      firstName: doc['firstName'] as String,
      lastName: doc['lastName'] as String,
      email: doc['email'] as String,
      password: doc['password'] as String,
      imageURL: doc['imageURL'] ?? placeholderImage,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
