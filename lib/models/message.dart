// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/constant.dart';

class Message {
  String userId;
  DateTime createdAt;
  String text;
  String userImageURL;
  String type;
  Message({
    required this.userId,
    required this.createdAt,
    required this.text,
    required this.userImageURL,
    this.type = 'text',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'createdAt': createdAt,
      'text': text,
      'userImageURL': userImageURL,
      'type': type
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      userId: map['userId'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      text: map['text'] as String,
      userImageURL: map['userImageURL'] as String,
      type: map['type'] as String,
    );
  }

  factory Message.fromDocToMessage(
      QueryDocumentSnapshot<Map<String, dynamic>> map) {
    return Message(
      userId: map['userId'] as String,
      createdAt: (map['createdAt']
              as Timestamp) //use this way to convert Timestamp to Datetime object
          .toDate(), //by default, Firestore will convert Datetime object and store as TimeStamp
      text: map['text'] as String,
      userImageURL: map['userImageURL'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  // factory Message.fromJson(String source) =>
  //     Message.fromMap(json.decode(source) as Map<String, dynamic>);

}
