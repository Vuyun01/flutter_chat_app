import 'dart:io';

import 'package:chat_app/helper/firestore_helper.dart';
import 'package:chat_app/models/user.dart' as u;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  ProfileProvider({
    required this.firebaseAuth,
    required this.firestore,
  });

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStreamData(
      String collectionPath, String userId) {
    return firestore.collection(collectionPath).doc(userId).snapshots();
  }

  UploadTask uploadImageToStorage(Reference ref, File image) {
    return ref.putFile(image);
  }

  Future<void> updateProfileImage(
      Reference ref, String collectionPath, String userId) async {
    await ref.getDownloadURL().then((image) async {
      await firestore
          .collection(collectionPath)
          .doc(userId)
          .update({FireStoreHelper.imageURL: image});
    });
  }

  Future<u.User> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return u.User.fromJson(prefs.getString(FireStoreHelper.userInfo)!);
  }

  Future<void> updateUserInfo(
      u.User userInfo, String collectionPath, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .setString(FireStoreHelper.userInfo, userInfo.toJson())
        .then((_) async {
      await firestore
          .collection(collectionPath)
          .doc(userId)
          .update(userInfo.toMap());
    });
  }
}
