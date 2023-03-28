import 'package:chat_app/chat/message_bubble.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as au;
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  au.User? _currentUser;
  late FirebaseFirestore _firestore;
  @override
  void initState() {
    _firestore = FirebaseFirestore.instance;
    _currentUser = au.FirebaseAuth.instance.currentUser;
    super.initState();
  }

  Future<void> _syncUserImagetoMessages() async {
    try {
      final userInfo =
          await _firestore.collection('users').doc(_currentUser?.uid).get();
      await _firestore
          .collection('chat')
          .where('userId', isEqualTo: _currentUser?.uid)
          .get()
          .then((value) {
        value.docs.forEach((item) async {
          try {
            if (userInfo['imageURL'] != null) {
              await item.reference.set({'userImageURL': userInfo['imageURL']},
                  SetOptions(merge: true));
            }
            print('Update user messages');
          } catch (e) {
            print(e.toString());
            return;
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _syncUserImagetoMessages(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
          StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
              reverse: true,
              itemCount: docs.length,
              itemBuilder: ((context, index) {
                return MessageBubble(
                  key: ValueKey(docs[index][
                      'userId']), //add key to make sure that the message is unique
                  message: Message.fromDocToMessage(docs[index]),
                  isCurrentUser: _currentUser!.uid == docs[index]['userId'],
                );
              }));
        },
      ),
    );
  }
}
