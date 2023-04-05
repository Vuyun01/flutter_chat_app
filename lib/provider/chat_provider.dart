import 'package:chat_app/helper/firestore_helper.dart';
import 'package:chat_app/models/user.dart' as u;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> syncUserImagetoMessages(String collectionPath,
      String subcollectionPath, String groupId, String userId) async {
    final pref = await SharedPreferences.getInstance();
    final userInfo = u.User.fromJson(pref.getString(FireStoreHelper.userInfo)!);
    final batch = firestore.batch();
    await getChatDataBasedOnUserId(FireStoreHelper.collectionChatsPath,
            FireStoreHelper.subCollectionChatsPath, groupId, userId)
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        batch.update(
            doc.reference, {FireStoreHelper.imageURL: userInfo.imageURL});
      });
      batch.commit();
    });
  }

  bool isUser(String userId, String anotherId) {
    if (userId == anotherId) {
      return true;
    }
    return false;
  }
}
