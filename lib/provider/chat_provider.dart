import 'package:chat_app/helper/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message.dart';

class ChatProvider {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  ChatProvider({
    required this.firebaseAuth,
    required this.firestore,
  });

  Future<void> sendMessage(String collectionPath, String? subcollectionpath,
      String groupId, Message message) async {
    await firestore
        .collection(collectionPath)
        .doc(groupId)
        .collection(subcollectionpath!)
        .doc(Timestamp.now().seconds.toString())
        .set(message.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatStreamData(
      String collectionPath, String? subcollectionPath, String groupId,
      [int limit = 20]) {
    return firestore
        .collection(collectionPath)
        .doc(groupId)
        .collection(subcollectionPath!)
        .orderBy(FireStoreHelper.createdAt, descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getChatDataBasedOnUserId(
      String collectionPath,
      String? subcollectionPath,
      String groupId,
      String userId) {
    return firestore
        .collection(collectionPath)
        .doc(groupId)
        .collection(subcollectionPath!)
        .where(FireStoreHelper.idFrom, isEqualTo: userId)
        .get();
  }

  bool isUser(String userId, String anotherId){
    if(userId == anotherId){
      return true;
    }
    return false;
  }
}
