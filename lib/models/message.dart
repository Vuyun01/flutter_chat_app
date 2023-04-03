// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String idFrom;
  String idTo;
  DateTime createdAt;
  String content;
  String? imageURL;
  String type;
  Message({
    required this.idFrom,
    required this.idTo,
    required this.createdAt,
    required this.content,
    this.imageURL,
    this.type = 'text',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idFrom': idFrom,
      'idTo': idTo,
      'createdAt': Timestamp.fromDate(createdAt),
      'content': content,
      'imageURL': imageURL ?? placeholderImage,
      'type': type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      idFrom: map['idFrom'] as String,
      idTo: map['idTo'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      content: map['content'] as String,
      imageURL: map['imageURL'] ?? placeholderImage,
      type: map['type'] as String,
    );
  }

  factory Message.fromDocToMessage(
      QueryDocumentSnapshot<Map<String, dynamic>> map) {
    return Message(
      idFrom: map['idFrom'] as String,
      idTo: map['idTo'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      content: map['content'] as String,
      imageURL: map['imageURL'] ?? placeholderImage,
      type: map['type'] as String,
    );
  }
}
